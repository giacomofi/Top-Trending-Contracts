['pragma solidity ^0.4.24;\n', '\n', 'contract BettingInterface {\n', '    // place a bet on a coin(horse) lockBetting\n', '    function placeBet(bytes32 horse) external payable;\n', '    // method to claim the reward amount\n', '    function claim_reward() external;\n', '\n', '    mapping (bytes32 => bool) public winner_horse;\n', '    \n', '    function checkReward() external constant returns (uint);\n', '}\n', '\n', '/**\n', ' * @dev Allows to bet on a race and receive future tokens used to withdraw winnings\n', '*/\n', 'contract HorseFutures {\n', '    \n', '    event Claimed(address indexed Race, uint256 Count);\n', '    event Selling(bytes32 Id, uint256 Amount, uint256 Price, address indexed Race, bytes32 Horse, address indexed Owner);\n', '    event Buying(bytes32 Id, uint256 Amount, uint256 Price, address indexed Race, bytes32 Horse, address indexed Owner);\n', '    event Canceled(bytes32 Id, address indexed Owner,address indexed Race);\n', '    event Bought(bytes32 Id, uint256 Amount, address indexed Owner, address indexed Race);\n', '    event Sold(bytes32 Id, uint256 Amount, address indexed Owner, address indexed Race);\n', '    event BetPlaced(address indexed EthAddr, address indexed Race);\n', '    \n', '    struct Offer\n', '    {\n', '        uint256 Amount;\n', '        bytes32 Horse;\n', '        uint256 Price;\n', '        address Race;\n', '        bool BuyType;\n', '    }\n', '    \n', '    mapping(address => mapping(address => mapping(bytes32 => uint256))) ClaimTokens;\n', '    mapping(address => mapping (bytes32 => uint256)) TotalTokensCoinRace;\n', '    mapping(address => bool) ClaimedRaces;\n', '    \n', '    mapping(address => uint256) toDistributeRace;\n', '    //market\n', '    mapping(bytes32 => Offer) market;\n', '    mapping(bytes32 => address) owner;\n', '    mapping(address => uint256) public marketBalance;\n', '    \n', '    function placeBet(bytes32 horse, address race) external payable\n', '    _validRace(race) {\n', '        BettingInterface raceContract = BettingInterface(race);\n', '        raceContract.placeBet.value(msg.value)(horse);\n', '        uint256 c = uint256(msg.value / 1 finney);\n', '        ClaimTokens[msg.sender][race][horse] += c;\n', '        TotalTokensCoinRace[race][horse] += c;\n', '\n', '        emit BetPlaced(msg.sender, race);\n', '    }\n', '    \n', '    function getOwnedAndTotalTokens(bytes32 horse, address race) external view\n', '    _validRace(race) \n', '    returns(uint256,uint256) {\n', '        return (ClaimTokens[msg.sender][race][horse],TotalTokensCoinRace[race][horse]);\n', '    }\n', '\n', '    // required for the claimed ether to be transfered here\n', '    function() public payable { }\n', '    \n', '    function claim(address race) external\n', '    _validRace(race) {\n', '        BettingInterface raceContract = BettingInterface(race);\n', '        if(!ClaimedRaces[race]) {\n', '            toDistributeRace[race] = raceContract.checkReward();\n', '            raceContract.claim_reward();\n', '            ClaimedRaces[race] = true;\n', '        }\n', '\n', '        uint256 totalWinningTokens = 0;\n', '        uint256 ownedWinningTokens = 0;\n', '\n', '        bool btcWin = raceContract.winner_horse(bytes32("BTC"));\n', '        bool ltcWin = raceContract.winner_horse(bytes32("LTC"));\n', '        bool ethWin = raceContract.winner_horse(bytes32("ETH"));\n', '\n', '        if(btcWin)\n', '        {\n', '            totalWinningTokens += TotalTokensCoinRace[race][bytes32("BTC")];\n', '            ownedWinningTokens += ClaimTokens[msg.sender][race][bytes32("BTC")];\n', '            ClaimTokens[msg.sender][race][bytes32("BTC")] = 0;\n', '        } \n', '        if(ltcWin)\n', '        {\n', '            totalWinningTokens += TotalTokensCoinRace[race][bytes32("LTC")];\n', '            ownedWinningTokens += ClaimTokens[msg.sender][race][bytes32("LTC")];\n', '            ClaimTokens[msg.sender][race][bytes32("LTC")] = 0;\n', '        } \n', '        if(ethWin)\n', '        {\n', '            totalWinningTokens += TotalTokensCoinRace[race][bytes32("ETH")];\n', '            ownedWinningTokens += ClaimTokens[msg.sender][race][bytes32("ETH")];\n', '            ClaimTokens[msg.sender][race][bytes32("ETH")] = 0;\n', '        }\n', '\n', '        uint256 claimerCut = toDistributeRace[race] / totalWinningTokens * ownedWinningTokens;\n', '        \n', '        msg.sender.transfer(claimerCut);\n', '        \n', '        emit Claimed(race, claimerCut);\n', '    }\n', '    \n', '    function sellOffer(uint256 amount, uint256 price, address race, bytes32 horse) external\n', '    _validRace(race) \n', '    _validHorse(horse)\n', '    returns (bytes32) {\n', '        uint256 ownedAmount = ClaimTokens[msg.sender][race][horse];\n', '        require(ownedAmount >= amount);\n', '        require(amount > 0);\n', '        \n', '        bytes32 id = keccak256(abi.encodePacked(amount,price,race,horse,true,block.timestamp));\n', '        require(owner[id] == address(0)); //must not already exist\n', '        \n', '        Offer storage newOffer = market[id];\n', '        \n', '        newOffer.Amount = amount;\n', '        newOffer.Horse = horse;\n', '        newOffer.Price = price;\n', '        newOffer.Race = race;\n', '        newOffer.BuyType = false;\n', '        \n', '        ClaimTokens[msg.sender][race][horse] -= amount;\n', '        owner[id] = msg.sender;\n', '        \n', '        emit Selling(id,amount,price,race,horse,msg.sender);\n', '        \n', '        return id;\n', '    }\n', '\n', '    function getOffer(bytes32 id) external view returns(uint256,bytes32,uint256,address,bool) {\n', '        Offer memory off = market[id];\n', '        return (off.Amount,off.Horse,off.Price,off.Race,off.BuyType);\n', '    }\n', '    \n', '    function buyOffer(uint256 amount, uint256 price, address race, bytes32 horse) external payable\n', '    _validRace(race) \n', '    _validHorse(horse)\n', '    returns (bytes32) {\n', '        require(amount > 0);\n', '        require(price > 0);\n', '        require(msg.value == price * amount);\n', '        bytes32 id = keccak256(abi.encodePacked(amount,price,race,horse,false,block.timestamp));\n', '        require(owner[id] == address(0)); //must not already exist\n', '        \n', '        Offer storage newOffer = market[id];\n', '        \n', '        newOffer.Amount = amount;\n', '        newOffer.Horse = horse;\n', '        newOffer.Price = price;\n', '        newOffer.Race = race;\n', '        newOffer.BuyType = true;\n', '        owner[id] = msg.sender;\n', '        \n', '        emit Buying(id,amount,price,race,horse,msg.sender);\n', '        \n', '        return id;\n', '    }\n', '    \n', '    function cancelOrder(bytes32 id) external {\n', '        require(owner[id] == msg.sender);\n', '        \n', '        Offer memory off = market[id];\n', '        if(off.BuyType) {\n', '            msg.sender.transfer(off.Amount * off.Price);\n', '        }\n', '        else {\n', '            ClaimTokens[msg.sender][off.Race][off.Horse] += off.Amount;\n', '        }\n', '        \n', '\n', '        emit Canceled(id,msg.sender,off.Race);\n', '        delete market[id];\n', '        delete owner[id];\n', '    }\n', '    \n', '    function buy(bytes32 id, uint256 amount) external payable {\n', '        require(owner[id] != address(0));\n', '        require(owner[id] != msg.sender);\n', '        Offer storage off = market[id];\n', '        require(!off.BuyType);\n', '        require(amount <= off.Amount);\n', '        uint256 cost = off.Price * amount;\n', '        require(msg.value >= cost);\n', '        \n', '        ClaimTokens[msg.sender][off.Race][off.Horse] += amount;\n', '        marketBalance[owner[id]] += msg.value;\n', '\n', '        emit Bought(id,amount,msg.sender, off.Race);\n', '        \n', '        if(off.Amount == amount)\n', '        {\n', '            delete market[id];\n', '            delete owner[id];\n', '        }\n', '        else\n', '        {\n', '            off.Amount -= amount;\n', '        }\n', '    }\n', '\n', '    function sell(bytes32 id, uint256 amount) external {\n', '        require(owner[id] != address(0));\n', '        require(owner[id] != msg.sender);\n', '        Offer storage off = market[id];\n', '        require(off.BuyType);\n', '        require(amount <= off.Amount);\n', '        \n', '        uint256 cost = amount * off.Price;\n', '        ClaimTokens[msg.sender][off.Race][off.Horse] -= amount;\n', '        ClaimTokens[owner[id]][off.Race][off.Horse] += amount;\n', '        marketBalance[owner[id]] -= cost;\n', '        marketBalance[msg.sender] += cost;\n', '\n', '        emit Sold(id,amount,msg.sender,off.Race);\n', '        \n', '        if(off.Amount == amount)\n', '        {\n', '            delete market[id];\n', '            delete owner[id];\n', '        }\n', '        else\n', '        {\n', '            off.Amount -= amount;\n', '        }\n', '    }\n', '    \n', '    function withdraw() external {\n', '        msg.sender.transfer(marketBalance[msg.sender]);\n', '        marketBalance[msg.sender] = 0;\n', '    }\n', '    \n', '    modifier _validRace(address race) {\n', '        require(race != address(0));\n', '        _;\n', '    }\n', '\n', '    modifier _validHorse(bytes32 horse) {\n', '        require(horse == bytes32("BTC") || horse == bytes32("ETH") || horse == bytes32("LTC"));\n', '        _;\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract BettingInterface {\n', '    // place a bet on a coin(horse) lockBetting\n', '    function placeBet(bytes32 horse) external payable;\n', '    // method to claim the reward amount\n', '    function claim_reward() external;\n', '\n', '    mapping (bytes32 => bool) public winner_horse;\n', '    \n', '    function checkReward() external constant returns (uint);\n', '}\n', '\n', '/**\n', ' * @dev Allows to bet on a race and receive future tokens used to withdraw winnings\n', '*/\n', 'contract HorseFutures {\n', '    \n', '    event Claimed(address indexed Race, uint256 Count);\n', '    event Selling(bytes32 Id, uint256 Amount, uint256 Price, address indexed Race, bytes32 Horse, address indexed Owner);\n', '    event Buying(bytes32 Id, uint256 Amount, uint256 Price, address indexed Race, bytes32 Horse, address indexed Owner);\n', '    event Canceled(bytes32 Id, address indexed Owner,address indexed Race);\n', '    event Bought(bytes32 Id, uint256 Amount, address indexed Owner, address indexed Race);\n', '    event Sold(bytes32 Id, uint256 Amount, address indexed Owner, address indexed Race);\n', '    event BetPlaced(address indexed EthAddr, address indexed Race);\n', '    \n', '    struct Offer\n', '    {\n', '        uint256 Amount;\n', '        bytes32 Horse;\n', '        uint256 Price;\n', '        address Race;\n', '        bool BuyType;\n', '    }\n', '    \n', '    mapping(address => mapping(address => mapping(bytes32 => uint256))) ClaimTokens;\n', '    mapping(address => mapping (bytes32 => uint256)) TotalTokensCoinRace;\n', '    mapping(address => bool) ClaimedRaces;\n', '    \n', '    mapping(address => uint256) toDistributeRace;\n', '    //market\n', '    mapping(bytes32 => Offer) market;\n', '    mapping(bytes32 => address) owner;\n', '    mapping(address => uint256) public marketBalance;\n', '    \n', '    function placeBet(bytes32 horse, address race) external payable\n', '    _validRace(race) {\n', '        BettingInterface raceContract = BettingInterface(race);\n', '        raceContract.placeBet.value(msg.value)(horse);\n', '        uint256 c = uint256(msg.value / 1 finney);\n', '        ClaimTokens[msg.sender][race][horse] += c;\n', '        TotalTokensCoinRace[race][horse] += c;\n', '\n', '        emit BetPlaced(msg.sender, race);\n', '    }\n', '    \n', '    function getOwnedAndTotalTokens(bytes32 horse, address race) external view\n', '    _validRace(race) \n', '    returns(uint256,uint256) {\n', '        return (ClaimTokens[msg.sender][race][horse],TotalTokensCoinRace[race][horse]);\n', '    }\n', '\n', '    // required for the claimed ether to be transfered here\n', '    function() public payable { }\n', '    \n', '    function claim(address race) external\n', '    _validRace(race) {\n', '        BettingInterface raceContract = BettingInterface(race);\n', '        if(!ClaimedRaces[race]) {\n', '            toDistributeRace[race] = raceContract.checkReward();\n', '            raceContract.claim_reward();\n', '            ClaimedRaces[race] = true;\n', '        }\n', '\n', '        uint256 totalWinningTokens = 0;\n', '        uint256 ownedWinningTokens = 0;\n', '\n', '        bool btcWin = raceContract.winner_horse(bytes32("BTC"));\n', '        bool ltcWin = raceContract.winner_horse(bytes32("LTC"));\n', '        bool ethWin = raceContract.winner_horse(bytes32("ETH"));\n', '\n', '        if(btcWin)\n', '        {\n', '            totalWinningTokens += TotalTokensCoinRace[race][bytes32("BTC")];\n', '            ownedWinningTokens += ClaimTokens[msg.sender][race][bytes32("BTC")];\n', '            ClaimTokens[msg.sender][race][bytes32("BTC")] = 0;\n', '        } \n', '        if(ltcWin)\n', '        {\n', '            totalWinningTokens += TotalTokensCoinRace[race][bytes32("LTC")];\n', '            ownedWinningTokens += ClaimTokens[msg.sender][race][bytes32("LTC")];\n', '            ClaimTokens[msg.sender][race][bytes32("LTC")] = 0;\n', '        } \n', '        if(ethWin)\n', '        {\n', '            totalWinningTokens += TotalTokensCoinRace[race][bytes32("ETH")];\n', '            ownedWinningTokens += ClaimTokens[msg.sender][race][bytes32("ETH")];\n', '            ClaimTokens[msg.sender][race][bytes32("ETH")] = 0;\n', '        }\n', '\n', '        uint256 claimerCut = toDistributeRace[race] / totalWinningTokens * ownedWinningTokens;\n', '        \n', '        msg.sender.transfer(claimerCut);\n', '        \n', '        emit Claimed(race, claimerCut);\n', '    }\n', '    \n', '    function sellOffer(uint256 amount, uint256 price, address race, bytes32 horse) external\n', '    _validRace(race) \n', '    _validHorse(horse)\n', '    returns (bytes32) {\n', '        uint256 ownedAmount = ClaimTokens[msg.sender][race][horse];\n', '        require(ownedAmount >= amount);\n', '        require(amount > 0);\n', '        \n', '        bytes32 id = keccak256(abi.encodePacked(amount,price,race,horse,true,block.timestamp));\n', '        require(owner[id] == address(0)); //must not already exist\n', '        \n', '        Offer storage newOffer = market[id];\n', '        \n', '        newOffer.Amount = amount;\n', '        newOffer.Horse = horse;\n', '        newOffer.Price = price;\n', '        newOffer.Race = race;\n', '        newOffer.BuyType = false;\n', '        \n', '        ClaimTokens[msg.sender][race][horse] -= amount;\n', '        owner[id] = msg.sender;\n', '        \n', '        emit Selling(id,amount,price,race,horse,msg.sender);\n', '        \n', '        return id;\n', '    }\n', '\n', '    function getOffer(bytes32 id) external view returns(uint256,bytes32,uint256,address,bool) {\n', '        Offer memory off = market[id];\n', '        return (off.Amount,off.Horse,off.Price,off.Race,off.BuyType);\n', '    }\n', '    \n', '    function buyOffer(uint256 amount, uint256 price, address race, bytes32 horse) external payable\n', '    _validRace(race) \n', '    _validHorse(horse)\n', '    returns (bytes32) {\n', '        require(amount > 0);\n', '        require(price > 0);\n', '        require(msg.value == price * amount);\n', '        bytes32 id = keccak256(abi.encodePacked(amount,price,race,horse,false,block.timestamp));\n', '        require(owner[id] == address(0)); //must not already exist\n', '        \n', '        Offer storage newOffer = market[id];\n', '        \n', '        newOffer.Amount = amount;\n', '        newOffer.Horse = horse;\n', '        newOffer.Price = price;\n', '        newOffer.Race = race;\n', '        newOffer.BuyType = true;\n', '        owner[id] = msg.sender;\n', '        \n', '        emit Buying(id,amount,price,race,horse,msg.sender);\n', '        \n', '        return id;\n', '    }\n', '    \n', '    function cancelOrder(bytes32 id) external {\n', '        require(owner[id] == msg.sender);\n', '        \n', '        Offer memory off = market[id];\n', '        if(off.BuyType) {\n', '            msg.sender.transfer(off.Amount * off.Price);\n', '        }\n', '        else {\n', '            ClaimTokens[msg.sender][off.Race][off.Horse] += off.Amount;\n', '        }\n', '        \n', '\n', '        emit Canceled(id,msg.sender,off.Race);\n', '        delete market[id];\n', '        delete owner[id];\n', '    }\n', '    \n', '    function buy(bytes32 id, uint256 amount) external payable {\n', '        require(owner[id] != address(0));\n', '        require(owner[id] != msg.sender);\n', '        Offer storage off = market[id];\n', '        require(!off.BuyType);\n', '        require(amount <= off.Amount);\n', '        uint256 cost = off.Price * amount;\n', '        require(msg.value >= cost);\n', '        \n', '        ClaimTokens[msg.sender][off.Race][off.Horse] += amount;\n', '        marketBalance[owner[id]] += msg.value;\n', '\n', '        emit Bought(id,amount,msg.sender, off.Race);\n', '        \n', '        if(off.Amount == amount)\n', '        {\n', '            delete market[id];\n', '            delete owner[id];\n', '        }\n', '        else\n', '        {\n', '            off.Amount -= amount;\n', '        }\n', '    }\n', '\n', '    function sell(bytes32 id, uint256 amount) external {\n', '        require(owner[id] != address(0));\n', '        require(owner[id] != msg.sender);\n', '        Offer storage off = market[id];\n', '        require(off.BuyType);\n', '        require(amount <= off.Amount);\n', '        \n', '        uint256 cost = amount * off.Price;\n', '        ClaimTokens[msg.sender][off.Race][off.Horse] -= amount;\n', '        ClaimTokens[owner[id]][off.Race][off.Horse] += amount;\n', '        marketBalance[owner[id]] -= cost;\n', '        marketBalance[msg.sender] += cost;\n', '\n', '        emit Sold(id,amount,msg.sender,off.Race);\n', '        \n', '        if(off.Amount == amount)\n', '        {\n', '            delete market[id];\n', '            delete owner[id];\n', '        }\n', '        else\n', '        {\n', '            off.Amount -= amount;\n', '        }\n', '    }\n', '    \n', '    function withdraw() external {\n', '        msg.sender.transfer(marketBalance[msg.sender]);\n', '        marketBalance[msg.sender] = 0;\n', '    }\n', '    \n', '    modifier _validRace(address race) {\n', '        require(race != address(0));\n', '        _;\n', '    }\n', '\n', '    modifier _validHorse(bytes32 horse) {\n', '        require(horse == bytes32("BTC") || horse == bytes32("ETH") || horse == bytes32("LTC"));\n', '        _;\n', '    }\n', '    \n', '}']

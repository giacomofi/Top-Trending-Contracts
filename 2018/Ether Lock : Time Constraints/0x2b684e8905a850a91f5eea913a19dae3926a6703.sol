['pragma solidity ^0.4.21;\n', '\n', 'library BWUtility {\n', '    \n', '    // -------- UTILITY FUNCTIONS ----------\n', '\n', '\n', '    // Return next higher even _multiple for _amount parameter (e.g used to round up to even finneys).\n', '    function ceil(uint _amount, uint _multiple) pure public returns (uint) {\n', '        return ((_amount + _multiple - 1) / _multiple) * _multiple;\n', '    }\n', '\n', '    // Checks if two coordinates are adjacent:\n', '    // xxx\n', '    // xox\n', '    // xxx\n', '    // All x (_x2, _xy2) are adjacent to o (_x1, _y1) in this ascii image. \n', '    // Adjacency does not wrapp around map edges so if y2 = 255 and y1 = 0 then they are not ajacent\n', '    function isAdjacent(uint8 _x1, uint8 _y1, uint8 _x2, uint8 _y2) pure public returns (bool) {\n', '        return ((_x1 == _x2 &&      (_y2 - _y1 == 1 || _y1 - _y2 == 1))) ||      // Same column\n', '               ((_y1 == _y2 &&      (_x2 - _x1 == 1 || _x1 - _x2 == 1))) ||      // Same row\n', '               ((_x2 - _x1 == 1 &&  (_y2 - _y1 == 1 || _y1 - _y2 == 1))) ||      // Right upper or lower diagonal\n', '               ((_x1 - _x2 == 1 &&  (_y2 - _y1 == 1 || _y1 - _y2 == 1)));        // Left upper or lower diagonal\n', '    }\n', '\n', '    // Converts (x, y) to tileId xy\n', '    function toTileId(uint8 _x, uint8 _y) pure public returns (uint16) {\n', '        return uint16(_x) << 8 | uint16(_y);\n', '    }\n', '\n', '    // Converts _tileId to (x, y)\n', '    function fromTileId(uint16 _tileId) pure public returns (uint8, uint8) {\n', '        uint8 y = uint8(_tileId);\n', '        uint8 x = uint8(_tileId >> 8);\n', '        return (x, y);\n', '    }\n', '    \n', '    function getBoostFromTile(address _claimer, address _attacker, address _defender, uint _blockValue) pure public returns (uint, uint) {\n', '        if (_claimer == _attacker) {\n', '            return (_blockValue, 0);\n', '        } else if (_claimer == _defender) {\n', '            return (0, _blockValue);\n', '        }\n', '    }\n', '}\n', '\n', 'contract BWData {\n', '    address public owner;\n', '    address private bwService;\n', '    address private bw;\n', '    address private bwMarket;\n', '\n', '    uint private blockValueBalance = 0;\n', '    uint private feeBalance = 0;\n', '    uint private BASE_TILE_PRICE_WEI = 1 finney; // 1 milli-ETH.\n', '    \n', '    mapping (address => User) private users; // user address -> user information\n', '    mapping (uint16 => Tile) private tiles; // tileId -> list of TileClaims for that particular tile\n', '    \n', '    // Info about the users = those who have purchased tiles.\n', '    struct User {\n', '        uint creationTime;\n', '        bool censored;\n', '        uint battleValue;\n', '    }\n', '\n', '    // Info about a tile ownership\n', '    struct Tile {\n', '        address claimer;\n', '        uint blockValue;\n', '        uint creationTime;\n', '        uint sellPrice;    // If 0 -> not on marketplace. If > 0 -> on marketplace.\n', '    }\n', '\n', '    struct Boost {\n', '        uint8 numAttackBoosts;\n', '        uint8 numDefendBoosts;\n', '        uint attackBoost;\n', '        uint defendBoost;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // Can&#39;t send funds straight to this contract. Avoid people sending by mistake.\n', '    function () payable public {\n', '        revert();\n', '    }\n', '\n', '    function kill() public isOwner {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    modifier isValidCaller {\n', '        if (msg.sender != bwService && msg.sender != bw && msg.sender != bwMarket) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '    \n', '    modifier isOwner {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '    \n', '    function setBwServiceValidCaller(address _bwService) public isOwner {\n', '        bwService = _bwService;\n', '    }\n', '\n', '    function setBwValidCaller(address _bw) public isOwner {\n', '        bw = _bw;\n', '    }\n', '\n', '    function setBwMarketValidCaller(address _bwMarket) public isOwner {\n', '        bwMarket = _bwMarket;\n', '    }    \n', '    \n', '    // ----------USER-RELATED GETTER FUNCTIONS------------\n', '    \n', '    //function getUser(address _user) view public returns (bytes32) {\n', '        //BWUtility.User memory user = users[_user];\n', '        //require(user.creationTime != 0);\n', '        //return (user.creationTime, user.imageUrl, user.tag, user.email, user.homeUrl, user.creationTime, user.censored, user.battleValue);\n', '    //}\n', '    \n', '    function addUser(address _msgSender) public isValidCaller {\n', '        User storage user = users[_msgSender];\n', '        require(user.creationTime == 0);\n', '        user.creationTime = block.timestamp;\n', '    }\n', '\n', '    function hasUser(address _user) view public isValidCaller returns (bool) {\n', '        return users[_user].creationTime != 0;\n', '    }\n', '    \n', '\n', '    // ----------TILE-RELATED GETTER FUNCTIONS------------\n', '\n', '    function getTile(uint16 _tileId) view public isValidCaller returns (address, uint, uint, uint) {\n', '        Tile storage currentTile = tiles[_tileId];\n', '        return (currentTile.claimer, currentTile.blockValue, currentTile.creationTime, currentTile.sellPrice);\n', '    }\n', '    \n', '    function getTileClaimerAndBlockValue(uint16 _tileId) view public isValidCaller returns (address, uint) {\n', '        Tile storage currentTile = tiles[_tileId];\n', '        return (currentTile.claimer, currentTile.blockValue);\n', '    }\n', '    \n', '    function isNewTile(uint16 _tileId) view public isValidCaller returns (bool) {\n', '        Tile storage currentTile = tiles[_tileId];\n', '        return currentTile.creationTime == 0;\n', '    }\n', '    \n', '    function storeClaim(uint16 _tileId, address _claimer, uint _blockValue) public isValidCaller {\n', '        tiles[_tileId] = Tile(_claimer, _blockValue, block.timestamp, 0);\n', '    }\n', '\n', '    function updateTileBlockValue(uint16 _tileId, uint _blockValue) public isValidCaller {\n', '        tiles[_tileId].blockValue = _blockValue;\n', '    }\n', '\n', '    function setClaimerForTile(uint16 _tileId, address _claimer) public isValidCaller {\n', '        tiles[_tileId].claimer = _claimer;\n', '    }\n', '\n', '    function updateTileTimeStamp(uint16 _tileId) public isValidCaller {\n', '        tiles[_tileId].creationTime = block.timestamp;\n', '    }\n', '    \n', '    function getCurrentClaimerForTile(uint16 _tileId) view public isValidCaller returns (address) {\n', '        Tile storage currentTile = tiles[_tileId];\n', '        if (currentTile.creationTime == 0) {\n', '            return 0;\n', '        }\n', '        return currentTile.claimer;\n', '    }\n', '\n', '    function getCurrentBlockValueAndSellPriceForTile(uint16 _tileId) view public isValidCaller returns (uint, uint) {\n', '        Tile storage currentTile = tiles[_tileId];\n', '        if (currentTile.creationTime == 0) {\n', '            return (0, 0);\n', '        }\n', '        return (currentTile.blockValue, currentTile.sellPrice);\n', '    }\n', '    \n', '    function getBlockValueBalance() view public isValidCaller returns (uint){\n', '        return blockValueBalance;\n', '    }\n', '\n', '    function setBlockValueBalance(uint _blockValueBalance) public isValidCaller {\n', '        blockValueBalance = _blockValueBalance;\n', '    }\n', '\n', '    function getFeeBalance() view public isValidCaller returns (uint) {\n', '        return feeBalance;\n', '    }\n', '\n', '    function setFeeBalance(uint _feeBalance) public isValidCaller {\n', '        feeBalance = _feeBalance;\n', '    }\n', '    \n', '    function getUserBattleValue(address _userId) view public isValidCaller returns (uint) {\n', '        return users[_userId].battleValue;\n', '    }\n', '    \n', '    function setUserBattleValue(address _userId, uint _battleValue) public  isValidCaller {\n', '        users[_userId].battleValue = _battleValue;\n', '    }\n', '    \n', '    function verifyAmount(address _msgSender, uint _msgValue, uint _amount, bool _useBattleValue) view public isValidCaller {\n', '        User storage user = users[_msgSender];\n', '        require(user.creationTime != 0);\n', '\n', '        if (_useBattleValue) {\n', '            require(_msgValue == 0);\n', '            require(user.battleValue >= _amount);\n', '        } else {\n', '            require(_amount == _msgValue);\n', '        }\n', '    }\n', '    \n', '    function addBoostFromTile(Tile _tile, address _attacker, address _defender, Boost memory _boost) pure private {\n', '        if (_tile.claimer == _attacker) {\n', '            require(_boost.attackBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow\n', '            _boost.attackBoost += _tile.blockValue;\n', '            _boost.numAttackBoosts += 1;\n', '        } else if (_tile.claimer == _defender) {\n', '            require(_boost.defendBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow\n', '            _boost.defendBoost += _tile.blockValue;\n', '            _boost.numDefendBoosts += 1;\n', '        }\n', '    }\n', '\n', '    function calculateBattleBoost(uint16 _tileId, address _attacker, address _defender) view public isValidCaller returns (uint, uint) {\n', '        uint8 x;\n', '        uint8 y;\n', '\n', '        (x, y) = BWUtility.fromTileId(_tileId);\n', '\n', '        Boost memory boost = Boost(0, 0, 0, 0);\n', '        // We overflow x, y on purpose here if x or y is 0 or 255 - the map overflows and so should adjacency.\n', '        // Go through all adjacent tiles to (x, y).\n', '        if (y != 255) {\n', '            if (x != 255) {\n', '                addBoostFromTile(tiles[BWUtility.toTileId(x+1, y+1)], _attacker, _defender, boost);\n', '            }\n', '            \n', '            addBoostFromTile(tiles[BWUtility.toTileId(x, y+1)], _attacker, _defender, boost);\n', '\n', '            if (x != 0) {\n', '                addBoostFromTile(tiles[BWUtility.toTileId(x-1, y+1)], _attacker, _defender, boost);\n', '            }\n', '        }\n', '\n', '        if (x != 255) {\n', '            addBoostFromTile(tiles[BWUtility.toTileId(x+1, y)], _attacker, _defender, boost);\n', '        }\n', '\n', '        if (x != 0) {\n', '            addBoostFromTile(tiles[BWUtility.toTileId(x-1, y)], _attacker, _defender, boost);\n', '        }\n', '\n', '        if (y != 0) {\n', '            if(x != 255) {\n', '                addBoostFromTile(tiles[BWUtility.toTileId(x+1, y-1)], _attacker, _defender, boost);\n', '            }\n', '\n', '            addBoostFromTile(tiles[BWUtility.toTileId(x, y-1)], _attacker, _defender, boost);\n', '\n', '            if(x != 0) {\n', '                addBoostFromTile(tiles[BWUtility.toTileId(x-1, y-1)], _attacker, _defender, boost);\n', '            }\n', '        }\n', '        // The benefit of boosts is multiplicative (quadratic):\n', '        // - More boost tiles gives a higher total blockValue (the sum of the adjacent tiles)\n', '        // - More boost tiles give a higher multiple of that total blockValue that can be used (10% per adjacent tie)\n', '        // Example:\n', '        //   A) I boost attack with 1 single tile worth 10 finney\n', '        //      -> Total boost is 10 * 1 / 10 = 1 finney\n', '        //   B) I boost attack with 3 tiles worth 1 finney each\n', '        //      -> Total boost is (1+1+1) * 3 / 10 = 0.9 finney\n', '        //   C) I boost attack with 8 tiles worth 2 finney each\n', '        //      -> Total boost is (2+2+2+2+2+2+2+2) * 8 / 10 = 14.4 finney\n', '        //   D) I boost attack with 3 tiles of 1, 5 and 10 finney respectively\n', '        //      -> Total boost is (ss1+5+10) * 3 / 10 = 4.8 finney\n', '        // This division by 10 can&#39;t create fractions since our uint is wei, and we can&#39;t have overflow from the multiplication\n', '        // We do allow fractions of finney here since the boosted values aren&#39;t stored anywhere, only used for attack rolls and sent in events\n', '        boost.attackBoost = (boost.attackBoost / 10 * boost.numAttackBoosts);\n', '        boost.defendBoost = (boost.defendBoost / 10 * boost.numDefendBoosts);\n', '\n', '        return (boost.attackBoost, boost.defendBoost);\n', '    }\n', '    \n', '    function censorUser(address _userAddress, bool _censored) public isValidCaller {\n', '        User storage user = users[_userAddress];\n', '        require(user.creationTime != 0);\n', '        user.censored = _censored;\n', '    }\n', '    \n', '    function deleteTile(uint16 _tileId) public isValidCaller {\n', '        delete tiles[_tileId];\n', '    }\n', '    \n', '    function setSellPrice(uint16 _tileId, uint _sellPrice) public isValidCaller {\n', '        tiles[_tileId].sellPrice = _sellPrice;  //testrpc cannot estimate gas when delete is used.\n', '    }\n', '\n', '    function deleteOffer(uint16 _tileId) public isValidCaller {\n', '        tiles[_tileId].sellPrice = 0;  //testrpc cannot estimate gas when delete is used.\n', '    }\n', '}\n', '\n', '\n', 'interface ERC20I {\n', '    function transfer(address _recipient, uint256 _amount) external returns (bool);\n', '    function balanceOf(address _holder) external view returns (uint256);\n', '}\n', '\n', '\n', 'contract BWService {\n', '    address private owner;\n', '    address private bw;\n', '    address private bwMarket;\n', '    BWData private bwData;\n', '    uint private seed = 42;\n', '    uint private WITHDRAW_FEE = 20; //1/20 = 5%\n', '    \n', '    modifier isOwner {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }  \n', '\n', '    modifier isValidCaller {\n', '        if (msg.sender != bw && msg.sender != bwMarket) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    event TileClaimed(uint16 tileId, address newClaimer, uint priceInWei, uint creationTime);\n', '    event TileFortified(uint16 tileId, address claimer, uint addedValueInWei, uint priceInWei, uint fortifyTime); // Sent when a user fortifies an existing claim by bumping its value.\n', '    event TileAttackedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint attackTime); // Sent when a user successfully attacks a tile.    \n', '    event TileDefendedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint defendTime); // Sent when a user successfully defends a tile when attacked.    \n', '    event BlockValueMoved(uint16 sourceTileId, uint16 destTileId, address owner, uint movedBlockValue, uint postSourceValue, uint postDestValue, uint moveTime); // Sent when a user buys a tile from another user, by accepting a tile offer\n', '    event UserBattleValueUpdated(address userAddress, uint battleValue, bool isWithdraw);\n', '\n', '    // Constructor.\n', '    constructor(address _bwData) public {\n', '        bwData = BWData(_bwData);\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // Can&#39;t send funds straight to this contract. Avoid people sending by mistake.\n', '    function () payable public {\n', '        revert();\n', '    }\n', '\n', '    // OWNER-ONLY FUNCTIONS\n', '    function kill() public isOwner {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function setValidBwCaller(address _bw) public isOwner {\n', '        bw = _bw;\n', '    }\n', '    \n', '    function setValidBwMarketCaller(address _bwMarket) public isOwner {\n', '        bwMarket = _bwMarket;\n', '    }\n', '\n', '\n', '    // TILE-RELATED FUNCTIONS\n', '    // This function claims multiple previously unclaimed tiles in a single transaction.\n', '    // The value assigned to each tile is the msg.value divided by the number of tiles claimed.\n', '    // The msg.value is required to be an even multiple of the number of tiles claimed.\n', '    function storeInitialClaim(address _msgSender, uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) public isValidCaller {\n', '        uint tileCount = _claimedTileIds.length;\n', '        require(tileCount > 0);\n', '        require(_claimAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles\n', '        require(_claimAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles claimed\n', '\n', '        uint valuePerBlockInWei = _claimAmount / tileCount; // Due to requires above this is guaranteed to be an even number\n', '\n', '        if (_useBattleValue) {\n', '            subUserBattleValue(_msgSender, _claimAmount, false);  \n', '        }\n', '\n', '        addGlobalBlockValueBalance(_claimAmount);\n', '\n', '        uint16 tileId;\n', '        bool isNewTile;\n', '        for (uint16 i = 0; i < tileCount; i++) {\n', '            tileId = _claimedTileIds[i];\n', '            isNewTile = bwData.isNewTile(tileId); // Is length 0 if first time purchased\n', '            require(isNewTile); // Can only claim previously unclaimed tiles.\n', '\n', '            // Send claim event\n', '            emit TileClaimed(tileId, _msgSender, valuePerBlockInWei, block.timestamp);\n', '\n', '            // Update contract state with new tile ownership.\n', '            bwData.storeClaim(tileId, _msgSender, valuePerBlockInWei);\n', '        }\n', '    }\n', '\n', '    function fortifyClaims(address _msgSender, uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) public isValidCaller {\n', '        uint tileCount = _claimedTileIds.length;\n', '        require(tileCount > 0);\n', '\n', '        uint balance = address(this).balance;\n', '        require(balance + _fortifyAmount > balance); // prevent overflow\n', '        require(_fortifyAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles fortified\n', '        uint addedValuePerTileInWei = _fortifyAmount / tileCount; // Due to requires above this is guaranteed to be an even number\n', '        require(_fortifyAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles\n', '\n', '        address claimer;\n', '        uint blockValue;\n', '        for (uint16 i = 0; i < tileCount; i++) {\n', '            (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_claimedTileIds[i]);\n', '            require(claimer != 0); // Can&#39;t do this on never-owned tiles\n', '            require(claimer == _msgSender); // Only current claimer can fortify claim\n', '\n', '            if (_useBattleValue) {\n', '                subUserBattleValue(_msgSender, addedValuePerTileInWei, false);\n', '            }\n', '            \n', '            fortifyClaim(_msgSender, _claimedTileIds[i], addedValuePerTileInWei);\n', '        }\n', '    }\n', '\n', '    function fortifyClaim(address _msgSender, uint16 _claimedTileId, uint _fortifyAmount) private {\n', '        uint blockValue;\n', '        uint sellPrice;\n', '        (blockValue, sellPrice) = bwData.getCurrentBlockValueAndSellPriceForTile(_claimedTileId);\n', '        uint updatedBlockValue = blockValue + _fortifyAmount;\n', '        // Send fortify event\n', '        emit TileFortified(_claimedTileId, _msgSender, _fortifyAmount, updatedBlockValue, block.timestamp);\n', '        \n', '        // Update tile value. The tile has been fortified by bumping up its value.\n', '        bwData.updateTileBlockValue(_claimedTileId, updatedBlockValue);\n', '\n', '        // Track addition to global block value\n', '        addGlobalBlockValueBalance(_fortifyAmount);\n', '    }\n', '\n', '    // Return a pseudo random number between lower and upper bounds\n', '    // given the number of previous blocks it should hash.\n', '    // Random function copied from https://github.com/axiomzen/eth-random/blob/master/contracts/Random.sol.\n', '    // Changed sha3 to keccak256.\n', '    // Changed random range from uint64 to uint (=uint256).\n', '    function random(uint _upper) private returns (uint)  {\n', '        seed = uint(keccak256(keccak256(blockhash(block.number), seed), now));\n', '        return seed % _upper;\n', '    }\n', '\n', '    // A user tries to claim a tile that&#39;s already owned by another user. A battle ensues.\n', '    // A random roll is done with % based on attacking vs defending amounts.\n', '    function attackTile(address _msgSender, uint16 _tileId, uint _attackAmount, bool _useBattleValue, bool _autoFortify) public isValidCaller {\n', '        require(_attackAmount >= 1 finney);         // Don&#39;t allow attacking with less than one base tile price.\n', '        require(_attackAmount % 1 finney == 0);\n', '\n', '        address claimer;\n', '        uint blockValue;\n', '        (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_tileId);\n', '        \n', '        require(claimer != 0); // Can&#39;t do this on never-owned tiles\n', '        require(claimer != _msgSender); // Can&#39;t attack one&#39;s own tiles\n', '        require(claimer != owner); // Can&#39;t attack owner&#39;s tiles because it is used for raffle.\n', '\n', '        // Calculate boosted amounts for attacker and defender\n', '        // The base attack amount is sent in the by the user.\n', '        // The base defend amount is the attacked tile&#39;s current blockValue.\n', '        uint attackBoost;\n', '        uint defendBoost;\n', '        (attackBoost, defendBoost) = bwData.calculateBattleBoost(_tileId, _msgSender, claimer);\n', '        uint totalAttackAmount = _attackAmount + attackBoost;\n', '        uint totalDefendAmount = blockValue + defendBoost;\n', '        require(totalAttackAmount >= _attackAmount); // prevent overflow\n', '        require(totalDefendAmount >= blockValue); // prevent overflow\n', '        require(totalAttackAmount + totalDefendAmount > totalAttackAmount && totalAttackAmount + totalDefendAmount > totalDefendAmount); // Prevent overflow\n', '\n', '        // Verify that attack odds are within allowed range.\n', '        require(totalAttackAmount / 10 <= blockValue); // Disallow attacks with more than 1000% of defendAmount\n', '        require(totalAttackAmount >= blockValue / 10); // Disallow attacks with less than 10% of defendAmount\n', '\n', '        // The battle considers boosts.\n', '        uint attackRoll = random(totalAttackAmount + totalDefendAmount); // This is where the excitement happens!\n', '        if (attackRoll > totalDefendAmount) {\n', '            // Send update event\n', '            emit TileAttackedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);\n', '\n', '            // Change block owner but keep same block value (attacker got battlevalue instead)\n', '            bwData.setClaimerForTile(_tileId, _msgSender);\n', '\n', '            // Tile successfully attacked!\n', '            if (_useBattleValue) {\n', '                if (_autoFortify) {\n', '                    // Fortify the won tile using battle value\n', '                    fortifyClaim(_msgSender, _tileId, _attackAmount);\n', '                    subUserBattleValue(_msgSender, _attackAmount, false);\n', '                } else {\n', '                    // No reason to withdraw followed by deposit of same amount\n', '                }\n', '            } else {\n', '                if (_autoFortify) {\n', '                    // Fortify the won tile using attack amount\n', '                    fortifyClaim(_msgSender, _tileId, _attackAmount);\n', '                } else {\n', '                    addUserBattleValue(_msgSender, _attackAmount); // Don&#39;t include boost here!\n', '                }\n', '            }\n', '        } else {\n', '            // Tile successfully defended!\n', '            if (_useBattleValue) {\n', '                subUserBattleValue(_msgSender, _attackAmount, false); // Don&#39;t include boost here!\n', '            }\n', '            addUserBattleValue(claimer, _attackAmount); // Don&#39;t include boost here!\n', '\n', '            // Send update event\n', '            emit TileDefendedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);\n', '\n', '            // Update the timestamp for the defended block.\n', '            bwData.updateTileTimeStamp(_tileId);\n', '        }\n', '    }\n', '\n', '    function moveBlockValue(address _msgSender, uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isValidCaller {\n', '        uint16 sourceTileId = BWUtility.toTileId(_xSource, _ySource);\n', '        uint16 destTileId = BWUtility.toTileId(_xDest, _yDest);\n', '\n', '        address sourceTileClaimer;\n', '        address destTileClaimer;\n', '        uint sourceTileBlockValue;\n', '        uint destTileBlockValue;\n', '        (sourceTileClaimer, sourceTileBlockValue) = bwData.getTileClaimerAndBlockValue(sourceTileId);\n', '        (destTileClaimer, destTileBlockValue) = bwData.getTileClaimerAndBlockValue(destTileId);\n', '\n', '        require(sourceTileClaimer == _msgSender);\n', '        require(destTileClaimer == _msgSender);\n', '        require(_moveAmount >= 1 finney); // Can&#39;t be less\n', '        require(_moveAmount % 1 finney == 0); // Move amount must be in multiples of 1 finney\n', '        // require(sourceTile.blockValue - _moveAmount >= BASE_TILE_PRICE_WEI); // Must always leave some at source\n', '        \n', '        require(sourceTileBlockValue - _moveAmount < sourceTileBlockValue); // Prevent overflow\n', '        require(destTileBlockValue + _moveAmount > destTileBlockValue); // Prevent overflow\n', '        require(BWUtility.isAdjacent(_xSource, _ySource, _xDest, _yDest));\n', '\n', '        sourceTileBlockValue -= _moveAmount;\n', '        destTileBlockValue += _moveAmount;\n', '\n', '        // If ALL block value was moved away from the source tile, we lose our claim to it. It becomes ownerless.\n', '        if (sourceTileBlockValue == 0) {\n', '            bwData.deleteTile(sourceTileId);\n', '        } else {\n', '            bwData.updateTileBlockValue(sourceTileId, sourceTileBlockValue);\n', '            bwData.deleteOffer(sourceTileId); // Offer invalid since block value has changed\n', '        }\n', '\n', '        bwData.updateTileBlockValue(destTileId, destTileBlockValue);\n', '        bwData.deleteOffer(destTileId);   // Offer invalid since block value has changed\n', '        emit BlockValueMoved(sourceTileId, destTileId, _msgSender, _moveAmount, sourceTileBlockValue, destTileBlockValue, block.timestamp);        \n', '    }\n', '\n', '\n', '    // BATTLE VALUE FUNCTIONS\n', '    function withdrawBattleValue(address msgSender, uint _battleValueInWei) public isValidCaller returns (uint) {\n', '        require(bwData.hasUser(msgSender));\n', '        require(_battleValueInWei % 1 finney == 0); // Must be divisible by 1 finney\n', '        uint fee = _battleValueInWei / WITHDRAW_FEE; // Since we divide by 20 we can never create infinite fractions, so we&#39;ll always count in whole wei amounts.\n', '        require(_battleValueInWei - fee < _battleValueInWei); // prevent underflow\n', '\n', '        uint amountToWithdraw = _battleValueInWei - fee;\n', '        uint feeBalance = bwData.getFeeBalance();\n', '        require(feeBalance + fee >= feeBalance); // prevent overflow\n', '        feeBalance += fee;\n', '        bwData.setFeeBalance(feeBalance);\n', '        subUserBattleValue(msgSender, _battleValueInWei, true);\n', '        return amountToWithdraw;\n', '    }\n', '\n', '    function addUserBattleValue(address _userId, uint _amount) public isValidCaller {\n', '        uint userBattleValue = bwData.getUserBattleValue(_userId);\n', '        require(userBattleValue + _amount > userBattleValue); // prevent overflow\n', '        uint newBattleValue = userBattleValue + _amount;\n', '        bwData.setUserBattleValue(_userId, newBattleValue); // Don&#39;t include boost here!\n', '        emit UserBattleValueUpdated(_userId, newBattleValue, false);\n', '    }\n', '    \n', '    function subUserBattleValue(address _userId, uint _amount, bool _isWithdraw) public isValidCaller {\n', '        uint userBattleValue = bwData.getUserBattleValue(_userId);\n', '        require(_amount <= userBattleValue); // Must be less than user&#39;s battle value - also implicitly checks that underflow isn&#39;t possible\n', '        uint newBattleValue = userBattleValue - _amount;\n', '        bwData.setUserBattleValue(_userId, newBattleValue); // Don&#39;t include boost here!\n', '        emit UserBattleValueUpdated(_userId, newBattleValue, _isWithdraw);\n', '    }\n', '\n', '    function addGlobalBlockValueBalance(uint _amount) public isValidCaller {\n', '        // Track addition to global block value.\n', '        uint blockValueBalance = bwData.getBlockValueBalance();\n', '        require(blockValueBalance + _amount > blockValueBalance); // Prevent overflow\n', '        bwData.setBlockValueBalance(blockValueBalance + _amount);\n', '    }\n', '\n', '    // Allow us to transfer out airdropped tokens if we ever receive any\n', '    function transferTokens(address _tokenAddress, address _recipient) public isOwner {\n', '        ERC20I token = ERC20I(_tokenAddress);\n', '        require(token.transfer(_recipient, token.balanceOf(this)));\n', '    }\n', '}']
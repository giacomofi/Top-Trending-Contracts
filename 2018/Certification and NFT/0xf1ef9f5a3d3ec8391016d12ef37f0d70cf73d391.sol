['pragma solidity ^0.4.18;\n', '\n', 'contract EMPresale {\n', '    \n', '    bool inMaintainance;\n', '    bool isRefundable;\n', '    \n', '    // Data -----------------------------\n', '    \n', '    struct Player {\n', '        uint32 id;  // if 0, then player don&#39;t exist\n', '        mapping(uint8 => uint8) bought;\n', '        uint256 weiSpent;\n', '        bool hasSpent;\n', '    }\n', '    \n', '    struct Sale {\n', '        uint8 bought;\n', '        uint8 maxBought;\n', '        uint32 cardTypeID;\n', '        uint256 price;\n', '        uint256 saleEndTime;\n', '        \n', '        bool isAirdrop;     // enables minting (+maxBought per hour until leftToMint==0)\n', '                            // + each player can only buy once\n', '                            // + is free\n', '        uint256 nextMintTime;\n', '        uint8 leftToMint;\n', '    }\n', '    \n', '    address admin;\n', '    address[] approverArr; // for display purpose only\n', '    mapping(address => bool) approvers;\n', '    \n', '    address[] playerAddrs;      // 0 index not used\n', '    uint32[] playerRefCounts;   // 0 index not used\n', '    \n', '    mapping(address => Player) players;\n', '    mapping(uint8 => Sale) sales;   // use from 1 onwards\n', '    uint256 refPrize;\n', '    \n', '    // CONSTRUCTOR =======================\n', '    \n', '    function EMPresale() public {\n', '        admin = msg.sender;\n', '        approverArr.push(admin);\n', '        approvers[admin] = true;\n', '        \n', '        playerAddrs.push(address(0));\n', '        playerRefCounts.push(0);\n', '    }\n', '    \n', '    // ADMIN FUNCTIONS =======================\n', '    \n', '    function setSaleType_Presale(uint8 saleID, uint8 maxBought, uint32 cardTypeID, uint256 price, uint256 saleEndTime) external onlyAdmin {\n', '        Sale storage sale = sales[saleID];\n', '        \n', '        // assign sale type\n', '        sale.bought = 0;\n', '        sale.maxBought = maxBought;\n', '        sale.cardTypeID = cardTypeID;\n', '        sale.price = price;\n', '        sale.saleEndTime = saleEndTime;\n', '        \n', '        // airdrop type\n', '        sale.isAirdrop = false;\n', '    }\n', '    \n', '    function setSaleType_Airdrop(uint8 saleID, uint8 maxBought, uint32 cardTypeID, uint8 leftToMint, uint256 firstMintTime) external onlyAdmin {\n', '        Sale storage sale = sales[saleID];\n', '        \n', '        // assign sale type\n', '        sale.bought = 0;\n', '        sale.maxBought = maxBought;\n', '        sale.cardTypeID = cardTypeID;\n', '        sale.price = 0;\n', '        sale.saleEndTime = 2000000000;\n', '        \n', '        // airdrop type\n', '        require(leftToMint >= maxBought);\n', '        sale.isAirdrop = true;\n', '        sale.nextMintTime = firstMintTime;\n', '        sale.leftToMint = leftToMint - maxBought;\n', '    }\n', '    \n', '    function stopSaleType(uint8 saleID) external onlyAdmin {\n', '        delete sales[saleID].saleEndTime;\n', '    }\n', '    \n', '    function redeemCards(address playerAddr, uint8 saleID) external onlyApprover returns(uint8) {\n', '        Player storage player = players[playerAddr];\n', '        uint8 owned = player.bought[saleID];\n', '        player.bought[saleID] = 0;\n', '        return owned;\n', '    }\n', '    \n', '    function setRefundable(bool refundable) external onlyAdmin {\n', '        isRefundable = refundable;\n', '    }\n', '    \n', '    function refund() external {\n', '        require(isRefundable);\n', '        Player storage player = players[msg.sender];\n', '        uint256 spent = player.weiSpent;\n', '        player.weiSpent = 0;\n', '        msg.sender.transfer(spent);\n', '    }\n', '    \n', '    // PLAYER FUNCTIONS ========================\n', '    \n', '    function buySaleNonReferral(uint8 saleID) external payable {\n', '        buySale(saleID, address(0));\n', '    }\n', '    \n', '    function buySaleReferred(uint8 saleID, address referral) external payable {\n', '        buySale(saleID, referral);\n', '    }\n', '    \n', '    function buySale(uint8 saleID, address referral) private {\n', '        \n', '        require(!inMaintainance);\n', '        require(msg.sender != address(0));\n', '        \n', '        // check that sale is still on\n', '        Sale storage sale = sales[saleID];\n', '        require(sale.saleEndTime > now);\n', '        \n', '        bool isAirdrop = sale.isAirdrop;\n', '        if(isAirdrop) {\n', '            // airdrop minting\n', '            if(now >= sale.nextMintTime) {  // hit a cycle\n', '            \n', '                sale.nextMintTime += ((now-sale.nextMintTime)/3600)*3600+3600;   // mint again next hour\n', '                if(sale.bought != 0) {\n', '                    uint8 leftToMint = sale.leftToMint;\n', '                    if(leftToMint < sale.bought) { // not enough to recover, set maximum left to be bought\n', '                        sale.maxBought = sale.maxBought + leftToMint - sale.bought;\n', '                        sale.leftToMint = 0;\n', '                    } else\n', '                        sale.leftToMint -= sale.bought;\n', '                    sale.bought = 0;\n', '                }\n', '            }\n', '        } else {\n', '            // check ether is paid\n', '            require(msg.value >= sale.price);\n', '        }\n', '\n', '        // check not all is bought\n', '        require(sale.bought < sale.maxBought);\n', '        sale.bought++;\n', '        \n', '        bool toRegisterPlayer = false;\n', '        bool toRegisterReferral = false;\n', '        \n', '        // register player if unregistered\n', '        Player storage player = players[msg.sender];\n', '        if(player.id == 0)\n', '            toRegisterPlayer = true;\n', '            \n', '        // cannot buy more than once if airdrop\n', '        if(isAirdrop)\n', '            require(player.bought[saleID] == 0);\n', '        \n', '        // give ownership\n', '        player.bought[saleID]++;\n', '        if(!isAirdrop)  // is free otherwise\n', '            player.weiSpent += msg.value;\n', '        \n', '        // if hasn&#39;t referred, add referral\n', '        if(!player.hasSpent) {\n', '            player.hasSpent = true;\n', '            if(referral != address(0) && referral != msg.sender) {\n', '                Player storage referredPlayer = players[referral];\n', '                if(referredPlayer.id == 0) {    // add referred player if unregistered\n', '                    toRegisterReferral = true;\n', '                } else {                        // if already registered, just up ref count\n', '                    playerRefCounts[referredPlayer.id]++;\n', '                }\n', '            }\n', '        }\n', '        \n', '        // register player(s)\n', '        if(toRegisterPlayer && toRegisterReferral) {\n', '            uint256 length = (uint32)(playerAddrs.length);\n', '            player.id = (uint32)(length);\n', '            referredPlayer.id = (uint32)(length+1);\n', '            playerAddrs.length = length+2;\n', '            playerRefCounts.length = length+2;\n', '            playerAddrs[length] = msg.sender;\n', '            playerAddrs[length+1] = referral;\n', '            playerRefCounts[length+1] = 1;\n', '            \n', '        } else if(toRegisterPlayer) {\n', '            player.id = (uint32)(playerAddrs.length);\n', '            playerAddrs.push(msg.sender);\n', '            playerRefCounts.push(0);\n', '            \n', '        } else if(toRegisterReferral) {\n', '            referredPlayer.id = (uint32)(playerAddrs.length);\n', '            playerAddrs.push(referral);\n', '            playerRefCounts.push(1);\n', '        }\n', '        \n', '        // referral prize\n', '        refPrize += msg.value/40;    // 2.5% added to prize money\n', '    }\n', '    \n', '    function GetSaleInfo_Presale(uint8 saleID) external view returns (uint8, uint8, uint8, uint32, uint256, uint256) {\n', '        uint8 playerOwned = 0;\n', '        if(msg.sender != address(0))\n', '            playerOwned = players[msg.sender].bought[saleID];\n', '        \n', '        Sale storage sale = sales[saleID];\n', '        return (playerOwned, sale.bought, sale.maxBought, sale.cardTypeID, sale.price, sale.saleEndTime);\n', '    }\n', '    \n', '    function GetSaleInfo_Airdrop(uint8 saleID) external view returns (uint8, uint8, uint8, uint32, uint256, uint8) {\n', '        uint8 playerOwned = 0;\n', '        if(msg.sender != address(0))\n', '            playerOwned = players[msg.sender].bought[saleID];\n', '        \n', '        Sale storage sale = sales[saleID];\n', '        uint8 bought = sale.bought;\n', '        uint8 maxBought = sale.maxBought;\n', '        uint256 nextMintTime = sale.nextMintTime;\n', '        uint8 leftToMintResult = sale.leftToMint;\n', '    \n', '        // airdrop minting\n', '        if(now >= nextMintTime) {  // hit a cycle\n', '            nextMintTime += ((now-nextMintTime)/3600)*3600+3600;   // mint again next hour\n', '            if(bought != 0) {\n', '                uint8 leftToMint = leftToMintResult;\n', '                if(leftToMint < bought) { // not enough to recover, set maximum left to be bought\n', '                    maxBought = maxBought + leftToMint - bought;\n', '                    leftToMintResult = 0;\n', '                } else\n', '                    leftToMintResult -= bought;\n', '                bought = 0;\n', '            }\n', '        }\n', '        \n', '        return (playerOwned, bought, maxBought, sale.cardTypeID, nextMintTime, leftToMintResult);\n', '    }\n', '    \n', '    function GetReferralInfo() external view returns(uint256, uint32) {\n', '        uint32 refCount = 0;\n', '        uint32 id = players[msg.sender].id;\n', '        if(id != 0)\n', '            refCount = playerRefCounts[id];\n', '        return (refPrize, refCount);\n', '    }\n', '    \n', '    function GetPlayer_FromAddr(address playerAddr, uint8 saleID) external view returns(uint32, uint8, uint256, bool, uint32) {\n', '        Player storage player = players[playerAddr];\n', '        return (player.id, player.bought[saleID], player.weiSpent, player.hasSpent, playerRefCounts[player.id]);\n', '    }\n', '    \n', '    function GetPlayer_FromID(uint32 id, uint8 saleID) external view returns(address, uint8, uint256, bool, uint32) {\n', '        address playerAddr = playerAddrs[id];\n', '        Player storage player = players[playerAddr];\n', '        return (playerAddr, player.bought[saleID], player.weiSpent, player.hasSpent, playerRefCounts[id]);\n', '    }\n', '    \n', '    function getAddressesCount() external view returns(uint) {\n', '        return playerAddrs.length;\n', '    }\n', '    \n', '    function getAddresses() external view returns(address[]) {\n', '        return playerAddrs;\n', '    }\n', '    \n', '    function getAddress(uint256 id) external view returns(address) {\n', '        return playerAddrs[id];\n', '    }\n', '    \n', '    function getReferralCounts() external view returns(uint32[]) {\n', '        return playerRefCounts;\n', '    }\n', '    \n', '    function getReferralCount(uint256 playerID) external view returns(uint32) {\n', '        return playerRefCounts[playerID];\n', '    }\n', '    \n', '    function GetNow() external view returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '    // PAYMENT FUNCTIONS =======================\n', '    \n', '    function getEtherBalance() external view returns (uint256) {\n', '        return address(this).balance;\n', '    }\n', '    \n', '    function depositEtherBalance() external payable {\n', '    }\n', '    \n', '    function withdrawEtherBalance(uint256 amt) external onlyAdmin {\n', '        admin.transfer(amt);\n', '    }\n', '    \n', '    // RIGHTS FUNCTIONS =======================\n', '    \n', '    function setMaintainance(bool maintaining) external onlyAdmin {\n', '        inMaintainance = maintaining;\n', '    }\n', '    \n', '    function isInMaintainance() external view returns(bool) {\n', '        return inMaintainance;\n', '    }\n', '    \n', '    function getApprovers() external view returns(address[]) {\n', '        return approverArr;\n', '    }\n', '    \n', '    // change admin\n', '    // only admin can perform this function\n', '    function switchAdmin(address newAdmin) external onlyAdmin {\n', '        admin = newAdmin;\n', '    }\n', '\n', '    // add a new approver\n', '    // only admin can perform this function\n', '    function addApprover(address newApprover) external onlyAdmin {\n', '        require(!approvers[newApprover]);\n', '        approvers[newApprover] = true;\n', '        approverArr.push(newApprover);\n', '    }\n', '\n', '    // remove an approver\n', '    // only admin can perform this function\n', '    function removeApprover(address oldApprover) external onlyAdmin {\n', '        require(approvers[oldApprover]);\n', '        delete approvers[oldApprover];\n', '        \n', '        // swap last address with deleted address (for array)\n', '        uint256 length = approverArr.length;\n', '        address swapAddr = approverArr[length - 1];\n', '        for(uint8 i=0; i<length; i++) {\n', '            if(approverArr[i] == oldApprover) {\n', '                approverArr[i] = swapAddr;\n', '                break;\n', '            }\n', '        }\n', '        approverArr.length--;\n', '    }\n', '    \n', '    // MODIFIERS =======================\n', '    \n', '    modifier onlyAdmin() {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyApprover() {\n', '        require(approvers[msg.sender]);\n', '        _;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract EMPresale {\n', '    \n', '    bool inMaintainance;\n', '    bool isRefundable;\n', '    \n', '    // Data -----------------------------\n', '    \n', '    struct Player {\n', "        uint32 id;  // if 0, then player don't exist\n", '        mapping(uint8 => uint8) bought;\n', '        uint256 weiSpent;\n', '        bool hasSpent;\n', '    }\n', '    \n', '    struct Sale {\n', '        uint8 bought;\n', '        uint8 maxBought;\n', '        uint32 cardTypeID;\n', '        uint256 price;\n', '        uint256 saleEndTime;\n', '        \n', '        bool isAirdrop;     // enables minting (+maxBought per hour until leftToMint==0)\n', '                            // + each player can only buy once\n', '                            // + is free\n', '        uint256 nextMintTime;\n', '        uint8 leftToMint;\n', '    }\n', '    \n', '    address admin;\n', '    address[] approverArr; // for display purpose only\n', '    mapping(address => bool) approvers;\n', '    \n', '    address[] playerAddrs;      // 0 index not used\n', '    uint32[] playerRefCounts;   // 0 index not used\n', '    \n', '    mapping(address => Player) players;\n', '    mapping(uint8 => Sale) sales;   // use from 1 onwards\n', '    uint256 refPrize;\n', '    \n', '    // CONSTRUCTOR =======================\n', '    \n', '    function EMPresale() public {\n', '        admin = msg.sender;\n', '        approverArr.push(admin);\n', '        approvers[admin] = true;\n', '        \n', '        playerAddrs.push(address(0));\n', '        playerRefCounts.push(0);\n', '    }\n', '    \n', '    // ADMIN FUNCTIONS =======================\n', '    \n', '    function setSaleType_Presale(uint8 saleID, uint8 maxBought, uint32 cardTypeID, uint256 price, uint256 saleEndTime) external onlyAdmin {\n', '        Sale storage sale = sales[saleID];\n', '        \n', '        // assign sale type\n', '        sale.bought = 0;\n', '        sale.maxBought = maxBought;\n', '        sale.cardTypeID = cardTypeID;\n', '        sale.price = price;\n', '        sale.saleEndTime = saleEndTime;\n', '        \n', '        // airdrop type\n', '        sale.isAirdrop = false;\n', '    }\n', '    \n', '    function setSaleType_Airdrop(uint8 saleID, uint8 maxBought, uint32 cardTypeID, uint8 leftToMint, uint256 firstMintTime) external onlyAdmin {\n', '        Sale storage sale = sales[saleID];\n', '        \n', '        // assign sale type\n', '        sale.bought = 0;\n', '        sale.maxBought = maxBought;\n', '        sale.cardTypeID = cardTypeID;\n', '        sale.price = 0;\n', '        sale.saleEndTime = 2000000000;\n', '        \n', '        // airdrop type\n', '        require(leftToMint >= maxBought);\n', '        sale.isAirdrop = true;\n', '        sale.nextMintTime = firstMintTime;\n', '        sale.leftToMint = leftToMint - maxBought;\n', '    }\n', '    \n', '    function stopSaleType(uint8 saleID) external onlyAdmin {\n', '        delete sales[saleID].saleEndTime;\n', '    }\n', '    \n', '    function redeemCards(address playerAddr, uint8 saleID) external onlyApprover returns(uint8) {\n', '        Player storage player = players[playerAddr];\n', '        uint8 owned = player.bought[saleID];\n', '        player.bought[saleID] = 0;\n', '        return owned;\n', '    }\n', '    \n', '    function setRefundable(bool refundable) external onlyAdmin {\n', '        isRefundable = refundable;\n', '    }\n', '    \n', '    function refund() external {\n', '        require(isRefundable);\n', '        Player storage player = players[msg.sender];\n', '        uint256 spent = player.weiSpent;\n', '        player.weiSpent = 0;\n', '        msg.sender.transfer(spent);\n', '    }\n', '    \n', '    // PLAYER FUNCTIONS ========================\n', '    \n', '    function buySaleNonReferral(uint8 saleID) external payable {\n', '        buySale(saleID, address(0));\n', '    }\n', '    \n', '    function buySaleReferred(uint8 saleID, address referral) external payable {\n', '        buySale(saleID, referral);\n', '    }\n', '    \n', '    function buySale(uint8 saleID, address referral) private {\n', '        \n', '        require(!inMaintainance);\n', '        require(msg.sender != address(0));\n', '        \n', '        // check that sale is still on\n', '        Sale storage sale = sales[saleID];\n', '        require(sale.saleEndTime > now);\n', '        \n', '        bool isAirdrop = sale.isAirdrop;\n', '        if(isAirdrop) {\n', '            // airdrop minting\n', '            if(now >= sale.nextMintTime) {  // hit a cycle\n', '            \n', '                sale.nextMintTime += ((now-sale.nextMintTime)/3600)*3600+3600;   // mint again next hour\n', '                if(sale.bought != 0) {\n', '                    uint8 leftToMint = sale.leftToMint;\n', '                    if(leftToMint < sale.bought) { // not enough to recover, set maximum left to be bought\n', '                        sale.maxBought = sale.maxBought + leftToMint - sale.bought;\n', '                        sale.leftToMint = 0;\n', '                    } else\n', '                        sale.leftToMint -= sale.bought;\n', '                    sale.bought = 0;\n', '                }\n', '            }\n', '        } else {\n', '            // check ether is paid\n', '            require(msg.value >= sale.price);\n', '        }\n', '\n', '        // check not all is bought\n', '        require(sale.bought < sale.maxBought);\n', '        sale.bought++;\n', '        \n', '        bool toRegisterPlayer = false;\n', '        bool toRegisterReferral = false;\n', '        \n', '        // register player if unregistered\n', '        Player storage player = players[msg.sender];\n', '        if(player.id == 0)\n', '            toRegisterPlayer = true;\n', '            \n', '        // cannot buy more than once if airdrop\n', '        if(isAirdrop)\n', '            require(player.bought[saleID] == 0);\n', '        \n', '        // give ownership\n', '        player.bought[saleID]++;\n', '        if(!isAirdrop)  // is free otherwise\n', '            player.weiSpent += msg.value;\n', '        \n', "        // if hasn't referred, add referral\n", '        if(!player.hasSpent) {\n', '            player.hasSpent = true;\n', '            if(referral != address(0) && referral != msg.sender) {\n', '                Player storage referredPlayer = players[referral];\n', '                if(referredPlayer.id == 0) {    // add referred player if unregistered\n', '                    toRegisterReferral = true;\n', '                } else {                        // if already registered, just up ref count\n', '                    playerRefCounts[referredPlayer.id]++;\n', '                }\n', '            }\n', '        }\n', '        \n', '        // register player(s)\n', '        if(toRegisterPlayer && toRegisterReferral) {\n', '            uint256 length = (uint32)(playerAddrs.length);\n', '            player.id = (uint32)(length);\n', '            referredPlayer.id = (uint32)(length+1);\n', '            playerAddrs.length = length+2;\n', '            playerRefCounts.length = length+2;\n', '            playerAddrs[length] = msg.sender;\n', '            playerAddrs[length+1] = referral;\n', '            playerRefCounts[length+1] = 1;\n', '            \n', '        } else if(toRegisterPlayer) {\n', '            player.id = (uint32)(playerAddrs.length);\n', '            playerAddrs.push(msg.sender);\n', '            playerRefCounts.push(0);\n', '            \n', '        } else if(toRegisterReferral) {\n', '            referredPlayer.id = (uint32)(playerAddrs.length);\n', '            playerAddrs.push(referral);\n', '            playerRefCounts.push(1);\n', '        }\n', '        \n', '        // referral prize\n', '        refPrize += msg.value/40;    // 2.5% added to prize money\n', '    }\n', '    \n', '    function GetSaleInfo_Presale(uint8 saleID) external view returns (uint8, uint8, uint8, uint32, uint256, uint256) {\n', '        uint8 playerOwned = 0;\n', '        if(msg.sender != address(0))\n', '            playerOwned = players[msg.sender].bought[saleID];\n', '        \n', '        Sale storage sale = sales[saleID];\n', '        return (playerOwned, sale.bought, sale.maxBought, sale.cardTypeID, sale.price, sale.saleEndTime);\n', '    }\n', '    \n', '    function GetSaleInfo_Airdrop(uint8 saleID) external view returns (uint8, uint8, uint8, uint32, uint256, uint8) {\n', '        uint8 playerOwned = 0;\n', '        if(msg.sender != address(0))\n', '            playerOwned = players[msg.sender].bought[saleID];\n', '        \n', '        Sale storage sale = sales[saleID];\n', '        uint8 bought = sale.bought;\n', '        uint8 maxBought = sale.maxBought;\n', '        uint256 nextMintTime = sale.nextMintTime;\n', '        uint8 leftToMintResult = sale.leftToMint;\n', '    \n', '        // airdrop minting\n', '        if(now >= nextMintTime) {  // hit a cycle\n', '            nextMintTime += ((now-nextMintTime)/3600)*3600+3600;   // mint again next hour\n', '            if(bought != 0) {\n', '                uint8 leftToMint = leftToMintResult;\n', '                if(leftToMint < bought) { // not enough to recover, set maximum left to be bought\n', '                    maxBought = maxBought + leftToMint - bought;\n', '                    leftToMintResult = 0;\n', '                } else\n', '                    leftToMintResult -= bought;\n', '                bought = 0;\n', '            }\n', '        }\n', '        \n', '        return (playerOwned, bought, maxBought, sale.cardTypeID, nextMintTime, leftToMintResult);\n', '    }\n', '    \n', '    function GetReferralInfo() external view returns(uint256, uint32) {\n', '        uint32 refCount = 0;\n', '        uint32 id = players[msg.sender].id;\n', '        if(id != 0)\n', '            refCount = playerRefCounts[id];\n', '        return (refPrize, refCount);\n', '    }\n', '    \n', '    function GetPlayer_FromAddr(address playerAddr, uint8 saleID) external view returns(uint32, uint8, uint256, bool, uint32) {\n', '        Player storage player = players[playerAddr];\n', '        return (player.id, player.bought[saleID], player.weiSpent, player.hasSpent, playerRefCounts[player.id]);\n', '    }\n', '    \n', '    function GetPlayer_FromID(uint32 id, uint8 saleID) external view returns(address, uint8, uint256, bool, uint32) {\n', '        address playerAddr = playerAddrs[id];\n', '        Player storage player = players[playerAddr];\n', '        return (playerAddr, player.bought[saleID], player.weiSpent, player.hasSpent, playerRefCounts[id]);\n', '    }\n', '    \n', '    function getAddressesCount() external view returns(uint) {\n', '        return playerAddrs.length;\n', '    }\n', '    \n', '    function getAddresses() external view returns(address[]) {\n', '        return playerAddrs;\n', '    }\n', '    \n', '    function getAddress(uint256 id) external view returns(address) {\n', '        return playerAddrs[id];\n', '    }\n', '    \n', '    function getReferralCounts() external view returns(uint32[]) {\n', '        return playerRefCounts;\n', '    }\n', '    \n', '    function getReferralCount(uint256 playerID) external view returns(uint32) {\n', '        return playerRefCounts[playerID];\n', '    }\n', '    \n', '    function GetNow() external view returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '    // PAYMENT FUNCTIONS =======================\n', '    \n', '    function getEtherBalance() external view returns (uint256) {\n', '        return address(this).balance;\n', '    }\n', '    \n', '    function depositEtherBalance() external payable {\n', '    }\n', '    \n', '    function withdrawEtherBalance(uint256 amt) external onlyAdmin {\n', '        admin.transfer(amt);\n', '    }\n', '    \n', '    // RIGHTS FUNCTIONS =======================\n', '    \n', '    function setMaintainance(bool maintaining) external onlyAdmin {\n', '        inMaintainance = maintaining;\n', '    }\n', '    \n', '    function isInMaintainance() external view returns(bool) {\n', '        return inMaintainance;\n', '    }\n', '    \n', '    function getApprovers() external view returns(address[]) {\n', '        return approverArr;\n', '    }\n', '    \n', '    // change admin\n', '    // only admin can perform this function\n', '    function switchAdmin(address newAdmin) external onlyAdmin {\n', '        admin = newAdmin;\n', '    }\n', '\n', '    // add a new approver\n', '    // only admin can perform this function\n', '    function addApprover(address newApprover) external onlyAdmin {\n', '        require(!approvers[newApprover]);\n', '        approvers[newApprover] = true;\n', '        approverArr.push(newApprover);\n', '    }\n', '\n', '    // remove an approver\n', '    // only admin can perform this function\n', '    function removeApprover(address oldApprover) external onlyAdmin {\n', '        require(approvers[oldApprover]);\n', '        delete approvers[oldApprover];\n', '        \n', '        // swap last address with deleted address (for array)\n', '        uint256 length = approverArr.length;\n', '        address swapAddr = approverArr[length - 1];\n', '        for(uint8 i=0; i<length; i++) {\n', '            if(approverArr[i] == oldApprover) {\n', '                approverArr[i] = swapAddr;\n', '                break;\n', '            }\n', '        }\n', '        approverArr.length--;\n', '    }\n', '    \n', '    // MODIFIERS =======================\n', '    \n', '    modifier onlyAdmin() {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyApprover() {\n', '        require(approvers[msg.sender]);\n', '        _;\n', '    }\n', '}']

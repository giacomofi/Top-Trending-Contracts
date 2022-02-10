['/*\n', 'MillionEther smart contract - decentralized advertising platform.\n', '\n', 'This program is free software: you can redistribute it and/or modify\n', 'it under the terms of the GNU General Public License as published by\n', 'the Free Software Foundation, either version 3 of the License, or\n', '(at your option) any later version.\n', '\n', 'This program is distributed in the hope that it will be useful,\n', 'but WITHOUT ANY WARRANTY; without even the implied warranty of\n', 'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', 'GNU General Public License for more details.\n', '\n', 'You should have received a copy of the GNU General Public License\n', 'along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '*/\n', '\n', 'pragma solidity ^0.4.2;\n', '\n', 'contract MillionEther {\n', '\n', '    address private admin;\n', '\n', '    // Users\n', '    uint private numUsers = 0;\n', '    struct User {\n', '        address referal;\n', '        uint8 handshakes;\n', '        uint balance;\n', '        uint32 activationTime;\n', '        bool banned;\n', '        uint userID;\n', '        bool refunded;\n', '        uint investments;\n', '    }\n', '    mapping(address => User) private users;\n', '    mapping(uint => address) private userAddrs;\n', '\n', '    // Blocks. Blocks are 10x10 pixel areas. There are 10 000 blocks.\n', '    uint16 private blocksSold = 0;\n', '    uint private numNewStatus = 0;\n', '    struct Block {\n', '        address landlord;\n', '        uint imageID;\n', '        uint sellPrice;\n', '    }\n', '    Block[101][101] private blocks; \n', '\n', '    // Images\n', '    uint private numImages = 0;\n', '    struct Image {\n', '        uint8 fromX;\n', '        uint8 fromY;\n', '        uint8 toX;\n', '        uint8 toY;\n', '        string imageSourceUrl;\n', '        string adUrl;\n', '        string adText;\n', '    }\n', '    mapping(uint => Image) private images;\n', '\n', '    // Contract settings and security\n', '    uint public charityBalance = 0;\n', '    address public charityAddress;\n', '    uint8 private refund_percent = 0;\n', '    uint private totalWeiInvested = 0; //1 024 000 Ether max\n', '    bool private setting_stopped = false;\n', '    bool private setting_refundMode = false;\n', '    uint32 private setting_delay = 3600;\n', '    uint private setting_imagePlacementPriceInWei = 0;\n', '\n', '    // Events\n', '    event NewUser(uint ID, address newUser, address invitedBy, uint32 activationTime);\n', '    event NewAreaStatus (uint ID, uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint price);\n', '    event NewImage(uint ID, uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, string imageSourceUrl, string adUrl, string adText);\n', '\n', '\n', '// ** INITIALIZE ** //\n', '\n', '    function MillionEther () {\n', '        admin = msg.sender;\n', '        users[admin].referal = admin;\n', '        users[admin].handshakes = 0;\n', '        users[admin].activationTime = uint32(now);\n', '        users[admin].userID = 0;\n', '        userAddrs[0] = admin;\n', '        userAddrs[numUsers] = admin;\n', '    }\n', '\n', '\n', '// ** FUNCTION MODIFIERS (PERMISSIONS) ** //\n', '\n', '    modifier onlyAdmin {\n', '        if (msg.sender != admin) throw;\n', '        _;\n', '    }\n', '\n', '    modifier onlyWhenInvitedBy (address someUser) {\n', '        if (users[msg.sender].referal != address(0x0)) throw;   //user already exists\n', '        if (users[someUser].referal == address(0x0)) throw;     //referral does not exist\n', '        if (now < users[someUser].activationTime) throw;        //referral is not active yet\n', '        _;\n', '    }\n', '\n', '    modifier onlySignedIn {\n', '        if (users[msg.sender].referal == address(0x0)) throw;   //user does not exist\n', '        _;\n', '    }\n', '\n', '    modifier onlyForSale (uint8 _x, uint8 _y) {\n', '        if (blocks[_x][_y].landlord != address(0x0) && blocks[_x][_y].sellPrice == 0) throw;\n', '        _;\n', '    }\n', '\n', '    modifier onlyWithin100x100Area (uint8 _fromX, uint8 _fromY, uint8 _toX, uint8 _toY) {\n', '        if ((_fromX < 1) || (_fromY < 1)  || (_toX > 100) || (_toY > 100)) throw;\n', '        _;\n', '    }    \n', '\n', '    modifier onlyByLandlord (uint8 _x, uint8 _y) {\n', '        if (msg.sender != admin) {\n', '            if (blocks[_x][_y].landlord != msg.sender) throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier noBannedUsers {\n', '        if (users[msg.sender].banned == true) throw;\n', '        _;\n', '    }\n', '\n', '    modifier stopInEmergency { \n', '        if (msg.sender != admin) {\n', '            if (setting_stopped) throw; \n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier onlyInRefundMode { \n', '        if (!setting_refundMode) throw;\n', '        _;\n', '    }\n', '\n', '\n', '// ** USER SIGN IN ** //\n', '\n', '    function getActivationTime (uint _currentLevel, uint _setting_delay) private constant returns (uint32) {\n', '        return uint32(now + _setting_delay * (2**(_currentLevel-1)));\n', '    }\n', '\n', '    function signIn (address referal) \n', '        public \n', '        stopInEmergency ()\n', '        onlyWhenInvitedBy (referal) \n', '        returns (uint) \n', '    {\n', '        numUsers++;\n', "        // get user's referral handshakes and increase by one\n", '        uint8 currentLevel = users[referal].handshakes + 1;\n', '        users[msg.sender].referal = referal;\n', '        users[msg.sender].handshakes = currentLevel;\n', '        // 1,2,4,8,16,32,64 hours for activation depending on number of handshakes (if setting delay = 1 hour)\n', '        users[msg.sender].activationTime = getActivationTime (currentLevel, setting_delay); \n', '        users[msg.sender].refunded = false;\n', '        users[msg.sender].userID = numUsers;\n', '        userAddrs[numUsers] = msg.sender;\n', '        NewUser(numUsers, msg.sender, referal, users[msg.sender].activationTime);\n', '        return numUsers;\n', '    }\n', '\n', '\n', ' // ** BUY AND SELL BLOCKS ** //\n', '\n', '    function getBlockPrice (uint8 fromX, uint8 fromY, uint blocksSold) private constant returns (uint) {\n', '        if (blocks[fromX][fromY].landlord == address(0x0)) { \n', '                // when buying at initial sale price doubles every 1000 blocks sold\n', '                return 1 ether * (2 ** (blocksSold/1000));\n', '            } else {\n', '                // when the block is already bought and landlord have set a sell price\n', '                return blocks[fromX][fromY].sellPrice;\n', '            }\n', '        }\n', '\n', '    function buyBlock (uint8 x, uint8 y) \n', '        private  \n', '        onlyForSale (x, y) \n', '        returns (uint)\n', '    {\n', '        uint blockPrice;\n', '        blockPrice = getBlockPrice(x, y, blocksSold);\n', '        // Buy at initial sale\n', '        if (blocks[x][y].landlord == address(0x0)) {\n', '            blocksSold += 1;  \n', '            totalWeiInvested += blockPrice;\n', '        // Buy from current landlord and pay him or her the blockPrice\n', '        } else {\n', '            users[blocks[x][y].landlord].balance += blockPrice;  \n', '        }\n', '        blocks[x][y].landlord = msg.sender;\n', '        return blockPrice;\n', '    }\n', '\n', '    // buy an area of blocks at coordinates [fromX, fromY, toX, toY]\n', '    function buyBlocks (uint8 fromX, uint8 fromY, uint8 toX, uint8 toY) \n', '        public\n', '        payable\n', '        stopInEmergency ()\n', '        onlySignedIn () \n', '        onlyWithin100x100Area (fromX, fromY, toX, toY)\n', '        returns (uint) \n', '    {   \n', '        // Put funds to buyerBalance\n', '        if (users[msg.sender].balance + msg.value < users[msg.sender].balance) throw; //checking for overflow\n', '        uint previousWeiInvested = totalWeiInvested;\n', '        uint buyerBalance = users[msg.sender].balance + msg.value;\n', '\n', '        // perform buyBlock for coordinates [fromX, fromY, toX, toY] and withdraw funds\n', '        uint purchasePrice;\n', '        for (uint8 ix=fromX; ix<=toX; ix++) {\n', '            for (uint8 iy=fromY; iy<=toY; iy++) {\n', '                purchasePrice = buyBlock (ix,iy);\n', '                if (buyerBalance < purchasePrice) throw;\n', '                buyerBalance -= purchasePrice;\n', '            }\n', '        }\n', '        // update user balance\n', '        users[msg.sender].balance = buyerBalance;\n', "        // user's total investments are used for refunds calculations in emergency\n", '        users[msg.sender].investments += totalWeiInvested - previousWeiInvested;\n', '        // pay rewards to the referral chain starting from the current user referral\n', '        payOut (totalWeiInvested - previousWeiInvested, users[msg.sender].referal);\n', '        numNewStatus += 1;\n', '        // fire new area status event (0 sell price means the area is not for sale)\n', '        NewAreaStatus (numNewStatus, fromX, fromY, toX, toY, 0);\n', '        return purchasePrice;\n', '    }\n', '\n', '\n', '    //Mark block for sale (set a sell price)\n', '    function sellBlock (uint8 x, uint8 y, uint sellPrice) \n', '        private\n', '        onlyByLandlord (x, y) \n', '    {\n', '        blocks[x][y].sellPrice = sellPrice;\n', '    }\n', '\n', '    // sell an area of blocks at coordinates [fromX, fromY, toX, toY]\n', '    function sellBlocks (uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint priceForEachBlockInWei) \n', '        public \n', '        stopInEmergency ()\n', '        onlyWithin100x100Area (fromX, fromY, toX, toY) \n', '        returns (bool) \n', '    {\n', '        if (priceForEachBlockInWei == 0) throw;\n', '        for (uint8 ix=fromX; ix<=toX; ix++) {\n', '            for (uint8 iy=fromY; iy<=toY; iy++) {\n', '                sellBlock (ix, iy, priceForEachBlockInWei);\n', '            }\n', '        }\n', '        numNewStatus += 1;\n', '        // fire NewAreaStatus event\n', '        NewAreaStatus (numNewStatus, fromX, fromY, toX, toY, priceForEachBlockInWei);\n', '        return true;\n', '    }\n', '\n', '\n', '// ** ASSIGNING IMAGES ** //\n', '    \n', '    function chargeForImagePlacement () private {\n', '        if (users[msg.sender].balance + msg.value < users[msg.sender].balance) throw; //check for overflow`\n', '        uint buyerBalance = users[msg.sender].balance + msg.value;\n', '        if (buyerBalance < setting_imagePlacementPriceInWei) throw;\n', '        buyerBalance -= setting_imagePlacementPriceInWei;\n', '        users[admin].balance += setting_imagePlacementPriceInWei;\n', '        users[msg.sender].balance = buyerBalance;\n', '    }\n', '\n', '    // every block has its own image id assigned\n', '    function assignImageID (uint8 x, uint8 y, uint _imageID) \n', '        private\n', '        onlyByLandlord (x, y) \n', '    {\n', '        blocks[x][y].imageID = _imageID;\n', '    }\n', '\n', '    // place new ad to user owned area\n', '    function placeImage (uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, string imageSourceUrl, string adUrl, string adText) \n', '        public \n', '        payable\n', '        stopInEmergency ()\n', '        noBannedUsers ()\n', '        onlyWithin100x100Area (fromX, fromY, toX, toY)\n', '        returns (uint) \n', '    {\n', '        chargeForImagePlacement();\n', '        numImages++;\n', '        for (uint8 ix=fromX; ix<=toX; ix++) {\n', '            for (uint8 iy=fromY; iy<=toY; iy++) {\n', '                assignImageID (ix, iy, numImages);\n', '            }\n', '        }\n', '        images[numImages].fromX = fromX;\n', '        images[numImages].fromY = fromY;\n', '        images[numImages].toX = toX;\n', '        images[numImages].toY = toY;\n', '        images[numImages].imageSourceUrl = imageSourceUrl;\n', '        images[numImages].adUrl = adUrl;\n', '        images[numImages].adText = adText;\n', '        NewImage(numImages, fromX, fromY, toX, toY, imageSourceUrl, adUrl, adText);\n', '        return numImages;\n', '    }\n', '\n', '\n', '\n', '\n', '\n', '// ** PAYOUTS ** //\n', '\n', '    // reward the chain of referrals, admin and charity\n', '    function payOut (uint _amount, address referal) private {\n', '        address iUser = referal;\n', '        address nextUser;\n', '        uint totalPayed = 0;\n', '        for (uint8 i = 1; i < 7; i++) {                 // maximum 6 handshakes from the buyer \n', '            users[iUser].balance += _amount / (2**i);   // with every handshake far from the buyer reward halves:\n', '            totalPayed += _amount / (2**i);             // 50%, 25%, 12.5%, 6.25%, 3.125%, 1.5625%\n', '            if (iUser == admin) { break; }              // breaks at admin\n', '            nextUser = users[iUser].referal;\n', '            iUser = nextUser;\n', '        }\n', '        goesToCharity(_amount - totalPayed);            // the rest goes to charity\n', '    }\n', '\n', '    // charity is the same type of user as everyone else\n', '    function goesToCharity (uint amount) private {\n', '        // if no charityAddress is set yet funds go to charityBalance (see further)\n', '        if (charityAddress == address(0x0)) {\n', '            charityBalance += amount;\n', '        } else {\n', '            users[charityAddress].balance += amount;\n', '        }\n', '    }\n', '\n', '    // withdraw funds (no external calls for safety)\n', '    function withdrawAll () \n', '        public\n', '        stopInEmergency () \n', '    {\n', '        uint withdrawAmount = users[msg.sender].balance;\n', '        users[msg.sender].balance = 0;\n', '        if (!msg.sender.send(withdrawAmount)) {\n', '            users[msg.sender].balance = withdrawAmount;\n', '        }\n', '    }\n', '\n', '\n', ' // ** GET INFO (CONSTANT FUNCTIONS)** //\n', '\n', '    //USERS\n', '    function getUserInfo (address userAddress) public constant returns (\n', '        address referal,\n', '        uint8 handshakes,\n', '        uint balance,\n', '        uint32 activationTime,\n', '        bool banned,\n', '        uint userID,\n', '        bool refunded,\n', '        uint investments\n', '    ) {\n', '        referal = users[userAddress].referal; \n', '        handshakes = users[userAddress].handshakes; \n', '        balance = users[userAddress].balance; \n', '        activationTime = users[userAddress].activationTime; \n', '        banned = users[userAddress].banned; \n', '        userID = users[userAddress].userID;\n', '        refunded = users[userAddress].refunded; \n', '        investments = users[userAddress].investments;\n', '    }\n', '\n', '    function getUserAddressByID (uint userID) \n', '        public constant returns (address userAddress) \n', '    {\n', '        return userAddrs[userID];\n', '    }\n', '    \n', '    function getMyInfo() \n', '        public constant returns(uint balance, uint32 activationTime) \n', '    {   \n', '        return (users[msg.sender].balance, users[msg.sender].activationTime);\n', '    }\n', '\n', '    //BLOCKS\n', '    function getBlockInfo(uint8 x, uint8 y) \n', '        public constant returns (address landlord, uint imageID, uint sellPrice) \n', '    {\n', '        return (blocks[x][y].landlord, blocks[x][y].imageID, blocks[x][y].sellPrice);\n', '    }\n', '\n', '    function getAreaPrice (uint8 fromX, uint8 fromY, uint8 toX, uint8 toY)\n', '        public\n', '        constant\n', '        onlyWithin100x100Area (fromX, fromY, toX, toY)\n', '        returns (uint) \n', '    {\n', '        uint blockPrice;\n', '        uint totalPrice = 0;\n', '        uint16 iblocksSold = blocksSold;\n', '        for (uint8 ix=fromX; ix<=toX; ix++) {\n', '            for (uint8 iy=fromY; iy<=toY; iy++) {\n', '                blockPrice = getBlockPrice(ix,iy,iblocksSold);\n', '                if (blocks[ix][iy].landlord == address(0x0)) { \n', '                        iblocksSold += 1; \n', '                    }\n', '                if (blockPrice == 0) { \n', '                    return 0; // not for sale\n', '                    } \n', '                totalPrice += blockPrice;\n', '            }\n', '        }\n', '        return totalPrice;\n', '    }\n', '\n', '    //IMAGES\n', '    function getImageInfo(uint imageID) \n', '        public constant returns (uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, string imageSourceUrl, string adUrl, string adText)\n', '    {\n', '        Image i = images[imageID];\n', '        return (i.fromX, i.fromY, i.toX, i.toY, i.imageSourceUrl, i.adUrl, i.adText);\n', '    }\n', '\n', '    //CONTRACT STATE\n', '    function getStateInfo () public constant returns (\n', '        uint _numUsers, \n', '        uint16 _blocksSold, \n', '        uint _totalWeiInvested, \n', '        uint _numImages, \n', '        uint _setting_imagePlacementPriceInWei,\n', '        uint _numNewStatus,\n', '        uint32 _setting_delay\n', '    ){\n', '        return (numUsers, blocksSold, totalWeiInvested, numImages, setting_imagePlacementPriceInWei, numNewStatus, setting_delay);\n', '    }\n', '\n', '\n', '// ** ADMIN ** //\n', '\n', '    function adminContractSecurity (address violator, bool banViolator, bool pauseContract, bool refundInvestments)\n', '        public \n', '        onlyAdmin () \n', '    {\n', '        //freeze/unfreeze user\n', '        if (violator != address(0x0)) {\n', '            users[violator].banned = banViolator;\n', '        }\n', '        //pause/resume contract \n', '        setting_stopped = pauseContract;\n', '\n', '        //terminate contract, refund investments\n', '        if (refundInvestments) {\n', '            setting_refundMode = refundInvestments;\n', '            refund_percent = uint8((this.balance*100)/totalWeiInvested);\n', '        }\n', '    }\n', '\n', '    function adminContractSettings (uint32 newDelayInSeconds, address newCharityAddress, uint newImagePlacementPriceInWei)\n', '        public \n', '        onlyAdmin () \n', '    {   \n', '        // setting_delay affects user activation time.\n', '        if (newDelayInSeconds > 0) setting_delay = newDelayInSeconds;\n', "        // when the charityAddress is set charityBalance immediately transfered to it's balance \n", '        if (newCharityAddress != address(0x0)) {\n', '            if (users[newCharityAddress].referal == address(0x0)) throw;\n', '            charityAddress = newCharityAddress;\n', '            users[charityAddress].balance += charityBalance;\n', '            charityBalance = 0;\n', '        }\n', '        // at deploy is set to 0, but may be needed to support off-chain infrastructure\n', '        setting_imagePlacementPriceInWei = newImagePlacementPriceInWei;\n', '    }\n', '\n', '    // escape path - withdraw funds at emergency.\n', '    function emergencyRefund () \n', '        public\n', '        onlyInRefundMode () \n', '    {\n', '        if (!users[msg.sender].refunded) {\n', '            uint totalInvested = users[msg.sender].investments;\n', '            uint availableForRefund = (totalInvested*refund_percent)/100;\n', '            users[msg.sender].investments -= availableForRefund;\n', '            users[msg.sender].refunded = true;\n', '            if (!msg.sender.send(availableForRefund)) {\n', '                users[msg.sender].investments = totalInvested;\n', '                users[msg.sender].refunded = false;\n', '            }\n', '        }\n', '    }\n', '\n', '    function () {\n', '        throw;\n', '    }\n', '\n', '}']
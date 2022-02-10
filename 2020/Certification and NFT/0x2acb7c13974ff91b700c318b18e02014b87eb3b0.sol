['/** \n', '*SPDX-License-Identifier: BSD-3-Clause\n', '**/\n', '\n', '/**\n', '*\n', '* \n', '*  $$$$$$\\                                      $$\\                    $$\\   $$\\\n', '* $$  __$$\\                                     $$ |                   $$ |  $$ |\n', '* $$ /  \\__| $$$$$$\\   $$$$$$\\   $$$$$$\\   $$$$$$$ | $$$$$$\\   $$$$$$\\ \\$$\\ $$  |\n', '* \\$$$$$$\\  $$  __$$\\ $$  __$$\\ $$  __$$\\ $$  __$$ |$$  __$$\\ $$  __$$\\ \\$$$$  /\n', '*  \\____$$\\ $$ /  $$ |$$$$$$$$ |$$$$$$$$ |$$ /  $$ |$$$$$$$$ |$$ |  \\__|$$  $$<\n', '* $$\\   $$ |$$ |  $$ |$$   ____|$$   ____|$$ |  $$ |$$   ____|$$ |     $$  /\\$$\\\n', '* \\$$$$$$  |$$$$$$$  |\\$$$$$$$\\ \\$$$$$$$\\ \\$$$$$$$ |\\$$$$$$$\\ $$ |     $$ /  $$ |\n', '*  \\______/ $$  ____/  \\_______| \\_______| \\_______| \\_______|\\__|     \\__|  \\__|\n', '*           $$ |\n', '*           $$ |\n', '*           \\__|\n', '*\n', '**/\n', '\n', 'pragma solidity >=0.5.0 <0.6.10;\n', '\n', 'contract SpeederXContract {\n', '    struct User {\n', '        uint id;\n', '        address referrer;\n', '        uint partnersCount;\n', '        \n', '        mapping(uint8 => bool) activeF1Levels;\n', '        mapping(uint8 => bool) activeF2Levels;\n', '        \n', '        mapping(uint8 => F1) f1Matrix;\n', '        mapping(uint8 => F2) f2Matrix;\n', '    }\n', '    \n', '    struct F1 {\n', '        address currentReferrer;\n', '        address[] referrals;\n', '        bool blocked;\n', '        uint reinvestCount;\n', '    }\n', '    \n', '    struct F2 {\n', '        address currentReferrer;\n', '        address[] firstLevelReferrals;\n', '        address[] secondLevelReferrals;\n', '        bool blocked;\n', '        uint reinvestCount;\n', '\n', '        address closedPart;\n', '    }\n', '\n', '    uint8 public constant LAST_LEVEL = 13;\n', '    \n', '    mapping(address => User) public users;\n', '    mapping(uint => address) public idToAddress;\n', '    mapping(uint => address) public userIds;\n', '    mapping(address => uint) public reinvestGlobalCount;\n', '    mapping(address => uint) public balances; \n', '\n', '    uint public lastUserId = 2;\n', '    address public owner;\n', '    \n', '    uint internal reentryStatus;\n', '    uint internal constant entryEnabled = 1;\n', '    uint internal constant entryDisabled = 2;\n', '    \n', '    mapping(uint8 => uint) public levelPrice;\n', '    \n', '    event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);\n', '    event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);\n', '    event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);\n', '    event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);\n', '    event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);\n', '    event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);\n', '    event SentETH(address indexed receiver, uint8 matrix, uint8 level);\n', '    \n', '    modifier blockReEntry() {\n', '        require(reentryStatus != entryDisabled, "Security Block");\n', '        reentryStatus = entryDisabled;\n', '    \n', '        _;\n', '    \n', '        reentryStatus = entryEnabled;\n', '    }\n', '    \n', '    constructor(address ownerAddress) public {\n', '        levelPrice[1] = 0.02 ether;\n', '        for (uint8 i = 2; i <= LAST_LEVEL; i++) {\n', '            levelPrice[i] = levelPrice[i-1] * 2;\n', '        }\n', '        \n', '        reentryStatus = entryEnabled;\n', '        owner = ownerAddress;\n', '        \n', '        User memory user = User({\n', '            id: 1,\n', '            referrer: address(0),\n', '            partnersCount: uint(0)\n', '        });\n', '        \n', '        users[ownerAddress] = user;\n', '        idToAddress[1] = ownerAddress;\n', '        \n', '        for (uint8 i = 1; i <= LAST_LEVEL; i++) {\n', '            users[ownerAddress].activeF1Levels[i] = true;\n', '            users[ownerAddress].activeF2Levels[i] = true;\n', '        }\n', '        \n', '        userIds[1] = ownerAddress;\n', '    }\n', '    \n', '    fallback() external payable blockReEntry(){\n', '        return registration(msg.sender, bytesToAddress(msg.data));\n', '    }\n', '    receive() external payable blockReEntry() {\n', '        return registration(msg.sender, owner);\n', '    }\n', '\n', '    function registrationExt(address referrerAddress) external payable blockReEntry() {\n', '        registration(msg.sender, referrerAddress);\n', '    }\n', '    \n', '    function buyNewLevel(uint8 matrix, uint8 startLevel, uint8 endLevel) external payable blockReEntry() {\n', '        require(isUserExists(msg.sender), "user is not exists. Register first.");\n', '        require(matrix == 1 || matrix == 2, "invalid matrix");\n', '        require(startLevel >= 0 && startLevel < LAST_LEVEL, "invalid startLevel");\n', '        require(endLevel > 1 && endLevel <= LAST_LEVEL, "invalid endLevel");\n', '\n', '        if(startLevel == 0){\n', '            require(msg.value == levelPrice[endLevel], "invalid price");\n', '            buyNewEachLevel(matrix, endLevel);\n', '        } else {\n', '            uint amount;\n', '            for (uint8 i = startLevel; i <= endLevel; i++) {\n', '                amount += levelPrice[i] ;\n', '            }\n', '            require(msg.value == amount, "invalid many level price");\n', '\n', '            for (uint8 i = startLevel; i <= endLevel; i++) {\n', '                buyNewEachLevel(matrix, i);\n', '            }\n', '        }\n', '    } \n', '\n', '    function buyNewEachLevel(uint8 matrix, uint8 level) private {\n', '        if (matrix == 1) {\n', '            require(!users[msg.sender].activeF1Levels[level], "level already activated");\n', '\n', '            if (users[msg.sender].f1Matrix[level-1].blocked) {\n', '                users[msg.sender].f1Matrix[level-1].blocked = false;\n', '            }\n', '    \n', '            address freeF1Referrer = findFreeF1Referrer(msg.sender, level);\n', '            users[msg.sender].f1Matrix[level].currentReferrer = freeF1Referrer;\n', '            users[msg.sender].activeF1Levels[level] = true;\n', '            updateF1Referrer(msg.sender, freeF1Referrer, level);\n', '            \n', '            emit Upgrade(msg.sender, freeF1Referrer, 1, level);\n', '\n', '        } else {\n', '            require(!users[msg.sender].activeF2Levels[level], "level already activated"); \n', '\n', '            if (users[msg.sender].f2Matrix[level-1].blocked) {\n', '                users[msg.sender].f2Matrix[level-1].blocked = false;\n', '            }\n', '\n', '            address freeF2Referrer = findFreeF2Referrer(msg.sender, level);\n', '            \n', '            users[msg.sender].activeF2Levels[level] = true;\n', '            updateF2Referrer(msg.sender, freeF2Referrer, level);\n', '            \n', '            emit Upgrade(msg.sender, freeF2Referrer, 2, level);\n', '        }\n', '    }  \n', '    \n', '    function registration(address userAddress, address referrerAddress) private {\n', '        require(msg.value == 0.04 ether, "registration cost 0.04");\n', '        require(!isUserExists(userAddress), "user exists");\n', '        require(isUserExists(referrerAddress), "referrer not exists");\n', '        \n', '        uint32 size;\n', '        assembly {\n', '            size := extcodesize(userAddress)\n', '        }\n', '        require(size == 0, "cannot be a contract");\n', '        \n', '        User memory user = User({\n', '            id: lastUserId,\n', '            referrer: referrerAddress,\n', '            partnersCount: 0\n', '        });\n', '        \n', '        users[userAddress] = user;\n', '        idToAddress[lastUserId] = userAddress;\n', '        \n', '        users[userAddress].referrer = referrerAddress;\n', '        \n', '        users[userAddress].activeF1Levels[1] = true; \n', '        users[userAddress].activeF2Levels[1] = true;\n', '        \n', '        \n', '        userIds[lastUserId] = userAddress;\n', '        lastUserId++;\n', '        \n', '        users[referrerAddress].partnersCount++;\n', '\n', '        address freeF1Referrer = findFreeF1Referrer(userAddress, 1);\n', '        users[userAddress].f1Matrix[1].currentReferrer = freeF1Referrer;\n', '        updateF1Referrer(userAddress, freeF1Referrer, 1);\n', '\n', '        updateF2Referrer(userAddress, findFreeF2Referrer(userAddress, 1), 1);\n', '        \n', '        emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);\n', '    }\n', '    \n', '    function updateF1Referrer(address userAddress, address referrerAddress, uint8 level) private {\n', '        users[referrerAddress].f1Matrix[level].referrals.push(userAddress);\n', '\n', '        if (users[referrerAddress].f1Matrix[level].referrals.length < 3) {\n', '            emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].f1Matrix[level].referrals.length));\n', '            return sendETHDividends(referrerAddress, userAddress, 1, level);\n', '        }\n', '        \n', '        emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);\n', '        //close matrix\n', '        users[referrerAddress].f1Matrix[level].referrals = new address[](0);\n', '        if (!users[referrerAddress].activeF1Levels[level+1] && level != LAST_LEVEL) {\n', '            users[referrerAddress].f1Matrix[level].blocked = true;\n', '        }\n', '\n', '        //create new one by recursion\n', '        if (referrerAddress != owner) {\n', '            //check referrer active level\n', '            address freeReferrerAddress = findFreeF1Referrer(referrerAddress, level);\n', '            if (users[referrerAddress].f1Matrix[level].currentReferrer != freeReferrerAddress) {\n', '                users[referrerAddress].f1Matrix[level].currentReferrer = freeReferrerAddress;\n', '            }\n', '            \n', '            users[referrerAddress].f1Matrix[level].reinvestCount++;\n', '            reinvestGlobalCount[referrerAddress] = users[referrerAddress].f1Matrix[level].reinvestCount;\n', '            emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);\n', '            updateF1Referrer(referrerAddress, freeReferrerAddress, level);\n', '        } else {\n', '            sendETHDividends(owner, userAddress, 1, level);\n', '            users[owner].f1Matrix[level].reinvestCount++;\n', '            emit Reinvest(owner, address(0), userAddress, 1, level);\n', '        }\n', '    }\n', '\n', '    function updateF2Referrer(address userAddress, address referrerAddress, uint8 level) private {\n', '        require(users[referrerAddress].activeF2Levels[level], "500. Referrer level is inactive");\n', '        \n', '        if (users[referrerAddress].f2Matrix[level].firstLevelReferrals.length < 2) {\n', '            \n', '            users[referrerAddress].f2Matrix[level].firstLevelReferrals.push(userAddress);\n', '            emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].f2Matrix[level].firstLevelReferrals.length));\n', '            \n', '            //set current level\n', '            users[userAddress].f2Matrix[level].currentReferrer = referrerAddress;\n', '\n', '            if (referrerAddress == owner) {\n', '                return sendETHDividends(referrerAddress, userAddress, 2, level);\n', '            }\n', '            \n', '            address ref = users[referrerAddress].f2Matrix[level].currentReferrer;            \n', '            users[ref].f2Matrix[level].secondLevelReferrals.push(userAddress); \n', '            \n', '            uint len = users[ref].f2Matrix[level].firstLevelReferrals.length;\n', '            \n', '            if ((len == 2) && \n', '                (users[ref].f2Matrix[level].firstLevelReferrals[0] == referrerAddress) &&\n', '                (users[ref].f2Matrix[level].firstLevelReferrals[1] == referrerAddress)) {\n', '                if (users[referrerAddress].f2Matrix[level].firstLevelReferrals.length == 1) {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 5);\n', '                } else {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 6);\n', '                }\n', '            }  else if ((len == 1 || len == 2) &&\n', '                    users[ref].f2Matrix[level].firstLevelReferrals[0] == referrerAddress) {\n', '                if (users[referrerAddress].f2Matrix[level].firstLevelReferrals.length == 1) {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 3);\n', '                } else {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 4);\n', '                }\n', '            } else if (len == 2 && users[ref].f2Matrix[level].firstLevelReferrals[1] == referrerAddress) {\n', '                if (users[referrerAddress].f2Matrix[level].firstLevelReferrals.length == 1) {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 5);\n', '                } else {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 6);\n', '                }\n', '            }\n', '\n', '            return updateF2ReferrerSecondLevel(userAddress, ref, level);\n', '        }\n', '        \n', '        users[referrerAddress].f2Matrix[level].secondLevelReferrals.push(userAddress);\n', '\n', '        if (users[referrerAddress].f2Matrix[level].closedPart != address(0)) {\n', '            if ((users[referrerAddress].f2Matrix[level].firstLevelReferrals[0] == \n', '                users[referrerAddress].f2Matrix[level].firstLevelReferrals[1]) &&\n', '                (users[referrerAddress].f2Matrix[level].firstLevelReferrals[0] ==\n', '                users[referrerAddress].f2Matrix[level].closedPart)) {\n', '\n', '                updateF2(userAddress, referrerAddress, level, true);\n', '                return updateF2ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '            } else if (users[referrerAddress].f2Matrix[level].firstLevelReferrals[0] == \n', '                users[referrerAddress].f2Matrix[level].closedPart) {\n', '                updateF2(userAddress, referrerAddress, level, true);\n', '                return updateF2ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '            } else {\n', '                updateF2(userAddress, referrerAddress, level, false);\n', '                return updateF2ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '            }\n', '        }\n', '\n', '        if (users[referrerAddress].f2Matrix[level].firstLevelReferrals[1] == userAddress) {\n', '            updateF2(userAddress, referrerAddress, level, false);\n', '            return updateF2ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '        } else if (users[referrerAddress].f2Matrix[level].firstLevelReferrals[0] == userAddress) {\n', '            updateF2(userAddress, referrerAddress, level, true);\n', '            return updateF2ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '        }\n', '        \n', '        if (users[users[referrerAddress].f2Matrix[level].firstLevelReferrals[0]].f2Matrix[level].firstLevelReferrals.length <= \n', '            users[users[referrerAddress].f2Matrix[level].firstLevelReferrals[1]].f2Matrix[level].firstLevelReferrals.length) {\n', '            updateF2(userAddress, referrerAddress, level, false);\n', '        } else {\n', '            updateF2(userAddress, referrerAddress, level, true);\n', '        }\n', '        \n', '        updateF2ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '    }\n', '\n', '    function updateF2(address userAddress, address referrerAddress, uint8 level, bool x2) private {\n', '        if (!x2) {\n', '            users[users[referrerAddress].f2Matrix[level].firstLevelReferrals[0]].f2Matrix[level].firstLevelReferrals.push(userAddress);\n', '            emit NewUserPlace(userAddress, users[referrerAddress].f2Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].f2Matrix[level].firstLevelReferrals[0]].f2Matrix[level].firstLevelReferrals.length));\n', '            emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].f2Matrix[level].firstLevelReferrals[0]].f2Matrix[level].firstLevelReferrals.length));\n', '            //set current level\n', '            users[userAddress].f2Matrix[level].currentReferrer = users[referrerAddress].f2Matrix[level].firstLevelReferrals[0];\n', '        } else {\n', '            users[users[referrerAddress].f2Matrix[level].firstLevelReferrals[1]].f2Matrix[level].firstLevelReferrals.push(userAddress);\n', '            emit NewUserPlace(userAddress, users[referrerAddress].f2Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].f2Matrix[level].firstLevelReferrals[1]].f2Matrix[level].firstLevelReferrals.length));\n', '            emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].f2Matrix[level].firstLevelReferrals[1]].f2Matrix[level].firstLevelReferrals.length));\n', '            //set current level\n', '            users[userAddress].f2Matrix[level].currentReferrer = users[referrerAddress].f2Matrix[level].firstLevelReferrals[1];\n', '        }\n', '    }\n', '    \n', '    function updateF2ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {\n', '        if (users[referrerAddress].f2Matrix[level].secondLevelReferrals.length < 4) {\n', '            return sendETHDividends(referrerAddress, userAddress, 2, level);\n', '        }\n', '        \n', '        address[] memory f2 = users[users[referrerAddress].f2Matrix[level].currentReferrer].f2Matrix[level].firstLevelReferrals;\n', '        \n', '        if (f2.length == 2) {\n', '            if (f2[0] == referrerAddress ||\n', '                f2[1] == referrerAddress) {\n', '                users[users[referrerAddress].f2Matrix[level].currentReferrer].f2Matrix[level].closedPart = referrerAddress;\n', '            } else if (f2.length == 1) {\n', '                if (f2[0] == referrerAddress) {\n', '                    users[users[referrerAddress].f2Matrix[level].currentReferrer].f2Matrix[level].closedPart = referrerAddress;\n', '                }\n', '            }\n', '        }\n', '        \n', '        users[referrerAddress].f2Matrix[level].firstLevelReferrals = new address[](0);\n', '        users[referrerAddress].f2Matrix[level].secondLevelReferrals = new address[](0);\n', '        users[referrerAddress].f2Matrix[level].closedPart = address(0);\n', '\n', '        if (!users[referrerAddress].activeF2Levels[level+1] && level != LAST_LEVEL) {\n', '            users[referrerAddress].f2Matrix[level].blocked = true;\n', '        }\n', '\n', '        users[referrerAddress].f2Matrix[level].reinvestCount++;\n', '        \n', '        if (referrerAddress != owner) {\n', '            address freeReferrerAddress = findFreeF2Referrer(referrerAddress, level);\n', '\n', '            emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);\n', '            updateF2Referrer(referrerAddress, freeReferrerAddress, level);\n', '        } else {\n', '            emit Reinvest(owner, address(0), userAddress, 2, level);\n', '            sendETHDividends(owner, userAddress, 2, level);\n', '        }\n', '    }\n', '    \n', '    function findFreeF1Referrer(address userAddress, uint8 level) public view returns(address) {\n', '        while (true) {\n', '            if (users[users[userAddress].referrer].activeF1Levels[level]) {\n', '                return users[userAddress].referrer;\n', '            }\n', '            \n', '            userAddress = users[userAddress].referrer;\n', '        }\n', '    }\n', '    \n', '    function findFreeF2Referrer(address userAddress, uint8 level) public view returns(address) {\n', '        while (true) {\n', '            if (users[users[userAddress].referrer].activeF2Levels[level]) {\n', '                return users[userAddress].referrer;\n', '            }\n', '            \n', '            userAddress = users[userAddress].referrer;\n', '        }\n', '    }\n', '        \n', '    function usersActiveF1Levels(address userAddress, uint8 level) public view returns(bool) {\n', '        return users[userAddress].activeF1Levels[level];\n', '    }\n', '\n', '    function usersActiveF2Levels(address userAddress, uint8 level) public view returns(bool) {\n', '        return users[userAddress].activeF2Levels[level];\n', '    }\n', '\n', '    function usersF1Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {\n', '        return (users[userAddress].f1Matrix[level].currentReferrer,\n', '                users[userAddress].f1Matrix[level].referrals,\n', '                users[userAddress].f1Matrix[level].blocked);\n', '    }\n', '\n', '    function usersF2Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {\n', '        return (users[userAddress].f2Matrix[level].currentReferrer,\n', '                users[userAddress].f2Matrix[level].firstLevelReferrals,\n', '                users[userAddress].f2Matrix[level].secondLevelReferrals,\n', '                users[userAddress].f2Matrix[level].blocked,\n', '                users[userAddress].f2Matrix[level].closedPart);\n', '    }\n', '    \n', '    function isUserExists(address user) public view returns (bool) {\n', '        return (users[user].id != 0);\n', '    }\n', '\n', '    function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {\n', '        address receiver = userAddress;\n', '        bool isExtraDividends;\n', '        if (matrix == 1) {\n', '            while (true) {\n', '                if (users[receiver].f1Matrix[level].blocked) {\n', '                    emit MissedEthReceive(receiver, _from, 1, level);\n', '                    isExtraDividends = true;\n', '                    receiver = users[receiver].f1Matrix[level].currentReferrer;\n', '                } else {\n', '                    return (receiver, isExtraDividends);\n', '                }\n', '            }\n', '        } else {\n', '            while (true) {\n', '                if (users[receiver].f2Matrix[level].blocked) {\n', '                    emit MissedEthReceive(receiver, _from, 2, level);\n', '                    isExtraDividends = true;\n', '                    receiver = users[receiver].f2Matrix[level].currentReferrer;\n', '                } else {\n', '                    return (receiver, isExtraDividends);\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {\n', '        (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);\n', '        \n', '        (bool success, ) = address(uint160(receiver)).call{ value: levelPrice[level], gas: 40000 }("");\n', '\n', '        if (success == false) { \n', '          (success, ) = address(uint160(receiver)).call{ value: levelPrice[level], gas: 40000 }("");\n', "          require(success, 'Transfer Failed');\n", '        }\n', '        \n', '        emit SentETH(receiver, matrix, level);\n', '        \n', '        if (isExtraDividends) {\n', '            emit SentExtraEthDividends(_from, receiver, matrix, level);\n', '        }\n', '    }\n', '    \n', '    function bytesToAddress(bytes memory bys) private pure returns (address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '}']
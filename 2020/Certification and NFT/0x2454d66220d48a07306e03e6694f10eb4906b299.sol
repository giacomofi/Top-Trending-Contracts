['pragma solidity >=0.4.23 <0.6.0;\n', '\n', 'contract DoradoWorld{\n', '    struct User {\n', '        uint id;\n', '        address referrer;\n', '        uint partnersCount;\n', '        \n', '        mapping(uint8 => bool) activeD3Levels;\n', '        mapping(uint8 => bool) activeD4Levels;\n', '        \n', '        mapping(uint8 => D3) D3Matrix;\n', '        mapping(uint8 => D4) D4Matrix;\n', '        mapping(uint8 => D5) D5Matrix;\n', '    }\n', '    struct D5 {\n', '         uint[] D5No;\n', '    }\n', '    struct D3 {\n', '        address currentReferrer;\n', '        address[] referrals;\n', '        bool blocked;\n', '        uint reinvestCount;\n', '    }\n', '    struct D4 {\n', '        address currentReferrer;\n', '        address[] firstLevelReferrals;\n', '        address[] secondLevelReferrals;\n', '        bool blocked;\n', '        uint reinvestCount;\n', '\n', '        address closedPart;\n', '    }\n', '    \n', '    uint8[15] private D3ReEntry = [\n', '       0,1,0,2,3,3,3,1,3,3,3,3,3,3,3\n', '    ];\n', '    \n', '    uint8[15] private D4ReEntry = [\n', '       0,0,0,1,3,3,3,1,1,3,3,3,3,3,3\n', '    ];\n', '    \n', '    uint[3] private D5LevelPrice = [\n', '        0.05 ether,\n', '        0.80 ether,\n', '        3.00 ether\n', '    ];\n', '    \n', '    uint8 public constant LAST_LEVEL = 15;\n', '    mapping(address => User) public users;\n', '    mapping(uint => address) public idToAddress;\n', '    mapping(uint => address) public userIds;\n', '    mapping(address => uint) public balances; \n', '    mapping(uint8 => uint[]) private L5Matrix;\n', '    uint public lastUserId = 2;\n', '    address public owner;\n', '    \n', '    mapping(uint8 => uint) public levelPrice;\n', '\n', '    \n', '    event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);\n', '    event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);\n', '    event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);\n', '    event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint256 place);\n', '    event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);\n', '    event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);\n', '    \n', '    event NewD5Matrix(uint newid, uint benid, bool reentry);\n', '    event Reentry(uint newid, uint benid);\n', '    event D5NewId(uint newid, uint topid, uint botid,uint8 position,uint numcount);\n', '    event payout(uint indexed benid,address indexed receiver,uint indexed dividend,uint8 matrix);\n', '    event payoutblock(address receiver,uint reentry);\n', '    event Testor(string str,uint8 level,uint place);\n', '   \n', '    \n', '    constructor(address ownerAddress) public {\n', '        levelPrice[1] = 0.025 ether;\n', '        for (uint8 i = 2; i <= 10; i++) {\n', '            levelPrice[i] = levelPrice[i-1] * 2;\n', '        }\n', '        \n', '        levelPrice[11] = 25 ether;\n', '        levelPrice[12] = 50 ether;\n', '        levelPrice[13] = 60 ether;\n', '        levelPrice[14] = 70 ether;\n', '        levelPrice[15] = 100 ether;\n', '        \n', '        owner = ownerAddress;\n', '        User memory user = User({\n', '            id: 1,\n', '            referrer: address(0),\n', '            partnersCount: uint(0)\n', '        });\n', '        \n', '        users[ownerAddress] = user;\n', '        idToAddress[1] = ownerAddress;\n', '        \n', '        for (uint8 i = 1; i <= LAST_LEVEL; i++) {\n', '            users[ownerAddress].activeD3Levels[i] = true;\n', '            users[ownerAddress].activeD4Levels[i] = true;\n', '        }\n', '        \n', '        userIds[1] = ownerAddress;\n', '        for (uint8 i = 1; i <= 3; i++) {\n', '            users[ownerAddress].D5Matrix[i].D5No.push(1);\n', '            L5Matrix[i].push(1);\n', '            \n', '        }\n', '       \n', '        \n', '            /*L5Matrix[1][1] = 1;\n', '        \n', '        users[ownerAddress].D5Matrix[2].D5No.push(1);\n', '            L5Matrix[2][1] = 1;\n', '            \n', '        users[ownerAddress].D5Matrix[3].D5No.push(1);\n', '            \n', '    \n', '        */\n', '\n', '    }\n', '    \n', '    function() external payable {\n', '        if(msg.data.length == 0) {\n', '            return registration(msg.sender, owner);\n', '        }\n', '        \n', '        registration(msg.sender, bytesToAddress(msg.data));\n', '    }\n', '\n', '    function registrationExt(address referrerAddress) external payable {\n', '       registration(msg.sender, referrerAddress);\n', '    }\n', '    \n', '    function buyNewLevel(uint8 matrix, uint8 level) external payable {\n', '        require(isUserExists(msg.sender), "user is not exists. Register first.");\n', '        require(matrix == 1 || matrix == 2, "invalid matrix");\n', '        require(msg.value == levelPrice[level], "invalid price");\n', '        require(level > 1 && level <= LAST_LEVEL, "invalid level");\n', '\n', '        if (matrix == 1) {\n', '            require(!users[msg.sender].activeD3Levels[level], "level already activated");\n', '\n', '            if (users[msg.sender].D3Matrix[level-1].blocked) {\n', '                users[msg.sender].D3Matrix[level-1].blocked = false;\n', '            }\n', '    \n', '            address freeD3Referrer = findFreeD3Referrer(msg.sender, level);\n', '            users[msg.sender].D3Matrix[level].currentReferrer = freeD3Referrer;\n', '            users[msg.sender].activeD3Levels[level] = true;\n', '            updateD3Referrer(msg.sender, freeD3Referrer, level);\n', '            \n', '            emit Upgrade(msg.sender, freeD3Referrer, 1, level);\n', '\n', '        } else {\n', '            require(!users[msg.sender].activeD4Levels[level], "level already activated"); \n', '\n', '            if (users[msg.sender].D4Matrix[level-1].blocked) {\n', '                users[msg.sender].D4Matrix[level-1].blocked = false;\n', '            }\n', '\n', '            address freeD4Referrer = findFreeD4Referrer(msg.sender, level);\n', '            \n', '            users[msg.sender].activeD4Levels[level] = true;\n', '            updateD4Referrer(msg.sender, freeD4Referrer, level);\n', '            \n', '            emit Upgrade(msg.sender, freeD4Referrer, 2, level);\n', '        }\n', '    }    \n', '    \n', '    function registration(address userAddress, address referrerAddress) private {\n', '        require(msg.value == 0.05 ether, "registration cost 0.05");\n', '        require(!isUserExists(userAddress), "user exists");\n', '        require(isUserExists(referrerAddress), "referrer not exists");\n', '        \n', '        uint32 size;\n', '        assembly {\n', '            size := extcodesize(userAddress)\n', '        }\n', '        require(size == 0, "cannot be a contract");\n', '        \n', '        User memory user = User({\n', '            id: lastUserId,\n', '            referrer: referrerAddress,\n', '            partnersCount: 0\n', '        });\n', '        \n', '        users[userAddress] = user;\n', '        idToAddress[lastUserId] = userAddress;\n', '        \n', '        users[userAddress].referrer = referrerAddress;\n', '        \n', '        users[userAddress].activeD3Levels[1] = true; \n', '        users[userAddress].activeD4Levels[1] = true;\n', '        \n', '        \n', '        userIds[lastUserId] = userAddress;\n', '        lastUserId++;\n', '        \n', '        users[referrerAddress].partnersCount++;\n', '\n', '        address freeD3Referrer = findFreeD3Referrer(userAddress, 1);\n', '        users[userAddress].D3Matrix[1].currentReferrer = freeD3Referrer;\n', '        updateD3Referrer(userAddress, freeD3Referrer, 1);\n', '\n', '        updateD4Referrer(userAddress, findFreeD4Referrer(userAddress, 1), 1);\n', '        \n', '        emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);\n', '    }\n', '    \n', '    function d5martixstructure(uint newid) private pure returns(uint,bool){\n', '\t\n', '\t\tuint8 matrix = 5;\n', '\t\tuint benid = 0;\n', '\t\tbool flag = true;\n', '\t\tuint numcount =1;\n', '\t\tuint topid = 0;\n', '\t\tuint botid = 0;\n', '\t\tuint8 position = 0;\n', '\t\tuint8 d5level = 1;\n', '\t    bool reentry= false;\n', '\n', '\t\twhile(flag){\n', '\n', '\t\ttopid = setUpperLine5(newid,d5level);\n', '\t\tposition = 0;\n', '        \n', '\t\t\tif(topid > 0){\n', '\t\t\t    botid = setDownlineLimit5(topid,d5level);\n', '\t\t\t    \n', '\t\t\t\tif(d5level == 6){\n', '\t\t\t\t\tbenid = topid;\n', '\t\t\t\t\tflag = false;\n', '\t\t\t\t}else{\n', '\t\t\t\t    //emit D5NewId(newid,topid,botid,position,numcount);\n', '\t\t\t\t\tif(newid == botid){\n', '\t\t\t\t\t\tposition = 1;\n', '\t\t\t\t\t}else{\n', '\t\t\t\t\t   \n', '\t\t\t    \n', '\t\t\t\t\t\tfor (uint8 i = 1; i <= matrix; i++) {\n', '\t\t\t\t\n', '\t\t\t\t\t\t\tif(newid < (botid + (numcount * i))){\n', '\t\t\t\t\t\t\t\tposition = i;\n', '\t\t\t\t\t\t\t\ti = matrix;\n', '\t\t\t\t\t\t\t}\n', '\t\t\t\t\t\t}\n', '\t\t\t\t\t\t\n', '\t\t\t\t\t}\n', '\t\t            \n', '\t\t\t\t\tif((position == 2) || (position == 4)){\n', '\t\t\t\t\t\tbenid = topid;\n', '\t\t\t\t\t\tflag = false;\n', '\t\t\t\t\t}\n', '\t\t\t\t}\n', '\t\t\t\t\n', '\n', '\t\t\t\td5level += 1;\n', '\t\t\tnumcount = numcount * 5;\n', '\t\t\t}else{\n', '\t\t\t\tbenid =0;\n', '\t\t\t\tflag = false;\n', '\t\t\t}\n', '\t\t\t\n', '\t\t\t\n', '\t\t}\n', '\t\td5level -= 1;\n', '\t\tif(benid > 0){\n', '\t\t    //emit D5NewId(newid, topid, botid,d5level,numcount);\n', '\t\t    if((d5level == 3) || (d5level == 4) || (d5level == 5)){\n', '\t\t        numcount = numcount / 5;\n', '\t\t        if(((botid + numcount) + 15) >= newid){\n', '\t\t\t\t    reentry = true;\n', '\t\t\t\t}\n', '\t\t\t\t    \n', '\t\t    }\n', '\t\t\t\t\n', '\t\t    if((d5level == 6) && ((botid + 15) >= newid)){\n', '\t\t\t\treentry = true;\n', '\t    \t}\n', '\t\t}\n', '\t\tif(benid == 0){\n', '\t\t    benid =1;\n', '\t\t}\n', '        return (benid,reentry);\n', '\n', '}\n', '     \n', '    function setUpperLine5(uint TrefId,uint8 level) internal pure returns(uint){\n', '    \tfor (uint8 i = 1; i <= level; i++) {\n', '    \t\tif(TrefId == 1){\n', '        \t\tTrefId = 0;\n', '    \t\t}else if(TrefId == 0){\n', '        \t\tTrefId = 0;\n', '    \t\t}else if((1 < TrefId) && (TrefId < 7)){\n', '        \t\tTrefId = 1;\n', '\t\t\t}else{\n', '\t\t\t\tTrefId -= 1;\n', '\t\t\t\tif((TrefId % 5) > 0){\n', '\t\t\t\tTrefId = uint(TrefId / 5);\n', '\t\t\t\tTrefId += 1;\n', '\t\t\t\t}else{\n', '\t\t\t\tTrefId = uint(TrefId / 5);  \n', '\t\t\t\t}\n', '\t\t\t\t\n', '\t\t\t}\t\n', '    \t}\n', '    \treturn TrefId;\n', '    }\n', '    \n', '    function setDownlineLimit5(uint TrefId,uint8 level) internal pure returns(uint){\n', '    \tuint8 ded = 1;\n', '\t\tuint8 add = 2;\n', '    \tfor (uint8 i = 1; i < level; i++) {\n', '    \t\tded *= 5;\n', '\t\t\tadd += ded;\n', '\t\t}\n', '\t\tded *= 5;\n', '\t\tTrefId = ((ded * TrefId) - ded) + add;\n', '    \treturn TrefId;\n', '    }\n', '    \n', '    function updateD5Referrer(address userAddress, uint8 level) private {\n', '        uint newid = uint(L5Matrix[level].length);\n', '        newid = newid + 1;\n', '        users[userAddress].D5Matrix[level].D5No.push(newid);\n', '        L5Matrix[level].push(users[userAddress].id);\n', '        (uint benid, bool reentry) = d5martixstructure(newid);\n', '        emit NewD5Matrix(newid,benid,reentry);\n', '        if(reentry){\n', '            emit Reentry(newid,benid);\n', '            updateD5Referrer(idToAddress[L5Matrix[level][benid]],level);\n', '         }else{\n', '            emit payout(benid,idToAddress[L5Matrix[level][benid]],D5LevelPrice[level-1],level + 2);\n', '            return sendETHD5(idToAddress[L5Matrix[level][benid]],D5LevelPrice[level-1]);\n', '           // emit payout(benid,idToAddress[L5Matrix[level][benid]],D5LevelPrice[level]);\n', '        }\n', '        \n', '    }\n', '    \n', '    function updateD3Referrer(address userAddress, address referrerAddress,uint8 level) private {\n', '       // emit Testor(users[referrerAddress].D3Matrix[level].referrals.length);\n', '        users[referrerAddress].D3Matrix[level].referrals.push(userAddress);\n', '       //  emit Testor(users[referrerAddress].D3Matrix[level].referrals.length);\n', '       // uint256 referrals = users[referrerAddress].D3Matrix[level].referrals.length;\n', '        uint reentry = users[referrerAddress].D3Matrix[level].reinvestCount;\n', '       //uint reentry =0;\n', '      \n', '       \n', '        if (users[referrerAddress].D3Matrix[level].referrals.length < 3) {\n', '        \t\n', '            emit NewUserPlace(userAddress, referrerAddress, 1, level,users[referrerAddress].D3Matrix[level].referrals.length);\n', '           \n', '            uint8 autolevel  = 1;\n', '            uint8 flag  = 0;\n', '            uint numcount;\n', '            if(level == 2){\n', '            \tif((reentry == 0) && (users[referrerAddress].D3Matrix[level].referrals.length == 1)){\n', '            \t\tflag  = 1;\n', '            \t\tnumcount = 1;\n', '            \t}\n', '        \t}else if(level > 3){\n', '        \t    if(level > 7){\n', '        \t        autolevel = 2;\n', '        \t    }\n', '        \t   if((level == 6) && (reentry == 0) && (users[referrerAddress].D3Matrix[level].referrals.length == 1)){\n', '        \t        flag  = 1;\n', '            \t    numcount = 1;\n', '            \t    autolevel = 2;\n', '        \t   }\n', '        \t   if((level == 8) && (reentry == 0) && (users[referrerAddress].D3Matrix[level].referrals.length == 1)){\n', '        \t        flag  = 1;\n', '            \t    numcount = 1;\n', '            \t    autolevel = 3;\n', '        \t   }\n', '            \tif(reentry >= 1){\n', '            \t\tflag  = 1;\n', '            \t\tnumcount = D3ReEntry[level-1];\n', '            \t}\n', '            \n', '            }\n', '        \t\n', '            if(flag == 1){\n', '        \t\tuint dividend = uint(levelPrice[level] - (D5LevelPrice[autolevel-1] * numcount));\n', '        \t\tfor (uint8 i = 1; i <= numcount; i++) {\n', '        \t\t\tupdateD5Referrer(referrerAddress,autolevel);\n', '        \t\t}\n', '        \t\temit payout(2,referrerAddress,dividend,1);\n', '        \t\treturn sendETHDividendsRemain(referrerAddress, userAddress, 1, level,dividend);\n', '        \t//emit payout(users[referrerAddress].D3Matrix[level].referrals.length,referrerAddress,dividend);\n', '        \t}else{\n', '        \t    emit payout(1,referrerAddress,levelPrice[level],1);\n', '            \treturn sendETHDividends(referrerAddress, userAddress, 1, level);\n', '            //\temit payout(users[referrerAddress].D3Matrix[level].referrals.length,referrerAddress,levelPrice[level]);\n', '            }\n', '        \n', '            //return sendETHDividends(referrerAddress, userAddress, 1, level);\n', '            \n', '        }\n', '        \n', '         //close matrix\n', '        users[referrerAddress].D3Matrix[level].referrals = new address[](0);\n', '        if (!users[referrerAddress].activeD3Levels[level+1] && level != LAST_LEVEL) {\n', '            if(reentry >= 1){\n', '        \t\tusers[referrerAddress].D3Matrix[level].blocked = true;\n', '        \t//\temit payout(1,referrerAddress,levelPrice[level]);\n', '        \temit payoutblock(referrerAddress,reentry);\n', '        \t}\n', '        }\n', '\n', '        //create new one by recursion\n', '        if (referrerAddress != owner) {\n', '            //check referrer active level\n', '            address freeReferrerAddress = findFreeD3Referrer(referrerAddress, level);\n', '            if (users[referrerAddress].D3Matrix[level].currentReferrer != freeReferrerAddress) {\n', '                users[referrerAddress].D3Matrix[level].currentReferrer = freeReferrerAddress;\n', '            }\n', '            \n', '            users[referrerAddress].D3Matrix[level].reinvestCount++;\n', '           // emit NewUserPlace(userAddress, referrerAddress, 1, level,3);\n', '            emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);\n', '            \n', '           \n', '            updateD3Referrer(referrerAddress, freeReferrerAddress, level);\n', '        } else {\n', '            sendETHDividends(owner, userAddress, 1, level);\n', '     \t\tusers[owner].D3Matrix[level].reinvestCount++;\n', '     \t//\temit NewUserPlace(userAddress,owner, 1, level,3);\n', '            emit Reinvest(owner, address(0), userAddress, 1, level);\n', '        }\n', '    }\n', '    \n', '    function updateD4Referrer(address userAddress, address referrerAddress, uint8 level) private {\n', '        require(users[referrerAddress].activeD4Levels[level], "500. Referrer level is inactive");\n', '        \n', '        if (users[referrerAddress].D4Matrix[level].firstLevelReferrals.length < 2) {\n', '            users[referrerAddress].D4Matrix[level].firstLevelReferrals.push(userAddress);\n', '            emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].D4Matrix[level].firstLevelReferrals.length));\n', '            \n', '            //set current level\n', '            users[userAddress].D4Matrix[level].currentReferrer = referrerAddress;\n', '\n', '            if (referrerAddress == owner) {\n', '                return sendETHDividends(referrerAddress, userAddress, 2, level);\n', '            }\n', '            \n', '            address ref = users[referrerAddress].D4Matrix[level].currentReferrer;            \n', '            users[ref].D4Matrix[level].secondLevelReferrals.push(userAddress); \n', '            \n', '            uint len = users[ref].D4Matrix[level].firstLevelReferrals.length;\n', '            \n', '            if ((len == 2) && \n', '                (users[ref].D4Matrix[level].firstLevelReferrals[0] == referrerAddress) &&\n', '                (users[ref].D4Matrix[level].firstLevelReferrals[1] == referrerAddress)) {\n', '                if (users[referrerAddress].D4Matrix[level].firstLevelReferrals.length == 1) {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 5);\n', '                } else {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 6);\n', '                }\n', '            }  else if ((len == 1 || len == 2) &&\n', '                    users[ref].D4Matrix[level].firstLevelReferrals[0] == referrerAddress) {\n', '                if (users[referrerAddress].D4Matrix[level].firstLevelReferrals.length == 1) {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 3);\n', '                } else {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 4);\n', '                }\n', '            } else if (len == 2 && users[ref].D4Matrix[level].firstLevelReferrals[1] == referrerAddress) {\n', '                if (users[referrerAddress].D4Matrix[level].firstLevelReferrals.length == 1) {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 5);\n', '                } else {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 6);\n', '                }\n', '            }\n', '\n', '            return updateD4ReferrerSecondLevel(userAddress, ref, level);\n', '        }\n', '        \n', '        users[referrerAddress].D4Matrix[level].secondLevelReferrals.push(userAddress);\n', '\n', '        if (users[referrerAddress].D4Matrix[level].closedPart != address(0)) {\n', '            if ((users[referrerAddress].D4Matrix[level].firstLevelReferrals[0] == \n', '                users[referrerAddress].D4Matrix[level].firstLevelReferrals[1]) &&\n', '                (users[referrerAddress].D4Matrix[level].firstLevelReferrals[0] ==\n', '                users[referrerAddress].D4Matrix[level].closedPart)) {\n', '\n', '                updateD4(userAddress, referrerAddress, level, true);\n', '                return updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '            } else if (users[referrerAddress].D4Matrix[level].firstLevelReferrals[0] == \n', '                users[referrerAddress].D4Matrix[level].closedPart) {\n', '                updateD4(userAddress, referrerAddress, level, true);\n', '                return updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '            } else {\n', '                updateD4(userAddress, referrerAddress, level, false);\n', '                return updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '            }\n', '        }\n', '\n', '        if (users[referrerAddress].D4Matrix[level].firstLevelReferrals[1] == userAddress) {\n', '            updateD4(userAddress, referrerAddress, level, false);\n', '            return updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '        } else if (users[referrerAddress].D4Matrix[level].firstLevelReferrals[0] == userAddress) {\n', '            updateD4(userAddress, referrerAddress, level, true);\n', '            return updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '        }\n', '        \n', '        if (users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[0]].D4Matrix[level].firstLevelReferrals.length <= \n', '            users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[1]].D4Matrix[level].firstLevelReferrals.length) {\n', '            updateD4(userAddress, referrerAddress, level, false);\n', '        } else {\n', '            updateD4(userAddress, referrerAddress, level, true);\n', '        }\n', '        \n', '        updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);\n', '    }\n', '\n', '    function updateD4(address userAddress, address referrerAddress, uint8 level, bool x2) private {\n', '        if (!x2) {\n', '            users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[0]].D4Matrix[level].firstLevelReferrals.push(userAddress);\n', '            emit NewUserPlace(userAddress, users[referrerAddress].D4Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[0]].D4Matrix[level].firstLevelReferrals.length));\n', '            emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[0]].D4Matrix[level].firstLevelReferrals.length));\n', '            //set current level\n', '            users[userAddress].D4Matrix[level].currentReferrer = users[referrerAddress].D4Matrix[level].firstLevelReferrals[0];\n', '        } else {\n', '            users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[1]].D4Matrix[level].firstLevelReferrals.push(userAddress);\n', '            emit NewUserPlace(userAddress, users[referrerAddress].D4Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[1]].D4Matrix[level].firstLevelReferrals.length));\n', '            emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[1]].D4Matrix[level].firstLevelReferrals.length));\n', '            //set current level\n', '            users[userAddress].D4Matrix[level].currentReferrer = users[referrerAddress].D4Matrix[level].firstLevelReferrals[1];\n', '        }\n', '    }\n', '    \n', '    function updateD4ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {\n', '        \n', '        if (users[referrerAddress].D4Matrix[level].secondLevelReferrals.length < 4) {\n', '          //  uint8 jlevel = level;\n', '        \t\n', '        \tif(level > 3){\n', '        \t    uint numcount = D4ReEntry[level-1];\n', '        \t    \n', '            \tuint8 autolevel  = 1;\n', '            \tif(level > 7){\n', '            \t    autolevel  = 2;\n', '            \t}\n', '            \tuint dividend = uint(levelPrice[level] - (D5LevelPrice[autolevel - 1] * numcount));\n', '            \t\n', '        \t\tfor (uint8 i = 1; i <= numcount; i++) {\n', '        \t\t    updateD5Referrer(referrerAddress,autolevel);\n', '        \t\t}\n', '        \t    emit payout(2,referrerAddress,dividend,2);\n', '        \t\treturn sendETHDividendsRemain(referrerAddress, userAddress, 2, level,dividend);\n', '        \t}else{\n', '        \t    emit payout(1,referrerAddress,levelPrice[level],2);\n', '                return sendETHDividends(referrerAddress, userAddress, 2, level);\n', '            }\n', '          }\n', '        \n', '        address[] memory D4data = users[users[referrerAddress].D4Matrix[level].currentReferrer].D4Matrix[level].firstLevelReferrals;\n', '        \n', '        if (D4data.length == 2) {\n', '            if (D4data[0] == referrerAddress ||\n', '                D4data[1] == referrerAddress) {\n', '                users[users[referrerAddress].D4Matrix[level].currentReferrer].D4Matrix[level].closedPart = referrerAddress;\n', '            } else if (D4data.length == 1) {\n', '                if (D4data[0] == referrerAddress) {\n', '                    users[users[referrerAddress].D4Matrix[level].currentReferrer].D4Matrix[level].closedPart = referrerAddress;\n', '                }\n', '            }\n', '        }\n', '        \n', '        users[referrerAddress].D4Matrix[level].firstLevelReferrals = new address[](0);\n', '        users[referrerAddress].D4Matrix[level].secondLevelReferrals = new address[](0);\n', '        users[referrerAddress].D4Matrix[level].closedPart = address(0);\n', '        \n', '        if (!users[referrerAddress].activeD4Levels[level+1] && level != LAST_LEVEL) {\n', '            if(users[referrerAddress].D4Matrix[level].reinvestCount >= 1){\n', '        \t\tusers[referrerAddress].D4Matrix[level].blocked = true;\n', '        \t    emit payoutblock(referrerAddress,users[referrerAddress].D4Matrix[level].reinvestCount);\n', '        \t}\n', '        }\n', '\n', '        users[referrerAddress].D4Matrix[level].reinvestCount++;\n', '        \n', '        \n', '        if (referrerAddress != owner) {\n', '            address freeReferrerAddress = findFreeD4Referrer(referrerAddress, level);\n', '           // emit NewUserPlace(userAddress, referrerAddress, 2, level,6);\n', '            emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);\n', '            updateD4Referrer(referrerAddress, freeReferrerAddress, level);\n', '        } else {\n', '          //  emit NewUserPlace(userAddress,owner, 2, level,6);\n', '            emit Reinvest(owner, address(0), userAddress, 2, level);\n', '            sendETHDividends(owner, userAddress, 2, level);\n', '        }\n', '    }\n', '    \n', '    function findFreeD3Referrer(address userAddress, uint8 level) public view returns(address) {\n', '        while (true) {\n', '            if (users[users[userAddress].referrer].activeD3Levels[level]) {\n', '                return users[userAddress].referrer;\n', '            }\n', '            \n', '            userAddress = users[userAddress].referrer;\n', '        }\n', '    }\n', '    \n', '    function findFreeD4Referrer(address userAddress, uint8 level) public view returns(address) {\n', '        while (true) {\n', '            if (users[users[userAddress].referrer].activeD4Levels[level]) {\n', '                return users[userAddress].referrer;\n', '            }\n', '            \n', '            userAddress = users[userAddress].referrer;\n', '        }\n', '    }\n', '        \n', '    function usersActiveD3Levels(address userAddress, uint8 level) public view returns(bool) {\n', '        return users[userAddress].activeD3Levels[level];\n', '    }\n', '\n', '    function usersActiveD4Levels(address userAddress, uint8 level) public view returns(bool) {\n', '        return users[userAddress].activeD4Levels[level];\n', '    }\n', '\n', '    function usersD3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {\n', '        return (users[userAddress].D3Matrix[level].currentReferrer,\n', '                users[userAddress].D3Matrix[level].referrals,\n', '                users[userAddress].D3Matrix[level].blocked);\n', '    }\n', '\n', '    function usersD4Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {\n', '        return (users[userAddress].D4Matrix[level].currentReferrer,\n', '                users[userAddress].D4Matrix[level].firstLevelReferrals,\n', '                users[userAddress].D4Matrix[level].secondLevelReferrals,\n', '                users[userAddress].D4Matrix[level].blocked,\n', '                users[userAddress].D4Matrix[level].closedPart);\n', '    }\n', '    \n', '    function usersD5Matrix(address userAddress, uint8 level) public view returns(uint, uint[] memory) {\n', '        return (L5Matrix[level].length,users[userAddress].D5Matrix[level].D5No);\n', '    }\n', '    \n', '    function isUserExists(address user) public view returns (bool) {\n', '        return (users[user].id != 0);\n', '    }\n', '\n', '    function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {\n', '        address receiver = userAddress;\n', '        bool isExtraDividends;\n', '        if (matrix == 1) {\n', '            while (true) {\n', '                if (users[receiver].D3Matrix[level].blocked) {\n', '                    emit MissedEthReceive(receiver, _from, 1, level);\n', '                    isExtraDividends = true;\n', '                    receiver = users[receiver].D3Matrix[level].currentReferrer;\n', '                } else {\n', '                    return (receiver, isExtraDividends);\n', '                }\n', '            }\n', '        } else {\n', '            while (true) {\n', '                if (users[receiver].D4Matrix[level].blocked) {\n', '                    emit MissedEthReceive(receiver, _from, 2, level);\n', '                    isExtraDividends = true;\n', '                    receiver = users[receiver].D4Matrix[level].currentReferrer;\n', '                } else {\n', '                    return (receiver, isExtraDividends);\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {\n', '        (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);\n', '\n', '        if (!address(uint160(receiver)).send(levelPrice[level])) {\n', '            return address(uint160(receiver)).transfer(address(this).balance);\n', '        }\n', '        \n', '        if (isExtraDividends) {\n', '            emit SentExtraEthDividends(_from, receiver, matrix, level);\n', '        }\n', '    }\n', '    \n', '    function sendETHDividendsRemain(address userAddress, address _from, uint8 matrix, uint8 level,uint dividend) private {\n', '        (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);\n', '\n', '        if (!address(uint160(receiver)).send(dividend)) {\n', '            return address(uint160(receiver)).transfer(address(this).balance);\n', '        }\n', '        \n', '        if (isExtraDividends) {\n', '            emit SentExtraEthDividends(_from, receiver, matrix, level);\n', '        }\n', '    }\n', '    \n', '    function sendETHD5(address receiver,uint dividend) private {\n', '        \n', '        if (!address(uint160(receiver)).send(dividend)) {\n', '            return address(uint160(receiver)).transfer(address(this).balance);\n', '        }\n', '        \n', '    }\n', '    \n', '    function bytesToAddress(bytes memory bys) private pure returns (address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '}']
['/*\n', '// ONE ID 10\n', '\n', '// Hello \n', '// I am Onene One  IDID 10,\n', '// Global One ID AutoPool Smart contract.\n', '// Earn more than 300000 ETH with just 2 ETH.\n', '// This is a tool to generate passive income.\n', '// ADVANTAGES OF THIS SMART CONTRACT\n', '\n', '// Only allow registration if 1 Referral ID is 1.\n', '// Can not stop, exist forever.\n', '// Simple registration and upgrade. No login or password required.\n', '// Auto-overflow.\n', '// Repeat high income to level 10.\n', '// Every member is happy.\n', '// Simple and manipulative interface on Etherscan.\n', '// Open source, authenticated on Etherscan.\n', '// High income. invite people online & offline.\n', '// Market development by international leaders.\n', '// And more, ...\n', '\n', '// My URL : https://Oneid10github.io\n', '// Telegram Channel: https://t.me/ONE_ID_10\n', '// Private Telegram Group: https://t.me/joinchat/DQWsThP_PYUT9rL4HywAhg\n', '// Hashtag: #Oneid10\n', '*/\n', 'pragma solidity 0.5.11 - 0.6.4;\n', '\n', 'contract OneID10 {\n', '     address public ownerWallet;\n', '      uint public currUserID = 0;\n', '      uint public pool1currUserID = 0;\n', '      uint public pool2currUserID = 0;\n', '      uint public pool3currUserID = 0;\n', '      uint public pool4currUserID = 0;\n', '      uint public pool5currUserID = 0;\n', '      uint public pool6currUserID = 0;\n', '      uint public pool7currUserID = 0;\n', '      uint public pool8currUserID = 0;\n', '      uint public pool9currUserID = 0;\n', '      uint public pool10currUserID = 0;\n', '      \n', '        uint public pool1activeUserID = 0;\n', '      uint public pool2activeUserID = 0;\n', '      uint public pool3activeUserID = 0;\n', '      uint public pool4activeUserID = 0;\n', '      uint public pool5activeUserID = 0;\n', '      uint public pool6activeUserID = 0;\n', '      uint public pool7activeUserID = 0;\n', '      uint public pool8activeUserID = 0;\n', '      uint public pool9activeUserID = 0;\n', '      uint public pool10activeUserID = 0;\n', '      \n', '      \n', '      uint public unlimited_level_price=0;\n', '     \n', '      struct UserStruct {\n', '        bool isExist;\n', '        uint id;\n', '        uint referrerID;\n', '       uint referredUsers;\n', '        mapping(uint => uint) levelExpired;\n', '    }\n', '    \n', '     struct PoolUserStruct {\n', '        bool isExist;\n', '        uint id;\n', '       uint payment_received; \n', '    }\n', '    \n', '    mapping (address => UserStruct) public users;\n', '     mapping (uint => address) public userList;\n', '     \n', '     mapping (address => PoolUserStruct) public pool1users;\n', '     mapping (uint => address) public pool1userList;\n', '     \n', '     mapping (address => PoolUserStruct) public pool2users;\n', '     mapping (uint => address) public pool2userList;\n', '     \n', '     mapping (address => PoolUserStruct) public pool3users;\n', '     mapping (uint => address) public pool3userList;\n', '     \n', '     mapping (address => PoolUserStruct) public pool4users;\n', '     mapping (uint => address) public pool4userList;\n', '     \n', '     mapping (address => PoolUserStruct) public pool5users;\n', '     mapping (uint => address) public pool5userList;\n', '     \n', '     mapping (address => PoolUserStruct) public pool6users;\n', '     mapping (uint => address) public pool6userList;\n', '     \n', '     mapping (address => PoolUserStruct) public pool7users;\n', '     mapping (uint => address) public pool7userList;\n', '     \n', '     mapping (address => PoolUserStruct) public pool8users;\n', '     mapping (uint => address) public pool8userList;\n', '     \n', '     mapping (address => PoolUserStruct) public pool9users;\n', '     mapping (uint => address) public pool9userList;\n', '     \n', '     mapping (address => PoolUserStruct) public pool10users;\n', '     mapping (uint => address) public pool10userList;\n', '     \n', '    mapping(uint => uint) public LEVEL_PRICE;\n', '    \n', '   uint REGESTRATION_FESS=0.5 ether;\n', '   uint pool1_price=1 ether;\n', '   uint pool2_price=2 ether ;\n', '   uint pool3_price=5 ether;\n', '   uint pool4_price=10 ether;\n', '   uint pool5_price=20 ether;\n', '   uint pool6_price=50 ether;\n', '   uint pool7_price=100 ether ;\n', '   uint pool8_price=200 ether;\n', '   uint pool9_price=500 ether;\n', '   uint pool10_price=1000 ether;\n', '   \n', '     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);\n', '      event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);\n', '      \n', '     event regPoolEntry(address indexed _user,uint _level,   uint _time);\n', '   \n', '     \n', '    event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);\n', '   \n', '    UserStruct[] public requests;\n', '     \n', '      constructor() public {\n', '          ownerWallet = msg.sender;\n', '\n', '        LEVEL_PRICE[1] = 0.1 ether;\n', '        LEVEL_PRICE[2] = 0.05 ether;\n', '        LEVEL_PRICE[3] = 0.025 ether;\n', '        LEVEL_PRICE[4] = 0.0025 ether;\n', '      unlimited_level_price=0.0025 ether;\n', '\n', '        UserStruct memory userStruct;\n', '        currUserID++;\n', '\n', '        userStruct = UserStruct({\n', '            isExist: true,\n', '            id: currUserID,\n', '            referrerID: 0,\n', '            referredUsers:0\n', '           \n', '        });\n', '        \n', '        users[ownerWallet] = userStruct;\n', '       userList[currUserID] = ownerWallet;\n', '       \n', '       \n', '         PoolUserStruct memory pooluserStruct;\n', '        \n', '        pool1currUserID++;\n', '\n', '        pooluserStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool1currUserID,\n', '            payment_received:0\n', '        });\n', '    pool1activeUserID=pool1currUserID;\n', '       pool1users[msg.sender] = pooluserStruct;\n', '       pool1userList[pool1currUserID]=msg.sender;\n', '      \n', '        \n', '        pool2currUserID++;\n', '        pooluserStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool2currUserID,\n', '            payment_received:0\n', '        });\n', '    pool2activeUserID=pool2currUserID;\n', '       pool2users[msg.sender] = pooluserStruct;\n', '       pool2userList[pool2currUserID]=msg.sender;\n', '       \n', '       \n', '        pool3currUserID++;\n', '        pooluserStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool3currUserID,\n', '            payment_received:0\n', '        });\n', '    pool3activeUserID=pool3currUserID;\n', '       pool3users[msg.sender] = pooluserStruct;\n', '       pool3userList[pool3currUserID]=msg.sender;\n', '       \n', '       \n', '         pool4currUserID++;\n', '        pooluserStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool4currUserID,\n', '            payment_received:0\n', '        });\n', '    pool4activeUserID=pool4currUserID;\n', '       pool4users[msg.sender] = pooluserStruct;\n', '       pool4userList[pool4currUserID]=msg.sender;\n', '\n', '        \n', '          pool5currUserID++;\n', '        pooluserStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool5currUserID,\n', '            payment_received:0\n', '        });\n', '    pool5activeUserID=pool5currUserID;\n', '       pool5users[msg.sender] = pooluserStruct;\n', '       pool5userList[pool5currUserID]=msg.sender;\n', '       \n', '       \n', '         pool6currUserID++;\n', '        pooluserStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool6currUserID,\n', '            payment_received:0\n', '        });\n', '    pool6activeUserID=pool6currUserID;\n', '       pool6users[msg.sender] = pooluserStruct;\n', '       pool6userList[pool6currUserID]=msg.sender;\n', '       \n', '         pool7currUserID++;\n', '        pooluserStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool7currUserID,\n', '            payment_received:0\n', '        });\n', '    pool7activeUserID=pool7currUserID;\n', '       pool7users[msg.sender] = pooluserStruct;\n', '       pool7userList[pool7currUserID]=msg.sender;\n', '       \n', '       pool8currUserID++;\n', '        pooluserStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool8currUserID,\n', '            payment_received:0\n', '        });\n', '    pool8activeUserID=pool8currUserID;\n', '       pool8users[msg.sender] = pooluserStruct;\n', '       pool8userList[pool8currUserID]=msg.sender;\n', '       \n', '        pool9currUserID++;\n', '        pooluserStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool9currUserID,\n', '            payment_received:0\n', '        });\n', '    pool9activeUserID=pool9currUserID;\n', '       pool9users[msg.sender] = pooluserStruct;\n', '       pool9userList[pool9currUserID]=msg.sender;\n', '       \n', '       \n', '        pool10currUserID++;\n', '        pooluserStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool10currUserID,\n', '            payment_received:0\n', '        });\n', '    pool10activeUserID=pool10currUserID;\n', '       pool10users[msg.sender] = pooluserStruct;\n', '       pool10userList[pool10currUserID]=msg.sender;\n', '       \n', '       \n', '      }\n', '     \n', '       function regUser(uint _referrerID) public payable {\n', '       \n', '      require(!users[msg.sender].isExist, "User Exists");\n', "      require(_referrerID > 0 && _referrerID < 2 , 'Use Only ID 1 As a General Referral ID');\n", "        require(msg.value == REGESTRATION_FESS, 'Incorrect Value');\n", '       \n', '        UserStruct memory userStruct;\n', '        currUserID++;\n', '\n', '        userStruct = UserStruct({\n', '            isExist: true,\n', '            id: currUserID,\n', '            referrerID: _referrerID,\n', '            referredUsers:0\n', '        });\n', '   \n', '    \n', '       users[msg.sender] = userStruct;\n', '       userList[currUserID]=msg.sender;\n', '       \n', '        users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;\n', '        \n', '       payReferral(1,msg.sender);\n', '        emit regLevelEvent(msg.sender, userList[_referrerID], now);\n', '    }\n', '   \n', '   \n', '     function payReferral(uint _level, address _user) internal {\n', '        address referer;\n', '       \n', '        referer = userList[users[_user].referrerID];\n', '       \n', '       \n', '         bool sent = false;\n', '       \n', '            uint level_price_local=0;\n', '            if(_level>4){\n', '            level_price_local=unlimited_level_price;\n', '            }\n', '            else{\n', '            level_price_local=LEVEL_PRICE[_level];\n', '            }\n', '            sent = address(uint160(referer)).send(level_price_local);\n', '\n', '            if (sent) {\n', '                emit getMoneyForLevelEvent(referer, msg.sender, _level, now);\n', '                if(_level < 50 && users[referer].referrerID >= 1){\n', '                    payReferral(_level+1,referer);\n', '                }\n', '                else\n', '                {\n', '                    sendBalance();\n', '                }\n', '               \n', '            }\n', '       \n', '        if(!sent) {\n', '          //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);\n', '\n', '            payReferral(_level, referer);\n', '        }\n', '     }\n', '   \n', '   \n', '   \n', '   \n', '       function buyPool1() public payable {\n', '       require(users[msg.sender].isExist, "User Not Registered");\n', '      require(!pool1users[msg.sender].isExist, "Already in AutoPool");\n', '      \n', "        require(msg.value == pool1_price, 'Incorrect Value');\n", '        \n', '       \n', '        PoolUserStruct memory userStruct;\n', '        address pool1Currentuser=pool1userList[pool1activeUserID];\n', '        \n', '        pool1currUserID++;\n', '\n', '        userStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool1currUserID,\n', '            payment_received:0\n', '        });\n', '   \n', '       pool1users[msg.sender] = userStruct;\n', '       pool1userList[pool1currUserID]=msg.sender;\n', '       bool sent = false;\n', '       sent = address(uint160(pool1Currentuser)).send(pool1_price);\n', '\n', '            if (sent) {\n', '                pool1users[pool1Currentuser].payment_received+=1;\n', '                if(pool1users[pool1Currentuser].payment_received>=2)\n', '                {\n', '                    pool1activeUserID+=1;\n', '                }\n', '                emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);\n', '            }\n', '       emit regPoolEntry(msg.sender, 1, now);\n', '    }\n', '    \n', '    \n', '      function buyPool2() public payable {\n', '          require(users[msg.sender].isExist, "User Not Registered");\n', '      require(!pool2users[msg.sender].isExist, "Already in AutoPool");\n', "        require(msg.value == pool2_price, 'Incorrect Value');\n", '        require(users[msg.sender].referredUsers>=0, "Must need 0 referral");\n', '         \n', '        PoolUserStruct memory userStruct;\n', '        address pool2Currentuser=pool2userList[pool2activeUserID];\n', '        \n', '        pool2currUserID++;\n', '        userStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool2currUserID,\n', '            payment_received:0\n', '        });\n', '       pool2users[msg.sender] = userStruct;\n', '       pool2userList[pool2currUserID]=msg.sender;\n', '       \n', '       \n', '       \n', '       bool sent = false;\n', '       sent = address(uint160(pool2Currentuser)).send(pool2_price);\n', '\n', '            if (sent) {\n', '                pool2users[pool2Currentuser].payment_received+=1;\n', '                if(pool2users[pool2Currentuser].payment_received>=3)\n', '                {\n', '                    pool2activeUserID+=1;\n', '                }\n', '                emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);\n', '            }\n', '            emit regPoolEntry(msg.sender,2,  now);\n', '    }\n', '    \n', '    \n', '     function buyPool3() public payable {\n', '         require(users[msg.sender].isExist, "User Not Registered");\n', '      require(!pool3users[msg.sender].isExist, "Already in AutoPool");\n', "        require(msg.value == pool3_price, 'Incorrect Value');\n", '        require(users[msg.sender].referredUsers>=0, "Must need 0 referral");\n', '        \n', '        PoolUserStruct memory userStruct;\n', '        address pool3Currentuser=pool3userList[pool3activeUserID];\n', '        \n', '        pool3currUserID++;\n', '        userStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool3currUserID,\n', '            payment_received:0\n', '        });\n', '       pool3users[msg.sender] = userStruct;\n', '       pool3userList[pool3currUserID]=msg.sender;\n', '       bool sent = false;\n', '       sent = address(uint160(pool3Currentuser)).send(pool3_price);\n', '\n', '            if (sent) {\n', '                pool3users[pool3Currentuser].payment_received+=1;\n', '                if(pool3users[pool3Currentuser].payment_received>=4)\n', '                {\n', '                    pool3activeUserID+=1;\n', '                }\n', '                emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);\n', '            }\n', 'emit regPoolEntry(msg.sender,3,  now);\n', '    }\n', '    \n', '    \n', '    function buyPool4() public payable {\n', '        require(users[msg.sender].isExist, "User Not Registered");\n', '      require(!pool4users[msg.sender].isExist, "Already in AutoPool");\n', "        require(msg.value == pool4_price, 'Incorrect Value');\n", '        require(users[msg.sender].referredUsers>=0, "Must need 0 referral");\n', '      \n', '        PoolUserStruct memory userStruct;\n', '        address pool4Currentuser=pool4userList[pool4activeUserID];\n', '        \n', '        pool4currUserID++;\n', '        userStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool4currUserID,\n', '            payment_received:0\n', '        });\n', '       pool4users[msg.sender] = userStruct;\n', '       pool4userList[pool4currUserID]=msg.sender;\n', '       bool sent = false;\n', '       sent = address(uint160(pool4Currentuser)).send(pool4_price);\n', '\n', '            if (sent) {\n', '                pool4users[pool4Currentuser].payment_received+=1;\n', '                if(pool4users[pool4Currentuser].payment_received>=5)\n', '                {\n', '                    pool4activeUserID+=1;\n', '                }\n', '                 emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);\n', '            }\n', '        emit regPoolEntry(msg.sender,4, now);\n', '    }\n', '    \n', '    \n', '    \n', '    function buyPool5() public payable {\n', '        require(users[msg.sender].isExist, "User Not Registered");\n', '      require(!pool5users[msg.sender].isExist, "Already in AutoPool");\n', "        require(msg.value == pool5_price, 'Incorrect Value');\n", '        require(users[msg.sender].referredUsers>=0, "Must need 0 referral");\n', '        \n', '        PoolUserStruct memory userStruct;\n', '        address pool5Currentuser=pool5userList[pool5activeUserID];\n', '        \n', '        pool5currUserID++;\n', '        userStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool5currUserID,\n', '            payment_received:0\n', '        });\n', '       pool5users[msg.sender] = userStruct;\n', '       pool5userList[pool5currUserID]=msg.sender;\n', '       bool sent = false;\n', '       sent = address(uint160(pool5Currentuser)).send(pool5_price);\n', '\n', '            if (sent) {\n', '                pool5users[pool5Currentuser].payment_received+=1;\n', '                if(pool5users[pool5Currentuser].payment_received>=6)\n', '                {\n', '                    pool5activeUserID+=1;\n', '                }\n', '                 emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);\n', '            }\n', '        emit regPoolEntry(msg.sender,5,  now);\n', '    }\n', '    \n', '    function buyPool6() public payable {\n', '      require(!pool6users[msg.sender].isExist, "Already in AutoPool");\n', "        require(msg.value == pool6_price, 'Incorrect Value');\n", '        require(users[msg.sender].referredUsers>=0, "Must need 0 referral");\n', '        \n', '        PoolUserStruct memory userStruct;\n', '        address pool6Currentuser=pool6userList[pool6activeUserID];\n', '        \n', '        pool6currUserID++;\n', '        userStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool6currUserID,\n', '            payment_received:0\n', '        });\n', '       pool6users[msg.sender] = userStruct;\n', '       pool6userList[pool6currUserID]=msg.sender;\n', '       bool sent = false;\n', '       sent = address(uint160(pool6Currentuser)).send(pool6_price);\n', '\n', '            if (sent) {\n', '                pool6users[pool6Currentuser].payment_received+=1;\n', '                if(pool6users[pool6Currentuser].payment_received>=7)\n', '                {\n', '                    pool6activeUserID+=1;\n', '                }\n', '                 emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);\n', '            }\n', '        emit regPoolEntry(msg.sender,6,  now);\n', '    }\n', '    \n', '    function buyPool7() public payable {\n', '        require(users[msg.sender].isExist, "User Not Registered");\n', '      require(!pool7users[msg.sender].isExist, "Already in AutoPool");\n', "        require(msg.value == pool7_price, 'Incorrect Value');\n", '        require(users[msg.sender].referredUsers>=0, "Must need 0 referral");\n', '        \n', '        PoolUserStruct memory userStruct;\n', '        address pool7Currentuser=pool7userList[pool7activeUserID];\n', '        \n', '        pool7currUserID++;\n', '        userStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool7currUserID,\n', '            payment_received:0\n', '        });\n', '       pool7users[msg.sender] = userStruct;\n', '       pool7userList[pool7currUserID]=msg.sender;\n', '       bool sent = false;\n', '       sent = address(uint160(pool7Currentuser)).send(pool7_price);\n', '\n', '            if (sent) {\n', '                pool7users[pool7Currentuser].payment_received+=1;\n', '                if(pool7users[pool7Currentuser].payment_received>=8)\n', '                {\n', '                    pool7activeUserID+=1;\n', '                }\n', '                 emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);\n', '            }\n', '        emit regPoolEntry(msg.sender,7,  now);\n', '    }\n', '    \n', '    \n', '    function buyPool8() public payable {\n', '        require(users[msg.sender].isExist, "User Not Registered");\n', '      require(!pool8users[msg.sender].isExist, "Already in AutoPool");\n', "        require(msg.value == pool8_price, 'Incorrect Value');\n", '        require(users[msg.sender].referredUsers>=0, "Must need 0 referral");\n', '       \n', '        PoolUserStruct memory userStruct;\n', '        address pool8Currentuser=pool8userList[pool8activeUserID];\n', '        \n', '        pool8currUserID++;\n', '        userStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool8currUserID,\n', '            payment_received:0\n', '        });\n', '       pool8users[msg.sender] = userStruct;\n', '       pool8userList[pool8currUserID]=msg.sender;\n', '       bool sent = false;\n', '       sent = address(uint160(pool8Currentuser)).send(pool8_price);\n', '\n', '            if (sent) {\n', '                pool8users[pool8Currentuser].payment_received+=1;\n', '                if(pool8users[pool8Currentuser].payment_received>=9)\n', '                {\n', '                    pool8activeUserID+=1;\n', '                }\n', '                 emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);\n', '            }\n', '        emit regPoolEntry(msg.sender,8,  now);\n', '    }\n', '    \n', '    \n', '    \n', '    function buyPool9() public payable {\n', '        require(users[msg.sender].isExist, "User Not Registered");\n', '      require(!pool9users[msg.sender].isExist, "Already in AutoPool");\n', "        require(msg.value == pool9_price, 'Incorrect Value');\n", '        require(users[msg.sender].referredUsers>=0, "Must need 0 referral");\n', '       \n', '        PoolUserStruct memory userStruct;\n', '        address pool9Currentuser=pool9userList[pool9activeUserID];\n', '        \n', '        pool9currUserID++;\n', '        userStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool9currUserID,\n', '            payment_received:0\n', '        });\n', '       pool9users[msg.sender] = userStruct;\n', '       pool9userList[pool9currUserID]=msg.sender;\n', '       bool sent = false;\n', '       sent = address(uint160(pool9Currentuser)).send(pool9_price);\n', '\n', '            if (sent) {\n', '                pool9users[pool9Currentuser].payment_received+=1;\n', '                if(pool9users[pool9Currentuser].payment_received>=10)\n', '                {\n', '                    pool9activeUserID+=1;\n', '                }\n', '                 emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);\n', '            }\n', '        emit regPoolEntry(msg.sender,9,  now);\n', '    }\n', '    \n', '    \n', '    function buyPool10() public payable {\n', '        require(users[msg.sender].isExist, "User Not Registered");\n', '      require(!pool10users[msg.sender].isExist, "Already in AutoPool");\n', "        require(msg.value == pool10_price, 'Incorrect Value');\n", '        require(users[msg.sender].referredUsers>=0, "Must need 0 referral");\n', '        \n', '        PoolUserStruct memory userStruct;\n', '        address pool10Currentuser=pool10userList[pool10activeUserID];\n', '        \n', '        pool10currUserID++;\n', '        userStruct = PoolUserStruct({\n', '            isExist:true,\n', '            id:pool10currUserID,\n', '            payment_received:0\n', '        });\n', '       pool10users[msg.sender] = userStruct;\n', '       pool10userList[pool10currUserID]=msg.sender;\n', '       bool sent = false;\n', '       sent = address(uint160(pool10Currentuser)).send(pool10_price);\n', '\n', '            if (sent) {\n', '                pool10users[pool10Currentuser].payment_received+=1;\n', '                if(pool10users[pool10Currentuser].payment_received>=300)\n', '                {\n', '                    pool10activeUserID+=1;\n', '                }\n', '                 emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);\n', '            }\n', '        emit regPoolEntry(msg.sender, 10, now);\n', '    }\n', '    \n', '    function getEthBalance() public view returns(uint) {\n', '    return address(this).balance;\n', '    }\n', '    \n', '    function sendBalance() private\n', '    {\n', '         if (!address(uint160(ownerWallet)).send(getEthBalance()))\n', '         {\n', '             \n', '         }\n', '    }\n', ' }']
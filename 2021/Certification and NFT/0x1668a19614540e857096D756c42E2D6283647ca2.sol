['/**\n', ' *Submitted for verification at Etherscan.io on 2021-01-31\n', '*/\n', '\n', 'pragma solidity ^0.4.17;\n', '\n', 'contract Ownable  {\n', '    function viewManager() public view returns(address);\n', '}\n', '\n', '\n', 'contract BrightFund {\n', '    \n', '    address public ownerWallet;\n', '    Ownable ownable = Ownable(0x31C3739b6029944eDd828fad742379513d8d0B63);\n', '\n', '   \n', '    struct UserStruct {\n', '        bool isExist;\n', '        uint id;\n', '        uint referrerID;\n', '        address[] referral;\n', '        mapping(uint => uint) levelExpired;\n', '        mapping(uint => uint) levelExpiredPro;\n', '        mapping(uint => uint) levelExpiredLegendary;\n', '    }\n', '    \n', '    uint REFERRER_1_LEVEL_LIMIT = 2;\n', '    uint PERIOD_LENGTH_STANDARD = 64 days;\n', '    uint PERIOD_LENGTH_PRO = 128 days;\n', '    uint PERIOD_LENGTH_LEGENDARY = 256 days;\n', '\n', '    mapping(uint => uint) public LEVEL_PRICE;\n', '\n', '    mapping(address => UserStruct) public users;\n', '    mapping(uint => address) public userList;\n', '    uint public currUserID = 0;\n', '    \n', '    uint public l1l1users = 0;\n', '    uint public l1l2users = 0;\n', '    uint public l1l3users = 0;\n', '    uint public l1l4users = 0;\n', '    uint public l1l5users = 0;\n', '    uint public l1l6users = 0;\n', '    uint public l1l7users = 0;\n', '    uint public l1l8users = 0;\n', '    \n', '    uint public l2l1users = 0;\n', '    uint public l2l2users = 0;\n', '    uint public l2l3users = 0;\n', '    uint public l2l4users = 0;\n', '    uint public l2l5users = 0;\n', '    uint public l2l6users = 0;\n', '    uint public l2l7users = 0;\n', '    uint public l2l8users = 0;\n', '\n', '    uint public l3l1users = 0;\n', '    uint public l3l2users = 0;\n', '    uint public l3l3users = 0;\n', '    uint public l3l4users = 0;\n', '    uint public l3l5users = 0;\n', '    uint public l3l6users = 0;\n', '    uint public l3l7users = 0;\n', '    uint public l3l8users = 0;\n', '\n', '    event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);\n', '    event buyLevelEvent(address indexed _user, uint _level, uint _league, uint _time);\n', '    event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _league, uint _time);\n', '    event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _league, uint _time);\n', '\n', '    constructor() public {\n', '        ownerWallet = msg.sender;\n', '        LEVEL_PRICE[1] = 0.04 ether;\n', '        LEVEL_PRICE[2] = 0.08 ether;\n', '        LEVEL_PRICE[3] = 0.16 ether;\n', '        LEVEL_PRICE[4] = 0.32 ether;\n', '        LEVEL_PRICE[5] = 0.64 ether;\n', '        LEVEL_PRICE[6] = 1.28 ether;\n', '        LEVEL_PRICE[7] = 2.56 ether;\n', '        LEVEL_PRICE[8] = 5.12 ether;\n', '\n', '\n', '\n', '\n', '        LEVEL_PRICE[9] = 2.0 ether;\n', '        LEVEL_PRICE[10] = 4.0 ether;\n', '        LEVEL_PRICE[11] = 8.0 ether;\n', '        LEVEL_PRICE[12] = 16.0 ether;\n', '        LEVEL_PRICE[13] = 32.0 ether;\n', '        LEVEL_PRICE[14] = 64.0 ether;\n', '        LEVEL_PRICE[15] = 128.0 ether;\n', '        LEVEL_PRICE[16] = 256.0 ether;\n', '\n', '\n', '\n', '\n', '        LEVEL_PRICE[17] = 16.0 ether;\n', '        LEVEL_PRICE[18] = 32.0 ether;\n', '        LEVEL_PRICE[19] = 64.0 ether;\n', '        LEVEL_PRICE[20] = 128.0 ether;\n', '        LEVEL_PRICE[21] = 256.0 ether;\n', '        LEVEL_PRICE[22] = 512.0 ether;\n', '        LEVEL_PRICE[23] = 1024.0 ether;\n', '        LEVEL_PRICE[24] = 2048.0 ether;\n', '\n', '        UserStruct memory userStruct;\n', '        currUserID++;\n', '\n', '        userStruct = UserStruct({\n', '            isExist: true,\n', '            id: currUserID,\n', '            referrerID: 0,\n', '            referral: new address[](0)\n', '        });\n', '        users[ownerWallet] = userStruct;\n', '        userList[currUserID] = ownerWallet;\n', '\n', '        for (uint i = 1; i <= 8; i++) {\n', '            users[ownerWallet].levelExpired[i] = 55555555555;\n', '            users[ownerWallet].levelExpiredPro[i] = 55555555555;\n', '            users[ownerWallet].levelExpiredLegendary[i] = 55555555555;\n', '        }\n', '    }\n', '\n', '    function () external payable {\n', '        uint level;\n', '        uint league;\n', '\n', '        if (msg.value == LEVEL_PRICE[1]) { level = 1; league = 1;}\n', '        else if (msg.value == LEVEL_PRICE[2]) { level = 2; league = 1;}\n', '        else if (msg.value == LEVEL_PRICE[3]) { level = 3; league = 1;}\n', '        else if (msg.value == LEVEL_PRICE[4]) { level = 4; league = 1;}\n', '        else if (msg.value == LEVEL_PRICE[5]) { level = 5; league = 1;}\n', '        else if (msg.value == LEVEL_PRICE[6]) { level = 6; league = 1;}\n', '        else if (msg.value == LEVEL_PRICE[7]) { level = 7; league = 1;}\n', '        else if (msg.value == LEVEL_PRICE[8]) { level = 8; league = 1;}\n', '        else if (msg.value == LEVEL_PRICE[9]) { level = 1; league = 2;}\n', '        else if (msg.value == LEVEL_PRICE[10]) { level = 2; league = 2;}\n', '        else if (msg.value == LEVEL_PRICE[11]) { level = 3; league = 2;}\n', '        else if (msg.value == LEVEL_PRICE[12]) { level = 4; league = 2;}\n', '        else if (msg.value == LEVEL_PRICE[13]) { level = 5; league = 2;}\n', '        else if (msg.value == LEVEL_PRICE[14]) { level = 6; league = 2;}\n', '        else if (msg.value == LEVEL_PRICE[15]) { level = 7; league = 2;}\n', '        else if (msg.value == LEVEL_PRICE[16]) { level = 8; league = 2;}\n', '        else if (msg.value == LEVEL_PRICE[17]) { level = 1; league = 3;}\n', '        else if (msg.value == LEVEL_PRICE[18]) { level = 2; league = 3;}\n', '        else if (msg.value == LEVEL_PRICE[19]) { level = 3; league = 3;}\n', '        else if (msg.value == LEVEL_PRICE[20]) { level = 4; league = 3;}\n', '        else if (msg.value == LEVEL_PRICE[21]) { level = 5; league = 3;}\n', '        else if (msg.value == LEVEL_PRICE[22]) { level = 6; league = 3;}\n', '        else if (msg.value == LEVEL_PRICE[23]) { level = 7; league = 3;}\n', '        else if (msg.value == LEVEL_PRICE[24]) { level = 8; league = 3;}\n', "        else revert('Incorrect Value send');\n", '\n', '        if (users[msg.sender].isExist) buyLevel(level, league);\n', '        else if (level == 1 && !users[msg.sender].isExist && league == 1) {\n', '            uint refId = 0;\n', '            address referrer = bytesToAddress(msg.data);\n', '            if (users[referrer].isExist) refId = users[referrer].id;\n', "            else revert('Incorrect referrer');\n", '            regUser(refId);\n', "        } else revert('Please buy first level for 0.04 ETH');\n", '    }\n', '\n', '    function regUser(uint _referrerID) public payable {\n', "        require(!users[msg.sender].isExist, 'User exist');\n", "        require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');\n", "        require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');\n", '\n', '        if (users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT && userList[_referrerID] != ownerWallet) _referrerID = users[findFreeReferrer(userList[_referrerID])].id;\n', '\n', '        UserStruct memory userStruct;\n', '        currUserID++;\n', '        l1l1users++;\n', '\n', '\n', '        userStruct = UserStruct({\n', '            isExist: true,\n', '            id: currUserID,\n', '            referrerID: _referrerID,\n', '            referral: new address[](0)\n', '        });\n', '\n', '        users[msg.sender] = userStruct;\n', '        userList[currUserID] = msg.sender;\n', '\n', '        users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH_STANDARD;\n', '\n', '        users[userList[_referrerID]].referral.push(msg.sender);\n', '\n', '        payForLevel(1, msg.sender, 1);\n', '\n', '        emit regLevelEvent(msg.sender, userList[_referrerID], now);\n', '    }\n', '\n', '    function buyLevel(uint _level, uint _league) public payable {\n', '        \n', "        require(users[msg.sender].isExist, 'User not exist');\n", "        require(_level > 0 && _level <= 8, 'Incorrect level');\n", '        uint l;\n', '        \n', "         if (_league == 2) for (l = 5; l > 0; l--) require(users[msg.sender].levelExpired[l] >= PERIOD_LENGTH_PRO, 'Buy the previous league 1 level 5');\n", '         else if (_league == 3) {\n', "            for (l = 5; l > 0; l--) require(users[msg.sender].levelExpired[l] >= PERIOD_LENGTH_LEGENDARY, 'Buy the previous league 1 level 5');\n", "            for (l = 5; l > 0; l--) require(users[msg.sender].levelExpiredPro[l] >= PERIOD_LENGTH_LEGENDARY, 'Buy the previous league 2 level 5');\n", '         }\n', '\n', '        \n', '        if (_level == 1) {\n', "            if (_league == 1) require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');\n", "            else if (_league == 2) require(msg.value == LEVEL_PRICE[9], 'Incorrect Value');\n", "            else if (_league == 3) require(msg.value == LEVEL_PRICE[17], 'Incorrect Value');\n", '\n', '            if (_league == 1) {\n', '                l1l1users++;\n', '                users[msg.sender].levelExpired[1] += PERIOD_LENGTH_STANDARD;\n', '            } else if (_league == 2) {\n', '                if (users[msg.sender].levelExpiredPro[1] == 0) {\n', '                    l2l1users++;\n', '                    users[msg.sender].levelExpiredPro[1] = now + PERIOD_LENGTH_PRO;\n', '                } else users[msg.sender].levelExpiredPro[1] += PERIOD_LENGTH_PRO;\n', '             } else if (_league == 3) {\n', '                if (users[msg.sender].levelExpiredLegendary[1] == 0) {\n', '                    users[msg.sender].levelExpiredLegendary[1] = now + PERIOD_LENGTH_LEGENDARY;\n', '                    l3l1users++;\n', '                } else users[msg.sender].levelExpiredLegendary[1] += PERIOD_LENGTH_LEGENDARY;\n', '            }\n', '        } else {\n', '            if (_league == 1) {\n', "                require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');\n", "                for (l = _level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');\n", '                if (users[msg.sender].levelExpired[_level] == 0) {\n', '                        users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH_STANDARD;\n', '                } else users[msg.sender].levelExpired[_level] += PERIOD_LENGTH_STANDARD;\n', '                if (_level == 1) l1l1users++;\n', '                if (_level == 2) l1l2users++;\n', '                if (_level == 3) l1l3users++;\n', '                if (_level == 4) l1l4users++;\n', '                if (_level == 5) l1l5users++;\n', '                if (_level == 6) l1l6users++;\n', '                if (_level == 7) l1l7users++;\n', '                if (_level == 8) l1l8users++;\n', '            } else if (_league == 2) {\n', "                require(msg.value == LEVEL_PRICE[_level + 8], 'Incorrect Value');\n", "                for (l = _level - 1; l > 0; l--) require(users[msg.sender].levelExpiredPro[l] >= now, 'Buy the previous level');\n", '                if (users[msg.sender].levelExpiredPro[_level] == 0) {\n', '                    users[msg.sender].levelExpiredPro[_level] = now + PERIOD_LENGTH_PRO;\n', '                } else users[msg.sender].levelExpiredPro[_level] += PERIOD_LENGTH_PRO;\n', '                if (_level == 1) l2l1users++;\n', '                if (_level == 2) l2l2users++;\n', '                if (_level == 3) l2l3users++;\n', '                if (_level == 4) l2l4users++;\n', '                if (_level == 5) l2l5users++;\n', '                if (_level == 6) l2l6users++;\n', '                if (_level == 7) l2l7users++;\n', '                if (_level == 8) l2l8users++;\n', '            } else if (_league == 3) {\n', "                require(msg.value == LEVEL_PRICE[_level + 16], 'Incorrect Value');\n", "                for (l = _level - 1; l > 0; l--) require(users[msg.sender].levelExpiredLegendary[l] >= now, 'Buy the previous level');\n", '                if (users[msg.sender].levelExpiredLegendary[_level] == 0) {\n', '                    users[msg.sender].levelExpiredLegendary[_level] = now + PERIOD_LENGTH_LEGENDARY;\n', '                } else users[msg.sender].levelExpiredLegendary[_level] += PERIOD_LENGTH_LEGENDARY;\n', '                if (_level == 1) l3l1users++;\n', '                if (_level == 2) l3l2users++;\n', '                if (_level == 3) l3l3users++;\n', '                if (_level == 4) l3l4users++;\n', '                if (_level == 5) l3l5users++;\n', '                if (_level == 6) l3l6users++;\n', '                if (_level == 7) l3l7users++;\n', '                if (_level == 8) l3l8users++;\n', '            }\n', '        }\n', '\n', '        payForLevel(_level, msg.sender, _league);\n', '        emit buyLevelEvent(msg.sender, _level, _league, now);\n', '    }\n', '\n', '\n', '   \n', '    function payForLevel(uint _level, address _user, uint _league) internal {\n', '        \n', '        address referer;\n', '        address referer1;\n', '        address referer2;\n', '        address referer3;\n', '        if(_level == 1 || _level == 5){\n', '            referer = userList[users[_user].referrerID];\n', '        } else if(_level == 2 || _level == 6){\n', '            referer1 = userList[users[_user].referrerID];\n', '            referer = userList[users[referer1].referrerID];\n', '        } else if(_level == 3 || _level == 7){\n', '            referer1 = userList[users[_user].referrerID];\n', '            referer2 = userList[users[referer1].referrerID];\n', '            referer = userList[users[referer2].referrerID];\n', '        } else if(_level == 4 || _level == 8){\n', '            referer1 = userList[users[_user].referrerID];\n', '            referer2 = userList[users[referer1].referrerID];\n', '            referer3 = userList[users[referer2].referrerID];\n', '            referer = userList[users[referer3].referrerID];\n', '        }\n', '\n', '        if (!users[referer].isExist) referer = userList[1];\n', '\n', '        bool sent = false;\n', '        bool acceptible = false;\n', '        if (_league == 1) if (users[referer].levelExpired[_level] >= now) acceptible = true;\n', '        if (_league == 2) if (users[referer].levelExpiredPro[_level] >= now) acceptible = true;\n', '        if (_league == 3) if (users[referer].levelExpiredLegendary[_level] >= now) acceptible = true;\n', '        if (acceptible) {\n', '            if (ownable.viewManager() != ownerWallet && referer == userList[1]) {\n', '                if (_league == 1) sent = ownable.viewManager().send(LEVEL_PRICE[_level]);\n', '                if (_league == 2) sent = ownable.viewManager().send(LEVEL_PRICE[_level + 8]);\n', '                if (_league == 3) sent = ownable.viewManager().send(LEVEL_PRICE[_level + 16]);\n', '            } else {\n', '                if (_league == 1) sent = address(uint160(referer)).send(LEVEL_PRICE[_level]);\n', '                if (_league == 2) sent = address(uint160(referer)).send(LEVEL_PRICE[_level + 8]);\n', '                if (_league == 3) sent = address(uint160(referer)).send(LEVEL_PRICE[_level + 16]);\n', '            }\n', '            if (sent) {\n', '                emit getMoneyForLevelEvent(referer, msg.sender, _level, _league, now);\n', '            }\n', '        }\n', '        if (!sent) {\n', '            emit lostMoneyForLevelEvent(referer, msg.sender, _level, _league, now);\n', '            payForLevel(_level, referer, _league);\n', '        }\n', '    }\n', '\n', '\n', '    function findFreeReferrer(address _user) public view returns(address) {\n', '        if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) return _user;\n', '        address[] memory referrals = new address[](2046);\n', '        referrals[0] = users[_user].referral[0]; \n', '        referrals[1] = users[_user].referral[1];\n', '\n', '        address freeReferrer;\n', '        bool noFreeReferrer = true;\n', '\n', '        for(uint i =0; i<2046;i++){\n', '            if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){\n', '                if(i<1022){\n', '                    referrals[(i+1)*2] = users[referrals[i]].referral[0];\n', '                    referrals[(i+1)*2+1] = users[referrals[i]].referral[1];\n', '                }\n', '            }else{\n', '                noFreeReferrer = false;\n', '                freeReferrer = referrals[i];\n', '                break;\n', '            }\n', '        }\n', "        require(!noFreeReferrer, 'No Free Referrer');\n", '        return freeReferrer;\n', '    }\n', '\n', '    function viewUserReferral(address _user) public view returns(address[] memory) {\n', '        return users[_user].referral;\n', '    }\n', '    function referralsCountt(address _user, uint _time) public view returns(uint) {\n', '       \n', '        uint referrals = 0;\n', '\n', '        referrals += users[_user].referral.length;\n', '\n', '        if (users[_user].referral.length > 0) {\n', '            for(uint a = 0; a < users[_user].referral.length; a++){\n', '                address tempUserA = users[_user].referral[a];\n', '                referrals += users[tempUserA].referral.length;\n', '                \n', '                if (users[tempUserA].referral.length > 0) {\n', '                    for(uint b = 0; b < users[tempUserA].referral.length; b++){\n', '                        address tempUserB = users[tempUserA].referral[b];\n', '                        referrals += users[tempUserB].referral.length;\n', '                        \n', '                        if (users[tempUserB].referral.length > 0) {\n', '                            for(uint c = 0; c < users[tempUserB].referral.length; c++){\n', '                                address tempUserC = users[tempUserB].referral[c];\n', '                                referrals += users[tempUserC].referral.length;\n', '                                if (_time < 2) {\n', '                                    referrals += referralsCountt(tempUserC, 2);\n', '                                }\n', '                            } \n', '                         }\n', '                    } \n', '                }\n', '            } \n', '        }\n', '        \n', '        return referrals;\n', '    \n', '    }\n', '     function viewUserLevel(address _user) public view returns(uint[8][]) {\n', '        uint[8][] memory data = new uint[8][](3);\n', '        for(uint i =1;i<=3;i++) for(uint j =1;j<= 8;j++) if(i==1) data[i-1][j-1] = users[_user].levelExpired[j]; else if (i==2) data[i-1][j-1] = users[_user].levelExpiredPro[j]; else if (i==3) data[i-1][j-1] = users[_user].levelExpiredLegendary[j];\n', '        return data;\n', '    }\n', '    \n', '        function liveUsersStatistics() public view returns(uint[27]) {\n', '        uint totalLeague1 = 0;\n', '        uint totalLeague2 = 0;\n', '        uint totalLeague3 = 0;\n', '\n', '        for (uint i = 0; i < 8; i++) {\n', '            totalLeague1 = l1l1users + l1l2users + l1l3users + l1l4users + l1l5users + l1l6users + l1l7users + l1l8users;\n', '            totalLeague2 = l2l1users + l2l2users + l2l3users + l2l4users + l2l5users + l2l6users + l2l7users + l2l8users;\n', '            totalLeague3 = l3l1users + l3l2users + l3l3users + l3l4users + l3l5users + l3l6users + l3l7users + l3l8users;\n', '        }\n', '\n', '        uint[27] memory data = [l1l1users, l1l2users, l1l3users, l1l4users, l1l5users, l1l6users, l1l7users, l1l8users, l2l1users, l2l2users, l2l3users, l2l4users, l2l5users, l2l6users, l2l7users, l2l8users, l3l1users, l3l2users, l3l3users, l3l4users, l3l5users, l3l6users, l3l7users, l3l8users, totalLeague1 , totalLeague2, totalLeague3];\n', '        return data;\n', '    }\n', '    \n', '    function viewUserLevelExpired(address _user, uint _level, uint _league) public view returns(uint) {\n', '        if (_league == 1) return users[_user].levelExpired[_level];\n', '        else if (_league == 2) return users[_user].levelExpiredPro[_level]; \n', '        return users[_user].levelExpiredLegendary[_level];\n', '    }\n', '\n', '    function bytesToAddress(bytes memory bys) private pure returns(address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '}']
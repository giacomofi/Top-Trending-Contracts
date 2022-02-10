['pragma solidity ^0.5.7;\n', '\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '  address public ownerWallet;\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '    ownerWallet = 0xB67d52d9BDA884d487b6eae57478E387602e522d;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner, "only for owner");\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ETHStvo is Ownable {\n', '\n', '    event regStarEvent(address indexed _user, address indexed _referrer, uint _time);\n', '    event buyStarEvent(address indexed _user, uint _star, uint _cycle, uint _time);\n', '    event prolongateStarEvent(address indexed _user, uint _star, uint _time);\n', '    event getMoneyForStarEvent(address indexed _user, address indexed _referral, uint _star, uint _cycle, uint _time);\n', '    event lostMoneyForStarEvent(address indexed _user, address indexed _referral, uint _star, uint _cycle, uint _time);\n', '    //------------------------------\n', '\n', '    mapping (uint => uint) public STAR_PRICE;\n', '    uint REFERRER_1_STAR_LIMIT = 3;\n', '    uint PERIOD_LENGTH = 3650 days;\n', '\n', '\n', '    struct UserStruct {\n', '        bool isExist;\n', '        uint id;\n', '        uint referrerID;\n', '        uint referrerIDInitial;\n', '        address[] referral;\n', '        mapping (uint => uint) starExpired;\n', '    }\n', '\n', '    mapping (address => UserStruct) public users;\n', '    mapping (uint => address) public userList;\n', '    uint public currUserID = 0;\n', '\n', '    constructor() public {\n', '\n', '        //Cycle 1\n', '        STAR_PRICE[1] = 0.05 ether;\n', '        STAR_PRICE[2] = 0.15 ether;\n', '        STAR_PRICE[3] = 0.90 ether;\n', '        STAR_PRICE[4] = 2.70 ether;\n', '        STAR_PRICE[5] = 24.75 ether;\n', '        STAR_PRICE[6] = 37.50 ether;\n', '        STAR_PRICE[7] = 72.90 ether;\n', '        STAR_PRICE[8] = 218.70 ether;\n', '\n', '        //Cycle 2\n', '        STAR_PRICE[9] = 5.50 ether;\n', '        STAR_PRICE[10] = 15.00 ether;\n', '        STAR_PRICE[11] = 90.00 ether;\n', '        STAR_PRICE[12] = 270.00 ether;\n', '        STAR_PRICE[13] = 2475.00 ether;\n', '        STAR_PRICE[14] = 3750.00 ether;\n', '        STAR_PRICE[15] = 7290.00 ether;\n', '        STAR_PRICE[16] = 21870.00 ether;\n', '\n', '        //Cycle 3\n', '        STAR_PRICE[17] = 55.0 ether;\n', '        STAR_PRICE[18] = 150.00 ether;\n', '        STAR_PRICE[19] = 900.00 ether;\n', '        STAR_PRICE[20] = 2700.00 ether;\n', '        STAR_PRICE[21] = 24750.00 ether;\n', '        STAR_PRICE[22] = 37500.00 ether;\n', '        STAR_PRICE[23] = 72900.00 ether;\n', '        STAR_PRICE[24] = 218700.00 ether;\n', '\n', '        UserStruct memory userStruct;\n', '        currUserID++;\n', '\n', '        userStruct = UserStruct({\n', '            isExist : true,\n', '            id : currUserID,\n', '            referrerID : 0,\n', '            referrerIDInitial : 0,\n', '            referral : new address[](0)\n', '        });\n', '        users[ownerWallet] = userStruct;\n', '        userList[currUserID] = ownerWallet;\n', '\n', '        users[ownerWallet].starExpired[1] = 77777777777;\n', '        users[ownerWallet].starExpired[2] = 77777777777;\n', '        users[ownerWallet].starExpired[3] = 77777777777;\n', '        users[ownerWallet].starExpired[4] = 77777777777;\n', '        users[ownerWallet].starExpired[5] = 77777777777;\n', '        users[ownerWallet].starExpired[6] = 77777777777;\n', '        users[ownerWallet].starExpired[7] = 77777777777;\n', '        users[ownerWallet].starExpired[8] = 77777777777;\n', '        users[ownerWallet].starExpired[9] = 77777777777;\n', '        users[ownerWallet].starExpired[10] = 77777777777;\n', '        users[ownerWallet].starExpired[11] = 77777777777;\n', '        users[ownerWallet].starExpired[12] = 77777777777;\n', '        users[ownerWallet].starExpired[13] = 77777777777;\n', '        users[ownerWallet].starExpired[14] = 77777777777;\n', '        users[ownerWallet].starExpired[15] = 77777777777;\n', '        users[ownerWallet].starExpired[16] = 77777777777;\n', '        users[ownerWallet].starExpired[17] = 77777777777;\n', '        users[ownerWallet].starExpired[18] = 77777777777;\n', '        users[ownerWallet].starExpired[19] = 77777777777;\n', '        users[ownerWallet].starExpired[20] = 77777777777;\n', '        users[ownerWallet].starExpired[21] = 77777777777;\n', '        users[ownerWallet].starExpired[22] = 77777777777;\n', '        users[ownerWallet].starExpired[23] = 77777777777;\n', '        users[ownerWallet].starExpired[24] = 77777777777;\n', '    }\n', '\n', '    function setOwnerWallet(address _ownerWallet) public onlyOwner {\n', '        userList[1] = _ownerWallet;\n', '      }\n', '\n', '    function () external payable {\n', '\n', '        uint star;\n', '        uint cycle;\n', '\n', '        if(msg.value == STAR_PRICE[1]){\n', '            star = 1;\n', '            cycle = 1;\n', '        }else if(msg.value == STAR_PRICE[2]){\n', '            star = 2;\n', '            cycle = 1;\n', '        }else if(msg.value == STAR_PRICE[3]){\n', '            star = 3;\n', '            cycle = 1;\n', '        }else if(msg.value == STAR_PRICE[4]){\n', '            star = 4;\n', '            cycle = 1;\n', '        }else if(msg.value == STAR_PRICE[5]){\n', '            star = 5;\n', '            cycle = 1;\n', '        }else if(msg.value == STAR_PRICE[6]){\n', '            star = 6;\n', '            cycle = 1;\n', '        }else if(msg.value == STAR_PRICE[7]){\n', '            star = 7;\n', '            cycle = 1;\n', '        }else if(msg.value == STAR_PRICE[8]){\n', '            star = 8;\n', '            cycle = 1;\n', '        }else if(msg.value == STAR_PRICE[9]){\n', '            star = 9;\n', '            cycle = 2;\n', '        }else if(msg.value == STAR_PRICE[10]){\n', '            star = 10;\n', '            cycle = 2;\n', '        }else if(msg.value == STAR_PRICE[11]){\n', '            star = 11;\n', '            cycle = 2;\n', '        }else if(msg.value == STAR_PRICE[12]){\n', '            star = 12;\n', '            cycle = 2;\n', '        }else if(msg.value == STAR_PRICE[13]){\n', '            star = 13;\n', '            cycle = 2;\n', '        }else if(msg.value == STAR_PRICE[14]){\n', '            star = 14;\n', '            cycle = 2;\n', '        }else if(msg.value == STAR_PRICE[15]){\n', '            star = 15;\n', '            cycle = 2;\n', '        }else if(msg.value == STAR_PRICE[16]){\n', '            star = 16;\n', '            cycle = 2;\n', '        }else if(msg.value == STAR_PRICE[17]){\n', '            star = 17;\n', '            cycle = 3;\n', '        }else if(msg.value == STAR_PRICE[18]){\n', '            star = 18;\n', '            cycle = 3;\n', '        }else if(msg.value == STAR_PRICE[19]){\n', '            star = 19;\n', '            cycle = 3;\n', '        }else if(msg.value == STAR_PRICE[20]){\n', '            star = 20;\n', '            cycle = 3;\n', '        }else if(msg.value == STAR_PRICE[21]){\n', '            star = 21;\n', '            cycle = 3;\n', '        }else if(msg.value == STAR_PRICE[22]){\n', '            star = 22;\n', '            cycle = 3;\n', '        }else if(msg.value == STAR_PRICE[23]){\n', '            star = 23;\n', '            cycle = 3;\n', '        }else if(msg.value == STAR_PRICE[24]){\n', '            star = 24;\n', '            cycle = 3;\n', '        }else {\n', "            revert('Incorrect Value send');\n", '        }\n', '\n', '        if(users[msg.sender].isExist){\n', '            buyStar(star, cycle);\n', '        } else if(star == 1) {\n', '            uint refId = 0;\n', '            address referrer = bytesToAddress(msg.data);\n', '\n', '            if (users[referrer].isExist){\n', '                refId = users[referrer].id;\n', '            } else {\n', "                revert('Incorrect referrer');\n", '            }\n', '\n', '            regUser(refId);\n', '        } else {\n', '            revert("Please buy first star for 0.05 ETH");\n', '        }\n', '    }\n', '\n', '    function regUser(uint _referrerID) public payable {\n', "        require(!users[msg.sender].isExist, 'User exist');\n", '\n', "        require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');\n", '\n', "        require(msg.value==STAR_PRICE[1], 'Incorrect Value');\n", '\n', '        uint _referrerIDInitial = _referrerID;\n', '\n', '        if(users[userList[_referrerID]].referral.length >= REFERRER_1_STAR_LIMIT)\n', '        {\n', '            _referrerID = users[findFreeReferrer(userList[_referrerID])].id;\n', '        }\n', '\n', '        UserStruct memory userStruct;\n', '        currUserID++;\n', '\n', '        userStruct = UserStruct({\n', '            isExist : true,\n', '            id : currUserID,\n', '            referrerID : _referrerID,\n', '            referrerIDInitial : _referrerIDInitial,\n', '            referral : new address[](0)\n', '        });\n', '\n', '        users[msg.sender] = userStruct;\n', '        userList[currUserID] = msg.sender;\n', '\n', '        users[msg.sender].starExpired[1] = now + PERIOD_LENGTH;\n', '        users[msg.sender].starExpired[2] = 0;\n', '        users[msg.sender].starExpired[3] = 0;\n', '        users[msg.sender].starExpired[4] = 0;\n', '        users[msg.sender].starExpired[5] = 0;\n', '        users[msg.sender].starExpired[6] = 0;\n', '        users[msg.sender].starExpired[7] = 0;\n', '        users[msg.sender].starExpired[8] = 0;\n', '        users[msg.sender].starExpired[9] = 0;\n', '        users[msg.sender].starExpired[10] = 0;\n', '        users[msg.sender].starExpired[11] = 0;\n', '        users[msg.sender].starExpired[12] = 0;\n', '        users[msg.sender].starExpired[13] = 0;\n', '        users[msg.sender].starExpired[14] = 0;\n', '        users[msg.sender].starExpired[15] = 0;\n', '        users[msg.sender].starExpired[16] = 0;\n', '        users[msg.sender].starExpired[17] = 0;\n', '        users[msg.sender].starExpired[18] = 0;\n', '        users[msg.sender].starExpired[19] = 0;\n', '        users[msg.sender].starExpired[20] = 0;\n', '        users[msg.sender].starExpired[21] = 0;\n', '        users[msg.sender].starExpired[22] = 0;\n', '        users[msg.sender].starExpired[23] = 0;\n', '        users[msg.sender].starExpired[24] = 0;\n', '\n', '        users[userList[_referrerID]].referral.push(msg.sender);\n', '\n', '        payForStar(1, 1, msg.sender);\n', '\n', '        emit regStarEvent(msg.sender, userList[_referrerID], now);\n', '    }\n', '\n', '    function buyStar(uint _star, uint _cycle) public payable {\n', "        require(users[msg.sender].isExist, 'User not exist');\n", '\n', "        require( _star>0 && _star<=24, 'Incorrect star');\n", "        require( _cycle>0 && _cycle<=3, 'Incorrect cycle');\n", '\n', '        if(_star == 1){\n', "            require(msg.value==STAR_PRICE[1], 'Incorrect Value');\n", '            users[msg.sender].starExpired[1] += PERIOD_LENGTH;\n', '        } else {\n', "                require(msg.value==STAR_PRICE[_star], 'Incorrect Value');\n", '\n', '            for(uint l =_star-1; l>0; l-- ){\n', "                require(users[msg.sender].starExpired[l] >= now, 'Buy the previous star');\n", '            }\n', '\n', '            if(users[msg.sender].starExpired[_star] == 0){\n', '                users[msg.sender].starExpired[_star] = now + PERIOD_LENGTH;\n', '            } else {\n', '                users[msg.sender].starExpired[_star] += PERIOD_LENGTH;\n', '            }\n', '\n', '        }\n', '        payForStar(_star, _cycle, msg.sender);\n', '        emit buyStarEvent(msg.sender, _star, _cycle, now);\n', '    }\n', '\n', '    function payForStar(uint _star, uint _cycle, address _user) internal {\n', '\n', '        address referer;\n', '        address referer1;\n', '        address referer2;\n', '        address referer3;\n', '        address refererInitial;\n', '        uint money;\n', '        if(_star == 1 || _star == 5 || _star == 9 || _star == 13 || _star == 17 || _star == 21){\n', '            referer = userList[users[_user].referrerID];\n', '        } else if(_star == 2 || _star == 6 || _star == 10 || _star == 14 || _star == 18 || _star == 22){\n', '            referer1 = userList[users[_user].referrerID];\n', '            referer = userList[users[referer1].referrerID];\n', '        } else if(_star == 3 || _star == 7 || _star == 11 || _star == 15 || _star == 19 || _star == 23){\n', '            referer1 = userList[users[_user].referrerID];\n', '            referer2 = userList[users[referer1].referrerID];\n', '            referer = userList[users[referer2].referrerID];\n', '        } else if(_star == 4 || _star == 8 || _star == 12 || _star == 16 || _star == 20 || _star == 24){\n', '            referer1 = userList[users[_user].referrerID];\n', '            referer2 = userList[users[referer1].referrerID];\n', '            referer3 = userList[users[referer2].referrerID];\n', '            referer = userList[users[referer3].referrerID];\n', '        }\n', '\n', '        if(!users[referer].isExist){\n', '            referer = userList[1];\n', '        }\n', '\n', '        refererInitial = userList[users[_user].referrerIDInitial];\n', '\n', '        if(!users[refererInitial].isExist){\n', '            refererInitial = userList[1];\n', '        }\n', '\n', '        if(users[referer].starExpired[_star] >= now ){\n', '\n', '            money = STAR_PRICE[_star];\n', '\n', '            if(_star>=3){\n', '                \n', '                if(_star==5){\n', '                    bool result;\n', '                    result = address(uint160(userList[1])).send(uint(2.25 ether));\n', '                    money = SafeMath.sub(money,uint(2.25 ether));\n', '                }\n', '\n', '                if(_star==9){\n', '                    bool result;\n', '                    result = address(uint160(userList[1])).send(uint(0.50 ether));\n', '                    money = SafeMath.sub(money,uint(0.50 ether));\n', '                }\n', '\n', '                if(_star==13){\n', '                    bool result;\n', '                    result = address(uint160(userList[1])).send(uint(225.00 ether));\n', '                    money = SafeMath.sub(money,uint(225.00 ether));\n', '                }\n', '\n', '                if(_star==17){\n', '                    bool result;\n', '                    result = address(uint160(userList[1])).send(uint(5.00 ether));\n', '                    money = SafeMath.sub(money,uint(5.00 ether));\n', '                }\n', '\n', '                if(_star==21){\n', '                    bool result;\n', '                    result = address(uint160(userList[1])).send(uint(2250.00 ether));\n', '                    money = SafeMath.sub(money,uint(2250.00 ether));\n', '                }\n', '\n', '                bool result_one;\n', '                result_one = address(uint160(referer)).send(SafeMath.div(money,2));\n', '\n', '                bool result_two;\n', '                result_two = address(uint160(refererInitial)).send(SafeMath.div(money,2));\n', '                \n', '            } else {\n', '                bool result;\n', '                result = address(uint160(referer)).send(money);\n', '            }\n', '\n', '            emit getMoneyForStarEvent(referer, msg.sender, _star, _cycle, now);\n', '\n', '        } else {\n', '            emit lostMoneyForStarEvent(referer, msg.sender, _star, _cycle, now);\n', '            payForStar(_star,_cycle,referer);\n', '        }\n', '    }\n', '\n', '    function findFreeReferrer(address _user) public view returns(address) {\n', '\n', "        require(users[_user].isExist, 'Upline does not exist');\n", '\n', '        if(users[_user].referral.length < REFERRER_1_STAR_LIMIT){\n', '            return _user;\n', '        }\n', '\n', '        address[] memory referrals = new address[](363);\n', '        referrals[0] = users[_user].referral[0]; \n', '        referrals[1] = users[_user].referral[1];\n', '        referrals[2] = users[_user].referral[2];\n', '\n', '        address freeReferrer;\n', '        bool noFreeReferrer = true;\n', '\n', '        for(uint i =0; i<363;i++){\n', '            if(users[referrals[i]].referral.length == REFERRER_1_STAR_LIMIT){\n', '                if(i<120){\n', '                    referrals[(i+1)*3] = users[referrals[i]].referral[0];\n', '                    referrals[(i+1)*3+1] = users[referrals[i]].referral[1];\n', '                    referrals[(i+1)*3+2] = users[referrals[i]].referral[2];\n', '                }\n', '            }else{\n', '                noFreeReferrer = false;\n', '                freeReferrer = referrals[i];\n', '                break;\n', '            }\n', '        }\n', "        require(!noFreeReferrer, 'No Free Referrer');\n", '        return freeReferrer;\n', '\n', '    }\n', '\n', '    function viewUserReferral(address _user) public view returns(address[] memory) {\n', '        return users[_user].referral;\n', '    }\n', '\n', '    function viewUserStarExpired(address _user, uint _star) public view returns(uint) {\n', '        return users[_user].starExpired[_star];\n', '    }\n', '    function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '}']
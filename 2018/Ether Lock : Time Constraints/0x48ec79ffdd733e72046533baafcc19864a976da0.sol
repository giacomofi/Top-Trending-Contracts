['pragma solidity ^0.4.25;\n', '\n', 'contract Richer3D {\n', '    using SafeMath for *;\n', '    \n', '    //************\n', '    //Game Setting\n', '    //************\n', '    string constant public name = "Richer3D";\n', '    string constant public symbol = "R3D";\n', '    address constant private sysAdminAddress = 0x4A3913ce9e8882b418a0Be5A43d2C319c3F0a7Bd;\n', '    address constant private sysInviterAddress = 0xC5E41EC7fa56C0656Bc6d7371a8706Eb9dfcBF61;\n', '    address constant private sysDevelopAddress = 0xCf3A25b73A493F96C15c8198319F0218aE8cAA4A;\n', '    address constant private p3dInviterAddress = 0x82Fc4514968b0c5FdDfA97ed005A01843d0E117d;\n', '    uint256 constant cycleTime = 20 minutes;\n', '    //************\n', '    //Game Data\n', '    //************\n', '    uint256 private roundNumber;\n', '    uint256 private dayNumber;\n', '    uint256 private totalPlayerNumber;\n', '    uint256 private platformBalance;\n', '    //*************\n', '    //Game DataBase\n', '    //*************\n', '    mapping(uint256=>DataModal.RoundInfo) private rInfoXrID;\n', '    mapping(address=>DataModal.PlayerInfo) private pInfoXpAdd;\n', '    mapping(address=>uint256) private pIDXpAdd;\n', '    mapping(uint256=>address) private pAddXpID;\n', '    \n', '    //*************\n', '    // P3D Data\n', '    //*************\n', '    HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);\n', '    mapping(uint256=>uint256) private p3dDividesXroundID;\n', '\n', '    //*************\n', '    //Game Events\n', '    //*************\n', '    event newPlayerJoinGameEvent(address indexed _address,uint256 indexed _amount,bool indexed _JoinWithEth,uint256 _timestamp);\n', '    event calculateTargetEvent(uint256 indexed _roundID);\n', '    \n', '    constructor() public {\n', '        dayNumber = 1;\n', '    }\n', '    \n', '    function() external payable {}\n', '    \n', '    //************\n', '    //Game payable\n', '    //************\n', '    function joinGameWithInviterID(uint256 _inviterID) public payable {\n', '        require(msg.value >= 0.01 ether,"You need to pay 0.01 eth at least");\n', '        require(now.sub(rInfoXrID[roundNumber].lastCalculateTime) < cycleTime,"Waiting for settlement");\n', '        if(pIDXpAdd[msg.sender] < 1) {\n', '            registerWithInviterID(_inviterID);\n', '        }\n', '        buyCore(pInfoXpAdd[msg.sender].inviterAddress,msg.value);\n', '        emit newPlayerJoinGameEvent(msg.sender,msg.value,true,now);\n', '    }\n', '    \n', '    //********************\n', '    // Method need Gas\n', '    //********************\n', '    function joinGameWithBalance(uint256 _amount) public payable {\n', '        require(_amount >= 0.01 ether,"You need to pay 0.01 eth at least");\n', '        require(now.sub(rInfoXrID[roundNumber].lastCalculateTime) < cycleTime,"Waiting for settlement");\n', '        uint256 balance = getUserBalance(msg.sender);\n', '        require(balance >= _amount.mul(11).div(10),"balance is not enough");\n', '        platformBalance = platformBalance.add(_amount.div(10));\n', '        buyCore(pInfoXpAdd[msg.sender].inviterAddress,_amount);\n', '        pInfoXpAdd[msg.sender].withDrawNumber = pInfoXpAdd[msg.sender].withDrawNumber.sub(_amount.mul(11).div(10));\n', '        emit newPlayerJoinGameEvent(msg.sender,_amount,false,now);\n', '    }\n', '    \n', '    function calculateTarget() public {\n', '        require(now.sub(rInfoXrID[roundNumber].lastCalculateTime) >= cycleTime,"Less than cycle Time from last operation");\n', '        //allocate p3d dividends to contract \n', '        uint256 dividends = p3dContract.myDividends(true);\n', '        if(dividends > 0) {\n', '            if(rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber > 0) {\n', '                p3dDividesXroundID[roundNumber] = p3dDividesXroundID[roundNumber].add(dividends);\n', '                p3dContract.withdraw();    \n', '            } else {\n', '                platformBalance = platformBalance.add(dividends);\n', '                p3dContract.withdraw();    \n', '            }\n', '        }\n', '        uint256 increaseBalance = getIncreaseBalance(dayNumber,roundNumber);\n', '        uint256 targetBalance = getDailyTarget(roundNumber,dayNumber);\n', '        if(increaseBalance >= targetBalance) {\n', '            //buy p3d\n', '            if(getIncreaseBalance(dayNumber,roundNumber) > 0) {\n', '                p3dContract.buy.value(getIncreaseBalance(dayNumber,roundNumber).div(100))(p3dInviterAddress);\n', '            }\n', '            //continue\n', '            dayNumber = dayNumber.add(1);\n', '            rInfoXrID[roundNumber].totalDay = dayNumber;\n', '            if(rInfoXrID[roundNumber].startTime == 0) {\n', '                rInfoXrID[roundNumber].startTime = now;\n', '                rInfoXrID[roundNumber].lastCalculateTime = now;\n', '            } else {\n', '                rInfoXrID[roundNumber].lastCalculateTime = rInfoXrID[roundNumber].startTime.add((cycleTime).mul(dayNumber.sub(1)));   \n', '            }\n', '            emit calculateTargetEvent(0);\n', '        } else {\n', '            //Game over, start new round\n', '            bool haveWinner = false;\n', '            if(dayNumber > 1) {\n', '                sendBalanceForDevelop(roundNumber);\n', '                haveWinner = true;\n', '            }\n', '            rInfoXrID[roundNumber].winnerDay = dayNumber.sub(1);\n', '            roundNumber = roundNumber.add(1);\n', '            dayNumber = 1;\n', '            if(haveWinner) {\n', '                rInfoXrID[roundNumber].bounsInitNumber = getBounsWithRoundID(roundNumber.sub(1)).div(10);\n', '            } else {\n', '                rInfoXrID[roundNumber].bounsInitNumber = getBounsWithRoundID(roundNumber.sub(1));\n', '            }\n', '            rInfoXrID[roundNumber].totalDay = 1;\n', '            rInfoXrID[roundNumber].startTime = now;\n', '            rInfoXrID[roundNumber].lastCalculateTime = now;\n', '            emit calculateTargetEvent(roundNumber);\n', '        }\n', '    }\n', '\n', '    function registerWithInviterID(uint256 _inviterID) private {\n', '        totalPlayerNumber = totalPlayerNumber.add(1);\n', '        pIDXpAdd[msg.sender] = totalPlayerNumber;\n', '        pAddXpID[totalPlayerNumber] = msg.sender;\n', '        pInfoXpAdd[msg.sender].inviterAddress = pAddXpID[_inviterID];\n', '    }\n', '    \n', '    function buyCore(address _inviterAddress,uint256 _amount) private {\n', '        //for inviter\n', '        if(_inviterAddress == 0x0 || _inviterAddress == msg.sender) {\n', '            platformBalance = platformBalance.add(_amount/10);\n', '        } else {\n', '            pInfoXpAdd[_inviterAddress].inviteEarnings = pInfoXpAdd[_inviterAddress].inviteEarnings.add(_amount/10);\n', '        }\n', '        uint256 playerIndex = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber.add(1);\n', '        if(rInfoXrID[roundNumber].numberXaddress[msg.sender] == 0) {\n', '            rInfoXrID[roundNumber].number = rInfoXrID[roundNumber].number.add(1);\n', '            rInfoXrID[roundNumber].numberXaddress[msg.sender] = rInfoXrID[roundNumber].number;\n', '            rInfoXrID[roundNumber].addressXnumber[rInfoXrID[roundNumber].number] = msg.sender;\n', '        }\n', '        rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber = playerIndex;\n', '        rInfoXrID[roundNumber].dayInfoXDay[dayNumber].addXIndex[playerIndex] = msg.sender;\n', '        rInfoXrID[roundNumber].dayInfoXDay[dayNumber].indexXAddress[msg.sender] = playerIndex;\n', '        rInfoXrID[roundNumber].dayInfoXDay[dayNumber].amountXIndex[playerIndex] = _amount;\n', '    }\n', '    \n', '    function playerWithdraw(uint256 _amount) public {\n', '        uint256 balance = getUserBalance(msg.sender);\n', '        require(balance>=_amount,"amount out of limit");\n', '        msg.sender.transfer(_amount);\n', '        pInfoXpAdd[msg.sender].withDrawNumber = pInfoXpAdd[msg.sender].withDrawNumber.add(_amount);\n', '    }\n', '    \n', '    function sendBalanceForDevelop(uint256 _roundID) private {\n', '        uint256 bouns = getBounsWithRoundID(_roundID).div(5);\n', '        sysDevelopAddress.transfer(bouns.div(2));\n', '        sysInviterAddress.transfer(bouns.div(2));\n', '    }\n', '    \n', '    //********************\n', '    // Calculate Data\n', '    //********************\n', '    function getBounsWithRoundID(uint256 _roundID) private view returns(uint256 _bouns) {\n', '        _bouns = _bouns.add(rInfoXrID[_roundID].bounsInitNumber);\n', '        for(uint256 d=1;d<=rInfoXrID[_roundID].totalDay;d++){\n', '            for(uint256 i=1;i<=rInfoXrID[_roundID].dayInfoXDay[d].playerNumber;i++) {\n', '                uint256 amount = rInfoXrID[_roundID].dayInfoXDay[d].amountXIndex[i];\n', '                _bouns = _bouns.add(amount.mul(891).div(1000));  \n', '            }\n', '            for(uint256 j=1;j<=rInfoXrID[_roundID].number;j++) {\n', '                address address2 = rInfoXrID[_roundID].addressXnumber[j];\n', '                if(d>=2) {\n', '                    _bouns = _bouns.sub(getTransformMineInDay(address2,_roundID,d.sub(1)));\n', '                } else {\n', '                    _bouns = _bouns.sub(getTransformMineInDay(address2,_roundID,d));\n', '                }\n', '            }\n', '        }\n', '        return(_bouns);\n', '    }\n', '    \n', '    function getIncreaseBalance(uint256 _dayID,uint256 _roundID) private view returns(uint256 _balance) {\n', '        for(uint256 i=1;i<=rInfoXrID[_roundID].dayInfoXDay[_dayID].playerNumber;i++) {\n', '            uint256 amount = rInfoXrID[_roundID].dayInfoXDay[_dayID].amountXIndex[i];\n', '            _balance = _balance.add(amount);   \n', '        }\n', '        _balance = _balance.mul(9).div(10);\n', '        return(_balance);\n', '    }\n', '    \n', '    function getMineInfoInDay(address _userAddress,uint256 _roundID, uint256 _dayID) private view returns(uint256 _totalMine,uint256 _myMine,uint256 _additional) {\n', '        for(uint256 i=1;i<=_dayID;i++) {\n', '            for(uint256 j=1;j<=rInfoXrID[_roundID].dayInfoXDay[i].playerNumber;j++) {\n', '                address userAddress = rInfoXrID[_roundID].dayInfoXDay[i].addXIndex[j];\n', '                uint256 amount = rInfoXrID[_roundID].dayInfoXDay[i].amountXIndex[j];\n', '                if(_totalMine == 0) {\n', '                    _totalMine = _totalMine.add(amount.mul(5));\n', '                    if(userAddress == _userAddress){\n', '                        _myMine = _myMine.add(amount.mul(5));\n', '                    }\n', '                } else {\n', '                    uint256 addPart = (amount.mul(5)/2).mul(_myMine)/_totalMine;\n', '                    _totalMine = _totalMine.add(amount.mul(15).div(2));\n', '                    if(userAddress == _userAddress){\n', '                        _myMine = _myMine.add(amount.mul(5)).add(addPart);    \n', '                    }else {\n', '                        _myMine = _myMine.add(addPart);\n', '                    }\n', '                    _additional = _additional.add(addPart);\n', '                }\n', '            }\n', '        }\n', '        return(_totalMine,_myMine,_additional);\n', '    }\n', '    \n', '    function getTransformRate(address _userAddress,uint256 _roundID,uint256 _dayID) private view returns(uint256 _rate) {\n', '        (,uint256 userMine,) = getMineInfoInDay(_userAddress,_roundID,_dayID);\n', '        if(userMine > 0) {\n', '            uint256 rate = userMine.mul(4).div(1000000000000000000).add(40);\n', '            if(rate >80)                              \n', '                return(80);\n', '            else\n', '                return(rate);        \n', '        } else {\n', '            return(40);\n', '        }\n', '    }\n', '    \n', '    function getTransformMineInDay(address _userAddress,uint256 _roundID,uint256 _dayID) private view returns(uint256 _transformedMine) {\n', '        (,uint256 userMine,) = getMineInfoInDay(_userAddress,_roundID,_dayID.sub(1));\n', '        uint256 rate = getTransformRate(_userAddress,_roundID,_dayID.sub(1));\n', '        _transformedMine = userMine.mul(rate).div(10000);\n', '        return(_transformedMine);\n', '    }\n', '    \n', '    function calculateTotalMinePay(uint256 _roundID,uint256 _dayID) private view returns(uint256 _needToPay) {\n', '        (uint256 mine,,) = getMineInfoInDay(msg.sender,_roundID,_dayID.sub(1));\n', '        _needToPay = mine.mul(8).div(1000);\n', '        return(_needToPay);\n', '    }\n', '    \n', '    function getDailyTarget(uint256 _roundID,uint256 _dayID) private view returns(uint256) {\n', '        uint256 needToPay = calculateTotalMinePay(_roundID,_dayID);\n', '        uint256 target = 0;\n', '        if (_dayID > 20) {\n', '            target = (SafeMath.pwr(((5).mul(_dayID).sub(100)),3).add(1000000)).mul(needToPay).div(1000000);\n', '            return(target);\n', '        } else {\n', '            target = ((1000000).sub(SafeMath.pwr((100).sub((5).mul(_dayID)),3))).mul(needToPay).div(1000000);\n', '            if(target == 0) target = 0.0063 ether;\n', '            return(target);            \n', '        }\n', '    }\n', '    \n', '    function getUserBalance(address _userAddress) private view returns(uint256 _balance) {\n', '        if(pIDXpAdd[_userAddress] == 0) {\n', '            return(0);\n', '        }\n', '        uint256 withDrawNumber = pInfoXpAdd[_userAddress].withDrawNumber;\n', '        uint256 totalTransformed = 0;\n', '        for(uint256 i=1;i<=roundNumber;i++) {\n', '            for(uint256 j=1;j<rInfoXrID[i].totalDay;j++) {\n', '                totalTransformed = totalTransformed.add(getTransformMineInDay(_userAddress,i,j));\n', '            }\n', '        }\n', '        uint256 inviteEarnings = pInfoXpAdd[_userAddress].inviteEarnings;\n', '        _balance = totalTransformed.add(inviteEarnings).add(getBounsEarnings(_userAddress)).add(getHoldEarnings(_userAddress)).add(getUserP3DDivEarnings(_userAddress)).sub(withDrawNumber);\n', '        return(_balance);\n', '    }\n', '    \n', '    function getBounsEarnings(address _userAddress) private view returns(uint256 _bounsEarnings) {\n', '        for(uint256 i=1;i<roundNumber;i++) {\n', '            uint256 winnerDay = rInfoXrID[i].winnerDay;\n', '            uint256 myAmountInWinnerDay=0;\n', '            uint256 totalAmountInWinnerDay=0;\n', '            if(winnerDay == 0) {\n', '                _bounsEarnings = _bounsEarnings;\n', '            } else {\n', '                for(uint256 player=1;player<=rInfoXrID[i].dayInfoXDay[winnerDay].playerNumber;player++) {\n', '                    address useraddress = rInfoXrID[i].dayInfoXDay[winnerDay].addXIndex[player];\n', '                    uint256 amount = rInfoXrID[i].dayInfoXDay[winnerDay].amountXIndex[player];\n', '                    if(useraddress == _userAddress) {\n', '                        myAmountInWinnerDay = myAmountInWinnerDay.add(amount);\n', '                    }\n', '                    totalAmountInWinnerDay = totalAmountInWinnerDay.add(amount);\n', '                }\n', '                uint256 bouns = getBounsWithRoundID(i).mul(14).div(25);\n', '                _bounsEarnings = _bounsEarnings.add(bouns.mul(myAmountInWinnerDay).div(totalAmountInWinnerDay));\n', '            }\n', '        }\n', '        return(_bounsEarnings);\n', '    }\n', '\n', '    function getHoldEarnings(address _userAddress) private view returns(uint256 _holdEarnings) {\n', '        for(uint256 i=1;i<roundNumber;i++) {\n', '            uint256 winnerDay = rInfoXrID[i].winnerDay;\n', '            if(winnerDay == 0) {\n', '                _holdEarnings = _holdEarnings;\n', '            } else {  \n', '                (uint256 totalMine,uint256 myMine,) = getMineInfoInDay(_userAddress,i,rInfoXrID[i].totalDay);\n', '                uint256 bouns = getBounsWithRoundID(i).mul(7).div(50);\n', '                _holdEarnings = _holdEarnings.add(bouns.mul(myMine).div(totalMine));    \n', '            }\n', '        }\n', '        return(_holdEarnings);\n', '    }\n', '    \n', '    function getUserP3DDivEarnings(address _userAddress) private view returns(uint256 _myP3DDivide) {\n', '        if(rInfoXrID[roundNumber].totalDay <= 1) {\n', '            return(0);\n', '        }\n', '        for(uint256 i=1;i<roundNumber;i++) {\n', '            uint256 p3dDay = rInfoXrID[i].totalDay;\n', '            uint256 myAmountInp3dDay=0;\n', '            uint256 totalAmountInP3dDay=0;\n', '            if(p3dDay == 0) {\n', '                _myP3DDivide = _myP3DDivide;\n', '            } else {\n', '                for(uint256 player=1;player<=rInfoXrID[i].dayInfoXDay[p3dDay].playerNumber;player++) {\n', '                    address useraddress = rInfoXrID[i].dayInfoXDay[p3dDay].addXIndex[player];\n', '                    uint256 amount = rInfoXrID[i].dayInfoXDay[p3dDay].amountXIndex[player];\n', '                    if(useraddress == _userAddress) {\n', '                        myAmountInp3dDay = myAmountInp3dDay.add(amount);\n', '                    }\n', '                    totalAmountInP3dDay = totalAmountInP3dDay.add(amount);\n', '                }\n', '                uint256 p3dDividesInRound = p3dDividesXroundID[i];\n', '                _myP3DDivide = _myP3DDivide.add(p3dDividesInRound.mul(myAmountInp3dDay).div(totalAmountInP3dDay));\n', '            }\n', '        }\n', '        return(_myP3DDivide);\n', '    }\n', '    \n', '    //*******************\n', '    // UI \n', '    //*******************\n', '    function getDefendPlayerList() public view returns(address[]) {\n', '        if (rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber == 0) {\n', '            address[] memory playerListEmpty = new address[](0);\n', '            return(playerListEmpty);\n', '        }        \n', '        address[] memory playerList = new address[](rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber);\n', '        for(uint256 i=0;i<rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber;i++) {\n', '            playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].addXIndex[i+1];\n', '        }\n', '        return(playerList);\n', '    }\n', '    \n', '    function getAttackPlayerList() public view returns(address[]) {\n', '        address[] memory playerList = new address[](rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber);\n', '        for(uint256 i=0;i<rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber;i++) {\n', '            playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].addXIndex[i+1];\n', '        }\n', '        return(playerList);\n', '    }\n', '    \n', '    function getCurrentFieldBalanceAndTarget() public view returns(uint256 day,uint256 bouns,uint256 todayBouns,uint256 dailyTarget) {\n', '        uint256 fieldBalance = getBounsWithRoundID(roundNumber).mul(7).div(10);\n', '        uint256 todayBalance = getIncreaseBalance(dayNumber,roundNumber) ;\n', '        dailyTarget = getDailyTarget(roundNumber,dayNumber);\n', '        return(dayNumber,fieldBalance,todayBalance,dailyTarget);\n', '    }\n', '    \n', '    function getUserIDAndInviterEarnings() public view returns(uint256 userID,uint256 inviteEarning) {\n', '        return(pIDXpAdd[msg.sender],pInfoXpAdd[msg.sender].inviteEarnings);\n', '    }\n', '    \n', '    function getCurrentRoundInfo() public view returns(uint256 _roundID,uint256 _dayNumber,uint256 _ethMineNumber,uint256 _startTime,uint256 _lastCalculateTime) {\n', '        DataModal.RoundInfo memory roundInfo = rInfoXrID[roundNumber];\n', '        (uint256 totalMine,,) = getMineInfoInDay(msg.sender,roundNumber,dayNumber);\n', '        return(roundNumber,dayNumber,totalMine,roundInfo.startTime,roundInfo.lastCalculateTime);\n', '    }\n', '    \n', '    function getUserProperty() public view returns(uint256 ethMineNumber,uint256 holdEarning,uint256 transformRate,uint256 ethBalance,uint256 ethTranslated,uint256 ethMineCouldTranslateToday,uint256 ethCouldGetToday) {\n', '        if(pIDXpAdd[msg.sender] <1) {\n', '            return(0,0,0,0,0,0,0);        \n', '        }\n', '        (,uint256 myMine,uint256 additional) = getMineInfoInDay(msg.sender,roundNumber,dayNumber);\n', '        ethMineNumber = myMine;\n', '        holdEarning = additional;\n', '        transformRate = getTransformRate(msg.sender,roundNumber,dayNumber);      \n', '        ethBalance = getUserBalance(msg.sender);\n', '        uint256 totalTransformed = 0;\n', '        for(uint256 i=1;i<rInfoXrID[roundNumber].totalDay;i++) {\n', '            totalTransformed = totalTransformed.add(getTransformMineInDay(msg.sender,roundNumber,i));\n', '        }\n', '        ethTranslated = totalTransformed;\n', '        ethCouldGetToday = getTransformMineInDay(msg.sender,roundNumber,dayNumber);\n', '        ethMineCouldTranslateToday = myMine.mul(transformRate).div(10000);\n', '        return(\n', '            ethMineNumber,\n', '            holdEarning,\n', '            transformRate,\n', '            ethBalance,\n', '            ethTranslated,\n', '            ethMineCouldTranslateToday,\n', '            ethCouldGetToday\n', '            );\n', '    }\n', '    \n', '    function getPlatformBalance() public view returns(uint256 _platformBalance) {\n', '        require(msg.sender == sysAdminAddress,"Ummmmm......Only admin could do this");\n', '        return(platformBalance);\n', '    }\n', '    \n', '    function withdrawForAdmin(address _toAddress,uint256 _amount) public {\n', '        require(msg.sender==sysAdminAddress,"You are not the admin");\n', '        require(platformBalance>=_amount,"Lack of balance");\n', '        _toAddress.transfer(_amount);\n', '        platformBalance = platformBalance.sub(_amount);\n', '    }\n', '    \n', '    function p3dWithdrawForAdmin(address _toAddress,uint256 _amount) public {\n', '        require(msg.sender==sysAdminAddress,"You are not the admin");\n', '        uint256 p3dToken = p3dContract.balanceOf(address(this));\n', '        require(_amount<=p3dToken,"You don\'t have so much P3DToken");\n', '        p3dContract.transfer(_toAddress,_amount);\n', '    }\n', '    \n', '    //************\n', '    //统计后台\n', '    //************\n', '    function getDataOfGame() public view returns(uint256 _playerNumber,uint256 _dailyIncreased,uint256 _dailyTransform,uint256 _contractBalance,uint256 _userBalanceLeft,uint256 _platformBalance,uint256 _mineBalance,uint256 _balanceOfMine) {\n', '        for(uint256 i=1;i<=totalPlayerNumber;i++) {\n', '            address userAddress = pAddXpID[i];\n', '            _userBalanceLeft = _userBalanceLeft.add(getUserBalance(userAddress));\n', '        }\n', '        return(\n', '            totalPlayerNumber,\n', '            getIncreaseBalance(dayNumber,roundNumber),\n', '            calculateTotalMinePay(roundNumber,dayNumber),\n', '            address(this).balance,\n', '            _userBalanceLeft,\n', '            platformBalance,\n', '            getBounsWithRoundID(roundNumber),\n', '            getBounsWithRoundID(roundNumber).mul(7).div(10)\n', '            );\n', '    }\n', '    \n', '    function getUserAddressList() public view returns(address[]) {\n', '        address[] memory addressList = new address[](totalPlayerNumber);\n', '        for(uint256 i=0;i<totalPlayerNumber;i++) {\n', '            addressList[i] = pAddXpID[i+1];\n', '        }\n', '        return(addressList);\n', '    }\n', '    \n', '    function getUsersInfo() public view returns(uint256[7][]){\n', '        uint256[7][] memory infoList = new uint256[7][](totalPlayerNumber);\n', '        for(uint256 i=0;i<totalPlayerNumber;i++) {\n', '            address userAddress = pAddXpID[i+1];\n', '            (,uint256 myMine,uint256 additional) = getMineInfoInDay(userAddress,roundNumber,dayNumber);\n', '            uint256 totalTransformed = 0;\n', '            for(uint256 j=1;j<=roundNumber;j++) {\n', '                for(uint256 k=1;k<=rInfoXrID[j].totalDay;k++) {\n', '                    totalTransformed = totalTransformed.add(getTransformMineInDay(userAddress,j,k));\n', '                }\n', '            }\n', '            infoList[i][0] = myMine ;\n', '            infoList[i][1] = getTransformRate(userAddress,roundNumber,dayNumber);\n', '            infoList[i][2] = additional;\n', '            infoList[i][3] = getUserBalance(userAddress);\n', '            infoList[i][4] = getUserBalance(userAddress).add(pInfoXpAdd[userAddress].withDrawNumber);\n', '            infoList[i][5] = pInfoXpAdd[userAddress].inviteEarnings;\n', '            infoList[i][6] = totalTransformed;\n', '        }        \n', '        return(infoList);\n', '    }\n', '    \n', '    function getP3DInfo() public view returns(uint256 _p3dTokenInContract,uint256 _p3dDivInRound) {\n', '        _p3dTokenInContract = p3dContract.balanceOf(address(this));\n', '        _p3dDivInRound = p3dDividesXroundID[roundNumber];\n', '        return(_p3dTokenInContract,_p3dDivInRound);\n', '    }\n', '    \n', '}\n', '\n', '//P3D Interface\n', 'interface HourglassInterface {\n', '    function buy(address _playerAddress) payable external returns(uint256);\n', '    function withdraw() external;\n', '    function myDividends(bool _includeReferralBonus) external view returns(uint256);\n', '    function balanceOf(address _customerAddress) external view returns(uint256);\n', '    function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);\n', '}\n', '\n', 'library DataModal {\n', '    struct PlayerInfo {\n', '        uint256 inviteEarnings;\n', '        address inviterAddress;\n', '        uint256 withDrawNumber;\n', '    }\n', '    \n', '    struct DayInfo {\n', '        uint256 playerNumber;\n', '        mapping(uint256=>address) addXIndex;\n', '        mapping(uint256=>uint256) amountXIndex;\n', '        mapping(address=>uint256) indexXAddress;\n', '    }\n', '    \n', '    struct RoundInfo {\n', '        uint256 startTime;\n', '        uint256 lastCalculateTime;\n', '        uint256 bounsInitNumber;\n', '        uint256 totalDay;\n', '        uint256 winnerDay;\n', '        mapping(uint256=>DayInfo) dayInfoXDay;\n', '        mapping(uint256=>address) addressXnumber;\n', '        mapping(address=>uint256) numberXaddress;\n', '        uint256 number;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) \n', '        internal \n', '        pure \n', '        returns (uint256 c) \n', '    {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b, "SafeMath mul failed");\n', '        return c;\n', '    }\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath div failed");\n', '        uint256 c = a / b;\n', '        return c;\n', '    } \n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256) \n', '    {\n', '        require(b <= a, "SafeMath sub failed");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256 c) \n', '    {\n', '        c = a + b;\n', '        require(c >= a, "SafeMath add failed");\n', '        return c;\n', '    }\n', '    \n', '    /**\n', '     * @dev gives square root of given x.\n', '     */\n', '    function sqrt(uint256 x)\n', '        internal\n', '        pure\n', '        returns (uint256 y) \n', '    {\n', '        uint256 z = ((add(x,1)) / 2);\n', '        y = x;\n', '        while (z < y) \n', '        {\n', '            y = z;\n', '            z = ((add((x / z),z)) / 2);\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * @dev gives square. multiplies x by x\n', '     */\n', '    function sq(uint256 x)\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return (mul(x,x));\n', '    }\n', '    \n', '    /**\n', '     * @dev x to the power of y \n', '     */\n', '    function pwr(uint256 x, uint256 y)\n', '        internal \n', '        pure \n', '        returns (uint256)\n', '    {\n', '        if (x==0)\n', '            return (0);\n', '        else if (y==0)\n', '            return (1);\n', '        else \n', '        {\n', '            uint256 z = x;\n', '            for (uint256 i=1; i < y; i++)\n', '                z = mul(z,x);\n', '            return (z);\n', '        }\n', '    }\n', '}']
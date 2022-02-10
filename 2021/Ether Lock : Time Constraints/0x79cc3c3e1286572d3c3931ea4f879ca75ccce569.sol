['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.0;\n', 'pragma experimental ABIEncoderV2;\n', 'import "./Ecocelium_Initializer.sol";\n', '\n', '/*\n', '\n', '███████╗░█████╗░░█████╗░░█████╗░███████╗██╗░░░░░██╗██╗░░░██╗███╗░░░███╗\n', '██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██║░░░░░██║██║░░░██║████╗░████║\n', '█████╗░░██║░░╚═╝██║░░██║██║░░╚═╝█████╗░░██║░░░░░██║██║░░░██║██╔████╔██║\n', '██╔══╝░░██║░░██╗██║░░██║██║░░██╗██╔══╝░░██║░░░░░██║██║░░░██║██║╚██╔╝██║\n', '███████╗╚█████╔╝╚█████╔╝╚█████╔╝███████╗███████╗██║╚██████╔╝██║░╚═╝░██║\n', '╚══════╝░╚════╝░░╚════╝░░╚════╝░╚══════╝╚══════╝╚═╝░╚═════╝░╚═╝░░░░░╚═╝\n', '\n', 'Brought to you by Kryptual Team */\n', '\n', 'contract ecoLockManager is Initializable {\n', '    \n', '    IAbacusOracle abacus;\n', '    EcoMoneyManager EMM;\n', '    EcoceliumInit Init;\n', '    enum Status {CLOSED, ACTIVE} \n', '\n', '    /*============Mappings=============\n', '    ----------------------------------*/\n', '    mapping (address => uint64[]) public userLock;\n', '    mapping (uint64 => string) public tokenMap;\n', '    mapping (uint64 => uint) public orderDuration;\n', '    mapping (uint64 => uint) public orderAmount;\n', '    mapping (uint64 => uint) public orderTime;\n', '    mapping (string => History[]) public tokenPriceHistory; //TimeID\n', '    mapping (string => History[]) public tokenRateHistory; //TimeID\n', '    mapping (address => uint) public rewardWithdrawls;\n', '    uint [] priceTimeList;\n', '    uint [] rateTimeList;\n', '    mapping (address => Withdrawls[]) public freeAssetsWithdrawl;\n', '    \n', '    /*=========Structs and Initializer================\n', '    --------------------------------*/    \n', '\n', '    struct History{\n', '//        uint hID;\n', '        uint value;\n', '        uint startDate;\n', '        uint endDate;\n', '    }\n', '    \n', '    struct Withdrawls {\n', '        string token;\n', '        uint amount;\n', '    }\n', '    \n', '    function initializeAddress(address payable EMMaddress,address AbacusAddress, address payable Initaddress) external initializer{\n', '            EMM = EcoMoneyManager(EMMaddress);\n', '            abacus = IAbacusOracle(AbacusAddress); \n', '            Init = EcoceliumInit(Initaddress);\n', '    }\n', '\n', '    \n', '    function easyLock(string memory rtoken ,uint _amount,uint _duration) external {\n', '    \taddress payable userAddress = msg.sender;\n', '        string memory _tokenSymbol = EMM.getWrapped(rtoken);\n', '        _deposit(rtoken, _amount, userAddress, _tokenSymbol);\n', '        (uint64 _orderId,uint newAmount,uint fee) = _ordersub(_amount, userAddress, _duration, _tokenSymbol);\n', '    \tInit.setOwnerFeeVault(rtoken, fee);\n', '        (orderTime[_orderId], orderAmount[_orderId], orderDuration[_orderId]) =  (now, _duration, newAmount);\n', '    \ttokenMap[_orderId] = _tokenSymbol;      \n', '    \tuserLock[userAddress].push(_orderId);\n', '        EMM.mintWrappedToken(userAddress, _amount, _tokenSymbol);\n', '        EMM.lockWrappedToken(userAddress, _amount,_tokenSymbol);\n', '    }\n', '\n', '    function _deposit(string memory rtoken, uint _amount, address msgSender, string memory wtoken) internal {\n', '        require(EMM.getwTokenAddress(wtoken) != address(0),"Invalid Token Address");\n', '        if(keccak256(abi.encodePacked(rtoken)) == keccak256(abi.encodePacked(Init.ETH_SYMBOL()))) { \n', '            require(msg.value >= _amount);\n', '            EMM.DepositManager{ value:msg.value }(rtoken, _amount, msgSender);\n', '        } else {\n', '        EMM.DepositManager(rtoken, _amount, msgSender); }\n', '    }\n', '\n', '    function unlockAndWithdraw(string memory rtoken, uint amount) external {\n', '    \trequire(getUserFreeAsset(msg.sender, rtoken) >= amount , "Insufficient Balance");\n', '        EMM.releaseWrappedToken(msg.sender,amount, rtoken);\n', '        EMM.burnWrappedFrom(msg.sender, amount, rtoken);\n', '        freeAssetsWithdrawl[msg.sender].push(Withdrawls({\n', '                                            amount : amount,\n', '                                            token : rtoken}));\n', '    \tEMM.WithdrawManager(rtoken, amount, msg.sender);\n', '    }\n', '    \n', '    \n', '    function withdrawEarning(uint amount) external {\n', '        require(getECOEarnings(msg.sender) >= amount , "Insufficient Balance");\n', '        rewardWithdrawls[msg.sender] += amount;\n', '        EMM.WithdrawManager(Init.ECO(), amount, msg.sender);\n', '    }\n', '    \n', '    function getECOEarnings(address userAddress) public view returns (uint earnings){\n', '        for(uint i=0; i<userLock[userAddress].length; i++) {\n', '            earnings += calculateECOEarning(tokenMap[userLock[userAddress][i]], orderTime[userLock[userAddress][i]],  orderAmount[userLock[userAddress][i]]);}\n', '        earnings -= rewardWithdrawls[userAddress];\n', '    }\n', '    \n', '    function calculateECOEarning(string memory _tokenSymbol, uint time, uint _amount) private view returns (uint reward){\n', '        (uint IDPos, uint rPos) = hIDPositionFinder(time);\n', '        uint meanECOPrice;\n', '        uint meanTokenPrice;\n', '        uint meanEarnRate;\n', '        for(uint i=IDPos ; i<priceTimeList.length ; i++) { \n', '            meanECOPrice += tokenPriceHistory[Init.WRAP_ECO_SYMBOL()][i].value * (( tokenPriceHistory[Init.WRAP_ECO_SYMBOL()][i].endDate > 0 ? tokenPriceHistory[Init.WRAP_ECO_SYMBOL()][i].endDate : now) - tokenPriceHistory[Init.WRAP_ECO_SYMBOL()][i].startDate) ; \n', '            meanTokenPrice += tokenPriceHistory[_tokenSymbol][i].value * (( tokenPriceHistory[_tokenSymbol][i].endDate > 0 ? tokenPriceHistory[_tokenSymbol][i].endDate : now) - tokenPriceHistory[_tokenSymbol][i].startDate) ; \n', '        }\n', '        meanTokenPrice = meanTokenPrice/(now-time);\n', '        meanECOPrice = meanECOPrice/(now-time);\n', '        for(uint i=rPos ; i<rateTimeList.length ; i++) { \n', '            meanEarnRate += tokenRateHistory[Init.WRAP_ECO_SYMBOL()][i].value * (( tokenRateHistory[Init.WRAP_ECO_SYMBOL()][i].endDate > 0 ? tokenRateHistory[Init.WRAP_ECO_SYMBOL()][i].endDate : now) - tokenRateHistory[Init.WRAP_ECO_SYMBOL()][i].startDate) ; \n', '        }\n', '        meanEarnRate = meanEarnRate/(now-time);\n', '        uint amount = _amount*meanTokenPrice*(10**8)/(meanECOPrice*(10**uint(wERC20(EMM.getwTokenAddress(_tokenSymbol)).decimals())));\n', '        reward += (amount * meanEarnRate * meanTokenPrice *(now-time))/(86400*3153600000);\n', '    }\n', '    \n', '    \n', '     /*==============Helpers============\n', '    ---------------------------------*/   \n', '    \n', '    function getUserLock(address userAddress, string memory token) public view returns (uint locked) {\n', '        for(uint i=0; i<userLock[userAddress].length; i++) {\n', '            if(((now-orderTime[userLock[userAddress][i]])<(orderDuration[userLock[userAddress][i]]*30 days)) && (keccak256(abi.encodePacked(token)) == keccak256(abi.encodePacked(tokenMap[userLock[userAddress][i]])))){\n', '                locked += orderAmount[userLock[userAddress][i]];\n', '            }\n', '        }\n', '    }\n', '    \n', '    function _ordersub(uint amount,address userAddress,uint _duration,string memory _tokenSymbol) internal view returns (uint64, uint, uint){\n', '        uint newAmount = amount - (amount*Init.tradeFee())/100;\n', '        uint fee = (amount*Init.tradeFee())/100;\n', '        uint64 _orderId = uint64(uint(keccak256(abi.encodePacked(userAddress,_tokenSymbol,_duration,now))));\n', '        return (_orderId,newAmount,fee);\n', '    }\n', '    \n', '    function totalDeposit(address userAddress, string memory rtoken) public view returns (uint total) {\n', '        for(uint i=0; i<userLock[userAddress].length; i++) {\n', '            if(keccak256(abi.encodePacked(rtoken)) == keccak256(abi.encodePacked(tokenMap[userLock[userAddress][i]]))){\n', '                total += orderAmount[userLock[userAddress][i]];\n', '            }\n', '        }\n', '    }\n', '\n', '    function getUserFreeAsset(address userAddress, string memory rtoken) public view returns (uint freeAssets) {\n', '        for(uint i=0; i<userLock[userAddress].length; i++) {\n', '            if(((now-orderTime[userLock[userAddress][i]])>(orderDuration[userLock[userAddress][i]]*30 days)) && (keccak256(abi.encodePacked(rtoken)) == keccak256(abi.encodePacked(tokenMap[userLock[userAddress][i]])))){\n', '                freeAssets += orderAmount[userLock[userAddress][i]];\n', '            }\n', '        }    \n', '        for(uint i=0; i<freeAssetsWithdrawl[userAddress].length; i++) {\n', '            if(keccak256(abi.encodePacked(rtoken)) == keccak256(abi.encodePacked(freeAssetsWithdrawl[userAddress][i].token))){\n', '                freeAssets -= freeAssetsWithdrawl[userAddress][i].amount;\n', '            }\n', '        }   \n', '    }\n', '\n', '    function getOrderStatus(uint64 _orderId) public view returns (bool) {\n', '    \treturn ((now-orderTime[_orderId])<(orderDuration[_orderId]*30 days)); \n', '    }\n', '\n', '    function changeRate(string memory token, uint _value) external {\n', '        require(Init.friendlyaddress(msg.sender) ,"Not Friendly Address");\n', '        rateTimeList.push(now);\n', '        tokenRateHistory[token][tokenRateHistory[token].length-1].endDate = now;\n', '        tokenRateHistory[token].push(History({value : _value, startDate: now, endDate: 0 }));\n', '    }\n', '    \n', '    function changePrice(string memory token, uint _value) external {\n', '        require(Init.friendlyaddress(msg.sender) ,"Not Friendly Address");\n', '        priceTimeList.push(now);\n', '        tokenPriceHistory[token][tokenPriceHistory[token].length-1].endDate = now;\n', '        tokenPriceHistory[token].push(History({value : _value, startDate: now, endDate: 0 }));\n', '    }\n', '    \n', '    function superRateManager(string memory token, uint _value, uint time, uint endDate) external {\n', '        require(Init.friendlyaddress(msg.sender) ,"Not Friendly Address");\n', '        rateTimeList.push(time);\n', '        tokenRateHistory[token].push(History({value : _value, startDate: time, endDate: endDate }));\n', '    }\n', '    \n', '    function superPriceManager(string memory token, uint _value, uint time, uint endDate) external {\n', '        require(Init.friendlyaddress(msg.sender) ,"Not Friendly Address");\n', '        priceTimeList.push(time);\n', '        tokenPriceHistory[token].push(History({value : _value, startDate: time, endDate: endDate }));\n', '    }\n', '    \n', '    function superUserManager(address userAddress, string memory rtoken ,uint _amount,uint _duration, uint time) external {\n', '        require(Init.friendlyaddress(msg.sender) ,"Not Friendly Address");\n', '        string memory _tokenSymbol = EMM.getWrapped(rtoken);\n', '        (uint64 _orderId,uint newAmount,uint fee) = _ordersub(_amount, userAddress, _duration, _tokenSymbol);\n', '    \tInit.setOwnerFeeVault(rtoken, fee);\n', '        (orderTime[_orderId], orderAmount[_orderId], orderDuration[_orderId]) =  (time, _duration, newAmount);\n', '    \ttokenMap[_orderId] = _tokenSymbol;      \n', '    \tuserLock[userAddress].push(_orderId);\n', '    }\n', '    \n', '    function hIDPositionFinder(uint unixTime) private view returns (uint a,uint b) {\n', '        for(uint i=0; i< (priceTimeList.length>rateTimeList.length?priceTimeList.length:rateTimeList.length); i++) {\n', '            if(priceTimeList[i] < unixTime && priceTimeList[i+1] > unixTime) a=i;\n', '            if(rateTimeList[i] < unixTime && rateTimeList[i+1] > unixTime) b=i;\n', '        }\n', '        return (0,0);\n', '    }\n', '    \n', '    receive() payable external {     }  \n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2020-10-05\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract ERC20Basic {\n', '    uint public _totalSupply;\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '    function totalSupply() public view  returns (uint){}\n', '    function balanceOf(address who) public view returns (uint){}\n', '    function transfer(address to, uint value) public {}\n', '    function transferFrom(address _from, address _to, uint _value) public{}\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {}\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract TetherToken {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '\n', '    // Forward ERC20 methods to upgraded contract if this one is deprecated\n', '    function transfer(address _to, uint _value) public {  }\n', '    // Forward ERC20 methods to upgraded contract if this one is deprecated\n', '    function transferFrom(address _from, address _to, uint _value) public  {   }\n', '    // Forward ERC20 methods to upgraded contract if this one is deprecated\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {    }\n', '\n', '}\n', '\n', 'contract PhoenixTiger {\n', '    \n', '    /*-----------Public Variables---------------\n', '    -----------------------------------*/\n', '    address public owner;\n', '    uint public totalGpv;\n', '    uint public lastuid;\n', '    /*-----------Mapping---------------\n', '    -----------------------------------*/\n', '    mapping(address => bool) public nonEcoUser;\n', '    mapping(address => User) public users;\n', '    mapping(address => bool) public userExist;\n', '    mapping(uint => uint) public totalCountryGpv;\n', '    mapping(address => uint[]) private userPackages;\n', '    mapping(address => bool) public orgpool;\n', '    mapping(address=> bool) public millpool;\n', '    mapping(address => bool) public globalpool;\n', '    mapping(address=>address[]) public userDownlink;\n', '    mapping(address => bool) public isRegistrar;\n', '    mapping(address=> uint) public userLockTime;\n', '    mapping(address =>bool) public isCountryEli;    \n', '    mapping(uint => address) public useridmap;\n', '    \n', '    uint[12] public Packs;\n', '    enum Status {CREATED, ACTIVE}\n', '    struct User {\n', '        uint userid;\n', '        uint countrycode;\n', '        uint pbalance;\n', '        uint rbalance;\n', '        uint rank;\n', '        uint gHeight;\n', '        uint gpv;\n', '        uint[2] lastBuy;   //0- time ; 1- pack;\n', '        uint[7] earnings;  // 0 - team earnings; 1 - family earnings; 2 - match earnings; 3 - country earnings, 4- organisation, 5 - global, 6 - millionaire\n', '        bool isbonus;\n', '        bool isKyc;\n', '        address teamaddress;\n', '        address familyaddress;\n', '        Status status;\n', '        uint traininglevel;\n', '        mapping(uint=>TrainingLevel) trainingpackage;\n', '    }\n', '    struct TrainingLevel {\n', '        uint package;\n', '        bool purchased;\n', '\n', '    }\n', '    function getLastBuyPack(address) public view returns(uint[2] memory ){  }\n', '    function getCountryUsersCount(uint) public view returns (uint){    }\n', '    function getTrainingLevel(address useraddress, uint pack) public view returns (uint tlevel, uint upack) {    }\n', '    function getAllPacksofUsers(address useraddress) public view returns(uint[] memory pck) {    }\n', '    function getidfromaddress(address useraddress) public view returns(uint userID){    }\n', '    function getAllLevelsofUsers(address useraddress,uint pack) public view returns(uint lvl) {    }\n', '    function isUserExists(address user) public view returns (bool) {    }\n', '    function checkPackPurchased(address useraddress, uint pack) public view returns (uint userpack, uint usertraininglevel, bool packpurchased){}\n', '}\n', 'contract IAbacusOracle{\n', '    uint public callFee;\n', '    function getJobResponse(uint64 _jobId) public view returns(uint64[] memory _values){    }\n', '    function scheduleFunc(address to ,uint callTime, bytes memory data , uint fee , uint gaslimit ,uint gasprice)public payable{}\n', '}\n', '\n', '\n', '\n', 'contract bridgeContract{\n', '    \n', '    TetherToken tether;\n', '    address payable owner;\n', '    address public master;\n', '    address private holdingAddress;\n', '    ERC20Basic Eco;\n', '    IAbacusOracle abacus; \n', '    PhoenixTiger phoenix;\n', '    uint public totalECOBalance;\n', '    uint64 public ecoFetchId;\n', '    uint64 public usdtFetchId;\n', '    uint lastweek;\n', '    mapping(address =>User) public users;\n', '    struct User{\n', '        uint trainingLevel;\n', '        uint extraPrinciple;\n', '        uint[3] earnings;  //0 - Rebate ; 1 - Reward ; 2 - Options\n', '        uint dueReward;\n', '        uint week;\n', '        bool options;\n', '        bool ecoPauser;\n', '        uint ecoBalance;\n', '    }\n', '    \n', '    event RedeemEarning (\n', '                address useraddress,\n', '                uint ecoBalance\n', '            );\n', '    \n', '    constructor(address _EcoAddress,address AbacusAddress,address PhoenixTigerAddress,address payable _owner,uint64 _fetchId,uint64 _usdtfetchid, address _holdingAddress) public{\n', '        owner = _owner;\n', '        Eco = ERC20Basic(_EcoAddress);\n', '        abacus = IAbacusOracle(AbacusAddress);\n', '        phoenix = PhoenixTiger(PhoenixTigerAddress);\n', '        ecoFetchId = _fetchId;\n', '        usdtFetchId = _usdtfetchid;\n', '        tether = TetherToken(0xdAC17F958D2ee523a2206206994597C13D831ec7);\n', '        holdingAddress = _holdingAddress;\n', '        lastweek = now;\n', '    }\n', '    \n', '    function updateOptionsBWAPI(address _useraddress, bool _status) external {\n', '        require(msg.sender==owner);\n', '        users[_useraddress].options = _status;\n', '    }\n', '    \n', '    function updatePhoenixAddress(address _phoenixAddress) external {\n', '        require(msg.sender==owner);\n', '        phoenix = PhoenixTiger(_phoenixAddress);\n', '    }\n', '    \n', '    function updateEcoFetchID(uint64 _ecoFetchID) external {\n', '        require(msg.sender==owner);\n', '        ecoFetchId = _ecoFetchID;\n', '    }\n', '    \n', '    function updateUSDTID(uint64 _usdtID) external {\n', '        require(msg.sender==owner);\n', '        usdtFetchId = _usdtID;\n', '    }\n', '    \n', '    function updatetotalECO(uint _totalECO) external {\n', '        require(msg.sender==owner);\n', '        totalECOBalance = _totalECO;\n', '    }\n', '    \n', '    function updatetrainingLevel(address  []memory _users,uint  []memory _values) public {\n', '        require(msg.sender==owner);\n', '        require(_users.length == _values.length,"check lengths");\n', '        for(uint i=0;i<_users.length;i++){\n', '            users[_users[i]].trainingLevel = _values[i];\n', '        }\n', '    }\n', '    \n', '    function buyOptions(address _useraddress, uint _amount) public {\n', '        require(phoenix.isUserExists(_useraddress), "You are not a Phoenix User");\n', '        require(tether.allowance(msg.sender, address(this)) >= _amount,"set allowance");\n', '        require(phoenix.Packs(phoenix.getLastBuyPack(_useraddress)[1]) <= _amount, "invalid amount of wholesale package purchase");\n', '        tether.transferFrom(msg.sender, holdingAddress, _amount);\n', '        users[_useraddress].options = true;\n', '    }\n', '    \n', '    function updateExtraPrinciple(address  []memory _users,uint  []memory _values) public {\n', '        require(msg.sender == owner);\n', '        require(_users.length == _values.length,"check lengths");\n', '        for(uint i=0;i<_users.length;i++){\n', '                users[_users[i]].extraPrinciple = _values[i];\n', '        }\n', '    }\n', '    \n', '    function initSOS(address[] memory _users,uint[] memory _values) public {\n', '        require(msg.sender == owner);\n', '        require(_users.length == _values.length,"check lengths");\n', '        for(uint i=0;i<_users.length;i++){\n', '                users[_users[i]].ecoBalance = _values[i];\n', '        }\n', '    }\n', '\n', '    function redeemEcoBalance(address _useraddress) public{ //called weekly\n', '        require(phoenix.isUserExists(_useraddress), "user not exists");\n', '        require(users[_useraddress].ecoBalance>0, "insufficient balance");\n', '        Eco.transfer(_useraddress, users[_useraddress].ecoBalance);\n', '        users[_useraddress].ecoBalance = 0;\n', '        totalECOBalance = totalECOBalance - users[_useraddress].ecoBalance;\n', '        \n', '        emit RedeemEarning(\n', '            _useraddress,\n', '            users[_useraddress].ecoBalance\n', '        );\n', '    }\n', '\n', '    function disburseRebate(address _useraddress) public {   //called weekly\n', '        require(msg.sender == owner);\n', '        uint reward;\n', '        if(users[_useraddress].trainingLevel > users[_useraddress].week  && getLocktime(_useraddress) >= now){\n', '            reward = ((phoenix.Packs(phoenix.getLastBuyPack(_useraddress)[1])*fetchPrice(usdtFetchId) + users[_useraddress].extraPrinciple )*25*(10**8))/1000/fetchPrice(ecoFetchId);\n', '            users[_useraddress].earnings[0] += reward;\n', '            users[_useraddress].ecoBalance += reward;\n', '            totalECOBalance += reward;\n', '            users[_useraddress].week += 1;\n', '        }\n', '    }\n', '    \n', '    function disburseReward(address _useraddress) public {  //called monthly\n', '        require(msg.sender == owner);\n', '        uint reward;   \n', '        reward = (((phoenix.Packs(phoenix.getLastBuyPack(_useraddress)[1])*fetchPrice(usdtFetchId) + users[_useraddress].extraPrinciple)*10*(10**8))/100)/fetchPrice(ecoFetchId);\n', '        users[_useraddress].dueReward += reward;\n', '        if(users[_useraddress].trainingLevel > 5 && getLocktime(_useraddress)>now){\n', '            users[_useraddress].earnings[1] += users[_useraddress].dueReward;\n', '            users[_useraddress].ecoBalance += users[_useraddress].dueReward;\n', '            totalECOBalance += users[_useraddress].dueReward;\n', '            users[_useraddress].dueReward = 0;\n', '        }\n', '    }\n', '    \n', '    function disburseOptions(address _useraddress) public {   //called monthly\n', '        require(msg.sender == owner);\n', '        uint reward;\n', '        if(users[_useraddress].options == true && getLocktime(_useraddress)>now){\n', '            reward = (((phoenix.Packs(phoenix.getLastBuyPack(_useraddress)[1])*fetchPrice(usdtFetchId) + users[_useraddress].extraPrinciple)*20*(10**8))/100)/fetchPrice(ecoFetchId);\n', '            users[_useraddress].earnings[2] += reward;\n', '            users[_useraddress].ecoBalance += reward;\n', '            totalECOBalance += reward;\n', '        }\n', '    }\n', '    \n', '    function disbursePrinciple(address _useraddress) public {   //called weekly\n', '        require(msg.sender == owner);\n', '        uint reward;\n', '        if(now>getLocktime(_useraddress)) {\n', '            reward = ((phoenix.Packs(phoenix.getLastBuyPack(_useraddress)[1])*fetchPrice(usdtFetchId) + users[_useraddress].extraPrinciple)*(10**8))/fetchPrice(ecoFetchId);\n', '            users[_useraddress].earnings[1] += reward;\n', '            users[_useraddress].ecoBalance += reward;\n', '            totalECOBalance += reward;\n', '            users[_useraddress].ecoPauser = true;\n', '        }\n', '    }\n', '    \n', '    function weektrigger() public { // called weekly from outside\n', '        require(msg.sender == owner);\n', '        for( uint i= 1000001; i < phoenix.lastuid() ; i++) {\n', '            address _address = phoenix.useridmap(i);\n', '            uint _lastbuy = phoenix.getLastBuyPack(_address)[1];\n', '            if(!users[_address].ecoPauser && _lastbuy > 0) {\n', '                if(_lastbuy > lastweek) {\n', '                    users[_address].week = 0;\n', '                }\n', '                disburseRebate(_address);\n', '                disbursePrinciple(_address);\n', '            }\n', '        }\n', '        lastweek = now;\n', '    }\n', '    \n', '    function monthTrigger() public { // called monthly from outside\n', '        require(msg.sender == owner);\n', '        for( uint i= 1000001; i < phoenix.lastuid(); i++) {\n', '            if(!users[phoenix.useridmap(i)].ecoPauser) {\n', '                disburseReward(phoenix.useridmap(i));\n', '                disburseOptions(phoenix.useridmap(i));\n', '            }\n', '        }\n', '    }\n', '    \n', '    function addEco(uint _amount) public{\n', '        require(Eco.allowance(msg.sender,address(this)) >= _amount);\n', '        Eco.transferFrom(msg.sender,address(this),_amount);\n', '    }\n', '    \n', '    function getLocktime(address _useraddress) private view returns(uint){\n', '\treturn phoenix.getLastBuyPack(_useraddress)[0] + (phoenix.userLockTime(_useraddress)*30 days);\n', '    }\n', '    \n', '    function getECODue() public view returns(uint _ecoDue) {\n', '        if(totalECOBalance > Eco.balanceOf(address(this))) {\n', '            return (totalECOBalance-Eco.balanceOf(address(this)));\n', '        }\n', '    }\n', '    \n', '    function fetchPrice(uint64 _fetchId) private view returns(uint){\n', '        return abacus.getJobResponse(_fetchId)[0];\n', '    }\n', '    \n', '    function getEarnings(address _useraddress) public view returns(uint[3] memory _earnings){\n', '        return users[_useraddress].earnings;\n', '        \n', '    }\n', '}']
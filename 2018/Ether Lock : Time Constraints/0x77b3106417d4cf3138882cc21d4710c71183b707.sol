['pragma solidity ^0.4.25;\n', '\n', 'contract Brave3d {\n', '\n', '    struct Stage {\n', '        uint8 cnt;\n', '        uint256 blocknumber;\n', '        bool isFinish;\n', '        uint8 deadIndex;\n', '        mapping(uint8 => address) playerMap;\n', '    }\n', '\n', '\n', '    HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);\n', '\n', '    address constant private  OFFICIAL = 0x97397C2129517f82031a28742247465BC75E1849;\n', '    address constant private  OFFICIAL_P3D = 0x97397C2129517f82031a28742247465BC75E1849;\n', '\n', '    uint8 constant private MAX_PLAYERS = 3;\n', '    uint256 constant private PRICE = 0.1 ether;\n', '    uint256 constant private P3D_VALUE = 0.019 ether;\n', '    uint256 constant private REFEREE_VALUE = 0.007 ether;\n', '    uint256 constant private  WIN_VALUE = 0.13 ether;\n', '\n', '    mapping(address => uint256) private _valueMap;\n', '    mapping(address => uint256) private _referredMap;\n', '    mapping(address => address) private _addressMap;\n', '    mapping(string => address)  private _nameAddressMap;\n', '    mapping(address => string)  private _addressNameMap;\n', '\n', '    mapping(uint8 => mapping(uint256 => Stage)) private _stageMap;\n', '    mapping(uint8 => uint256) private _finishMap;\n', '    mapping(uint8 => uint256) private _currentMap;\n', '\n', '    event BravePlayer(address indexed player, uint8 rate);\n', '    event BraveDeadPlayer(address indexed deadPlayer,uint256 numberOfStage,uint8 indexed deadIndex, uint8 rate);\n', '    event BraveWithdraw(address indexed player, uint256 indexed amount);\n', '    event BraveInvalidateStage(uint256 indexed stage, uint8 rate);\n', '    event BraveReferrer(address indexed referrer,address indexed referrered,uint8 indexed rate);\n', '\n', '\n', '    modifier hasEarnings()\n', '    {\n', '        require(_valueMap[msg.sender] > 0);\n', '        _;\n', '    }\n', '\n', '    modifier isExistsOfNameAddressMap(string name){\n', '        require(_nameAddressMap[name]==0);\n', '        _;\n', '    }\n', '\n', '    modifier isExistsOfAddressNameMap(){\n', '        require(bytes(_addressNameMap[msg.sender]).length<=0);\n', '        _;\n', '    }\n', '\n', '    constructor()\n', '    public\n', '    {\n', '        _stageMap[1][0] = Stage(0, 0, false, 0);\n', '        _stageMap[5][0] = Stage(0, 0, false, 0);\n', '        _stageMap[10][0] = Stage(0, 0, false, 0);\n', '\n', '        _currentMap[1] = 1;\n', '        _currentMap[5] = 1;\n', '        _currentMap[10] = 1;\n', '\n', '        _finishMap[1] = 0;\n', '        _finishMap[5] = 0;\n', '        _finishMap[10] = 0;\n', '\n', '        _nameAddressMap[""] = OFFICIAL;\n', '    }\n', '\n', '    function() external payable {}\n', '\n', '    function buyByAddress(address referee)\n', '    external\n', '    payable\n', '    {\n', '        uint8 rate = 1;\n', '        if (msg.value == PRICE) {\n', '            rate = 1;\n', '        } else if (msg.value == PRICE * 5) {\n', '            rate = 5;\n', '        } else if (msg.value == PRICE * 10) {\n', '            rate = 10;\n', '        } else {\n', '            require(false);\n', '        }\n', '\n', '        resetStage(rate);\n', '\n', '        buy(rate);\n', '\n', '        overStage(rate);\n', '\n', '        if (_addressMap[msg.sender] == 0) {\n', '            if (referee != 0x0000000000000000000000000000000000000000 && referee != msg.sender && _valueMap[referee] > 0) {\n', '                _addressMap[msg.sender] = referee;\n', '            } else {\n', '                _addressMap[msg.sender] = OFFICIAL;\n', '            }\n', '        }\n', '        \n', '         emit BraveReferrer(_addressMap[msg.sender],msg.sender,rate);\n', '    }\n', '\n', '    function setName(string name)\n', '    external\n', '    isExistsOfNameAddressMap(name)\n', '    isExistsOfAddressNameMap\n', '    {\n', '        _nameAddressMap[name] = msg.sender;\n', '        _addressNameMap[msg.sender] = name;\n', '\n', '        overStage(1);\n', '        overStage(5);\n', '        overStage(10);\n', '    }\n', '\n', '    function getName()\n', '    external\n', '    view\n', '    returns (string)\n', '    {\n', '        return _addressNameMap[msg.sender];\n', '    }\n', '\n', '\n', '    function buyByName(string name)\n', '    external\n', '    payable\n', '    {\n', '        uint8 rate = 1;\n', '        if (msg.value == PRICE) {\n', '            rate = 1;\n', '        } else if (msg.value == PRICE * 5) {\n', '            rate = 5;\n', '        } else if (msg.value == PRICE * 10) {\n', '            rate = 10;\n', '        } else {\n', '            require(false);\n', '        }\n', '\n', '        resetStage(rate);\n', '\n', '        buy(rate);\n', '\n', '        overStage(rate);\n', '\n', '        if (_addressMap[msg.sender] == 0) {\n', '\n', '            if (_nameAddressMap[name] == 0) {\n', '\n', '                _addressMap[msg.sender] = OFFICIAL;\n', '\n', '            } else {\n', '\n', '                address referee = _nameAddressMap[name];\n', '                if (referee != 0x0000000000000000000000000000000000000000 && referee != msg.sender && _valueMap[referee] > 0) {\n', '\n', '                    _addressMap[msg.sender] = referee;\n', '                } else {\n', '\n', '                    _addressMap[msg.sender] = OFFICIAL;\n', '                }\n', '            }\n', '        }\n', '        \n', '         emit BraveReferrer(_addressMap[msg.sender],msg.sender,rate);\n', '    }\n', '\n', '\n', '    function buyFromValue(uint8 rate)\n', '    external\n', '    {\n', '        require(rate == 1 || rate == 5 || rate == 10);\n', '        require(_valueMap[msg.sender] >= PRICE * rate);\n', '\n', '        resetStage(rate);\n', '\n', '        _valueMap[msg.sender] -= PRICE * rate;\n', '\n', '        buy(rate);\n', '\n', '        overStage(rate);\n', '        \n', '         emit BraveReferrer(_addressMap[msg.sender],msg.sender,rate);\n', '    }\n', '\n', '    function withdraw()\n', '    external\n', '    hasEarnings\n', '    {\n', '\n', '        uint256 amount = _valueMap[msg.sender];\n', '        _valueMap[msg.sender] = 0;\n', '\n', '        emit BraveWithdraw(msg.sender, amount);\n', '\n', '        msg.sender.transfer(amount);\n', '\n', '        overStage(1);\n', '        overStage(5);\n', '        overStage(10);\n', '    }\n', '\n', '    function forceOverStage()\n', '    external\n', '    {\n', '        overStage(1);\n', '        overStage(5);\n', '        overStage(10);\n', '    }\n', '\n', '    function myEarnings()\n', '    external\n', '    view\n', '    hasEarnings\n', '    returns (uint256)\n', '    {\n', '        return _valueMap[msg.sender];\n', '    }\n', '\n', '    function getEarnings(address adr)\n', '    external\n', '    view\n', '    returns (uint256)\n', '    {\n', '        return _valueMap[adr];\n', '    }\n', '\n', '    function myReferee()\n', '    external\n', '    view\n', '    returns (uint256)\n', '    {\n', '        return _referredMap[msg.sender];\n', '    }\n', '\n', '    function getReferee(address adr)\n', '    external\n', '    view\n', '    returns (uint256)\n', '    {\n', '        return _referredMap[adr];\n', '    }\n', '\n', '    function getRefereeAddress(address adr)\n', '    external\n', '    view\n', '    returns (address)\n', '    {\n', '        return _addressMap[adr];\n', '    }\n', '\n', '    function currentStageData(uint8 rate)\n', '    external\n', '    view\n', '    returns (uint256, uint256)\n', '    {\n', '        require(rate == 1 || rate == 5 || rate == 10);\n', '        uint256 curIndex = _currentMap[rate];\n', '        return (curIndex, _stageMap[rate][curIndex - 1].cnt);\n', '    }\n', '\n', '    function getStageData(uint8 rate, uint256 index)\n', '    external\n', '    view\n', '    returns (address, address, address, bool, uint8)\n', '    {\n', '        require(rate == 1 || rate == 5 || rate == 10);\n', '        require(_finishMap[rate] >= index - 1);\n', '\n', '        Stage storage finishStage = _stageMap[rate][index - 1];\n', '\n', '        return (finishStage.playerMap[0], finishStage.playerMap[1], finishStage.playerMap[2], finishStage.isFinish, finishStage.deadIndex);\n', '    }\n', '\n', '    function buy(uint8 rate)\n', '    private\n', '    {\n', '        Stage storage curStage = _stageMap[rate][_currentMap[rate] - 1];\n', '\n', '        assert(curStage.cnt < MAX_PLAYERS);\n', '\n', '        address player = msg.sender;\n', '\n', '        curStage.playerMap[curStage.cnt] = player;\n', '        curStage.cnt++;\n', '\n', '        emit BravePlayer(player, rate);\n', '\n', '        if (curStage.cnt == MAX_PLAYERS) {\n', '            curStage.blocknumber = block.number;\n', '        }\n', '    }\n', '\n', '    function overStage(uint8 rate)\n', '    private\n', '    {\n', '        uint256 curStageIndex = _currentMap[rate];\n', '        uint256 finishStageIndex = _finishMap[rate];\n', '\n', '        assert(curStageIndex >= finishStageIndex);\n', '\n', '        if (curStageIndex == finishStageIndex) {return;}\n', '\n', '        Stage storage finishStage = _stageMap[rate][finishStageIndex];\n', '\n', '        assert(!finishStage.isFinish);\n', '\n', '        if (finishStage.cnt < MAX_PLAYERS) {return;}\n', '\n', '        assert(finishStage.blocknumber != 0);\n', '\n', '        if (block.number - 256 <= finishStage.blocknumber) {\n', '\n', '            if (block.number == finishStage.blocknumber) {return;}\n', '\n', '            uint8 deadIndex = uint8(blockhash(finishStage.blocknumber)) % MAX_PLAYERS;\n', '            address deadPlayer = finishStage.playerMap[deadIndex];\n', '            emit BraveDeadPlayer(deadPlayer,finishStageIndex,deadIndex, rate);\n', '            finishStage.deadIndex = deadIndex;\n', '\n', '            for (uint8 i = 0; i < MAX_PLAYERS; i++) {\n', '                address player = finishStage.playerMap[i];\n', '                if (deadIndex != i) {\n', '                    _valueMap[player] += WIN_VALUE * rate;\n', '                }\n', '\n', '                address referee = _addressMap[player];\n', '                _valueMap[referee] += REFEREE_VALUE * rate;\n', '                _referredMap[referee] += REFEREE_VALUE * rate;\n', '            }\n', '\n', '\n', '            uint256 dividends = p3dContract.myDividends(true);\n', '            if (dividends > 0) {\n', '                p3dContract.withdraw();\n', '                _valueMap[deadPlayer] += dividends;\n', '            }\n', '\n', '            p3dContract.buy.value(P3D_VALUE * rate)(address(OFFICIAL_P3D));\n', '\n', '        } else {\n', '\n', '            for (uint8 j = 0; j < MAX_PLAYERS; j++) {\n', '                _valueMap[finishStage.playerMap[j]] += PRICE * rate;\n', '            }\n', '\n', '            emit BraveInvalidateStage(finishStageIndex, rate);\n', '        }\n', '\n', '        finishStage.isFinish = true;\n', '        finishStageIndex++;\n', '        _finishMap[rate] = finishStageIndex;\n', '    }\n', '\n', '    function resetStage(uint8 rate)\n', '    private\n', '    {\n', '        uint256 curStageIndex = _currentMap[rate];\n', '        if (_stageMap[rate][curStageIndex - 1].cnt == MAX_PLAYERS) {\n', '            _stageMap[rate][curStageIndex] = Stage(0, 0, false, 0);\n', '            curStageIndex++;\n', '            _currentMap[rate] = curStageIndex;\n', '        }\n', '    }\n', '}\n', '\n', 'interface HourglassInterface {\n', '    function buy(address _playerAddress) payable external returns (uint256);\n', '    function withdraw() external;\n', '    function myDividends(bool _includeReferralBonus) external view returns (uint256);\n', '}']
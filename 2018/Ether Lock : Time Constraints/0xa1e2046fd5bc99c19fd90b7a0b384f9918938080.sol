['pragma solidity ^0.4.22;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;       \n', '    }       \n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    modifier onlyNewOwner() {\n', '        require(msg.sender != address(0));\n', '        require(msg.sender == newOwner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0));\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public onlyNewOwner returns(bool) {\n', '        emit OwnershipTransferred(owner, newOwner);        \n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '\n', 'contract Whitelist is Ownable {\n', '    uint256 public count;\n', '    using SafeMath for uint256;\n', '\n', '    //mapping (uint256 => address) public whitelist;\n', '    mapping (address => bool) public whitelist;\n', '    mapping (uint256 => address) public indexlist;\n', '    mapping (address => uint256) public reverseWhitelist;\n', '\n', '\n', '    constructor() public {\n', '        count = 0;\n', '    }\n', '    \n', '    function AddWhitelist(address account) public onlyOwner returns(bool) {\n', '        require(account != address(0));\n', '        whitelist[account] = true;\n', '        if( reverseWhitelist[account] == 0 ) {\n', '            count = count.add(1);\n', '            indexlist[count] = account;\n', '            reverseWhitelist[account] = count;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function GetLengthofList() public view returns(uint256) {\n', '        return count;\n', '    }\n', '\n', '    function RemoveWhitelist(address account) public onlyOwner {\n', '        require( reverseWhitelist[account] != 0 );\n', '        whitelist[account] = false;\n', '    }\n', '\n', '    function GetWhitelist(uint256 index) public view returns(address) {\n', '        return indexlist[index];        \n', '    }\n', '    \n', '    function IsWhite(address account) public view returns(bool) {\n', '        return whitelist[account];\n', '    }\n', '}\n', '\n', '\n', 'contract Formysale is Ownable, Pausable, Whitelist {    \n', '    uint256 public weiRaised;         // 현재까지의 Ether 모금액\n', '    uint256 public personalMincap;    // 최소 모금 참여 가능 Ether\n', '    uint256 public personalMaxcap;    // 최대 모금 참여 가능 Ether\n', '    uint256 public startTime;         // 프리세일 시작시간\n', '    uint256 public endTime;           // 프리세일 종료시간\n', '    uint256 public exchangeRate;      // 1 Ether 당 SYNCO 교환비율\n', '    uint256 public remainToken;       // 판매 가능한 토큰의 수량\n', '    bool    public isFinalized;       // 종료여부\n', '\n', '    uint256 public mtStartTime;       // 교환비율 조정 시작 시간\n', '    uint256 public mtEndTime;         // 교환비율 조정 종료 시간\n', '\n', '\n', '    mapping (address => uint256) public beneficiaryFunded; //구매자 : 지불한 이더\n', '    mapping (address => uint256) public beneficiaryBought; //구매자 : 구매한 토큰\n', '\n', '    event Buy(address indexed beneficiary, uint256 payedEther, uint256 tokenAmount);\n', '\n', '    constructor(uint256 _rate) public { \n', '        startTime = 1532919600;           // 2018년 7월 30일 월요일 오후 12:00:00 KST    (2018년 7월 30일 Mon AM 3:00:00 GMT)\n', '        endTime = 1534647600;             // 2018년 8월 19일 일요일 오후 12:00:00 KST    (2018년 8월 19일 Sun AM 3:00:00 GMT)\n', '        remainToken = 6500000000 * 10 ** 18; // 6,500,000,000 개의 토큰 판매\n', '\n', '        exchangeRate = _rate;\n', '        personalMincap = (1 ether);\n', '        personalMaxcap = (1000 ether);\n', '        isFinalized = false;\n', '        weiRaised = 0x00;\n', '        mtStartTime = 28800;  //오후 5시 KST\n', '        mtEndTime = 32400;    //오후 6시 KST\n', '    }    \n', '\n', '    function buyPresale() public payable whenNotPaused {\n', '        address beneficiary = msg.sender;\n', '        uint256 toFund = msg.value;     // 유저가 보낸 이더리움 양(펀딩 할 이더)\n', '\n', '        // 현재 비율에서 구매하게 될 토큰의 수량\n', '        uint256 tokenAmount = SafeMath.mul(toFund,exchangeRate);\n', '        // check validity\n', '        require(!isFinalized);\n', '        require(validPurchase());       // 판매조건 검증(최소 이더량 && 판매시간 준수 && gas량 && 개인하드캡 초과)\n', '        require(whitelist[beneficiary]);// WhitList 등록되어야만 세일에 참여 가능\n', '        require(remainToken >= tokenAmount);// 남은 토큰이 교환해 줄 토큰의 양보다 많아야 한다.\n', '                \n', '\n', '        weiRaised = SafeMath.add(weiRaised, toFund);            //현재까지지 모금액에 펀딩금액 합산\n', '        remainToken = SafeMath.sub(remainToken, tokenAmount);   //남은 판매 수량에서 구매량만큼 차감\n', '        beneficiaryFunded[beneficiary] = SafeMath.add(beneficiaryFunded[msg.sender], toFund);\n', '        beneficiaryBought[beneficiary] = SafeMath.add(beneficiaryBought[msg.sender], tokenAmount);\n', '\n', '        emit Buy(beneficiary, toFund, tokenAmount);\n', '        \n', '    }\n', '\n', '    function validPurchase() internal view returns (bool) {\n', '        //보내준 이더양이 0.1 이상인지 그리고 전체 지불한 Ethere가 1,000을 넘어가는지 체크 \n', '        bool validValue = msg.value >= personalMincap && beneficiaryFunded[msg.sender].add(msg.value) <= personalMaxcap;\n', '\n', '        //현재 판매기간인지 체크 && 정비시간이 아닌지 체크 \n', '        bool validTime = now >= startTime && now <= endTime && !checkMaintenanceTime();\n', '\n', '        return validValue && validTime;\n', '    }\n', '\n', '    function checkMaintenanceTime() public view returns (bool){\n', '        uint256 datetime = now % (60 * 60 * 24);\n', '        return (datetime >= mtStartTime && datetime < mtEndTime);\n', '    }\n', '\n', '    function getNowTime() public view returns(uint256) {\n', '        return now;\n', '    }\n', '\n', '    // Owner only Functions\n', '    function changeStartTime( uint64 newStartTime ) public onlyOwner {\n', '        startTime = newStartTime;\n', '    }\n', '\n', '    function changeEndTime( uint64 newEndTime ) public onlyOwner {\n', '        endTime = newEndTime;\n', '    }\n', '\n', '    function changePersonalMincap( uint256 newpersonalMincap ) public onlyOwner {\n', '        personalMincap = newpersonalMincap * (1 ether);\n', '    }\n', '\n', '    function changePersonalMaxcap( uint256 newpersonalMaxcap ) public onlyOwner {\n', '        personalMaxcap = newpersonalMaxcap * (1 ether);\n', '    }\n', '\n', '    function FinishTokenSale() public onlyOwner {\n', '        require(now > endTime || remainToken == 0);\n', '        isFinalized = true;        \n', '        owner.transfer(weiRaised); //현재까지의 모금액을 Owner지갑으로 전송.\n', '    }\n', '\n', '    function changeRate(uint256 _newRate) public onlyOwner {\n', '        require(checkMaintenanceTime());\n', '        exchangeRate = _newRate; \n', '    }\n', '\n', '    function changeMaintenanceTime(uint256 _startTime, uint256 _endTime) public onlyOwner{\n', '        mtStartTime = _startTime;\n', '        mtEndTime = _endTime;\n', '    }\n', '\n', '    // Fallback Function. 구매자가 컨트랙트 주소로 그냥 이더를 쏜경우 바이프리세일 수행함\n', '    function () public payable {\n', '        buyPresale();\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.22;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;       \n', '    }       \n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    modifier onlyNewOwner() {\n', '        require(msg.sender != address(0));\n', '        require(msg.sender == newOwner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0));\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public onlyNewOwner returns(bool) {\n', '        emit OwnershipTransferred(owner, newOwner);        \n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '\n', 'contract Whitelist is Ownable {\n', '    uint256 public count;\n', '    using SafeMath for uint256;\n', '\n', '    //mapping (uint256 => address) public whitelist;\n', '    mapping (address => bool) public whitelist;\n', '    mapping (uint256 => address) public indexlist;\n', '    mapping (address => uint256) public reverseWhitelist;\n', '\n', '\n', '    constructor() public {\n', '        count = 0;\n', '    }\n', '    \n', '    function AddWhitelist(address account) public onlyOwner returns(bool) {\n', '        require(account != address(0));\n', '        whitelist[account] = true;\n', '        if( reverseWhitelist[account] == 0 ) {\n', '            count = count.add(1);\n', '            indexlist[count] = account;\n', '            reverseWhitelist[account] = count;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function GetLengthofList() public view returns(uint256) {\n', '        return count;\n', '    }\n', '\n', '    function RemoveWhitelist(address account) public onlyOwner {\n', '        require( reverseWhitelist[account] != 0 );\n', '        whitelist[account] = false;\n', '    }\n', '\n', '    function GetWhitelist(uint256 index) public view returns(address) {\n', '        return indexlist[index];        \n', '    }\n', '    \n', '    function IsWhite(address account) public view returns(bool) {\n', '        return whitelist[account];\n', '    }\n', '}\n', '\n', '\n', 'contract Formysale is Ownable, Pausable, Whitelist {    \n', '    uint256 public weiRaised;         // 현재까지의 Ether 모금액\n', '    uint256 public personalMincap;    // 최소 모금 참여 가능 Ether\n', '    uint256 public personalMaxcap;    // 최대 모금 참여 가능 Ether\n', '    uint256 public startTime;         // 프리세일 시작시간\n', '    uint256 public endTime;           // 프리세일 종료시간\n', '    uint256 public exchangeRate;      // 1 Ether 당 SYNCO 교환비율\n', '    uint256 public remainToken;       // 판매 가능한 토큰의 수량\n', '    bool    public isFinalized;       // 종료여부\n', '\n', '    uint256 public mtStartTime;       // 교환비율 조정 시작 시간\n', '    uint256 public mtEndTime;         // 교환비율 조정 종료 시간\n', '\n', '\n', '    mapping (address => uint256) public beneficiaryFunded; //구매자 : 지불한 이더\n', '    mapping (address => uint256) public beneficiaryBought; //구매자 : 구매한 토큰\n', '\n', '    event Buy(address indexed beneficiary, uint256 payedEther, uint256 tokenAmount);\n', '\n', '    constructor(uint256 _rate) public { \n', '        startTime = 1532919600;           // 2018년 7월 30일 월요일 오후 12:00:00 KST    (2018년 7월 30일 Mon AM 3:00:00 GMT)\n', '        endTime = 1534647600;             // 2018년 8월 19일 일요일 오후 12:00:00 KST    (2018년 8월 19일 Sun AM 3:00:00 GMT)\n', '        remainToken = 6500000000 * 10 ** 18; // 6,500,000,000 개의 토큰 판매\n', '\n', '        exchangeRate = _rate;\n', '        personalMincap = (1 ether);\n', '        personalMaxcap = (1000 ether);\n', '        isFinalized = false;\n', '        weiRaised = 0x00;\n', '        mtStartTime = 28800;  //오후 5시 KST\n', '        mtEndTime = 32400;    //오후 6시 KST\n', '    }    \n', '\n', '    function buyPresale() public payable whenNotPaused {\n', '        address beneficiary = msg.sender;\n', '        uint256 toFund = msg.value;     // 유저가 보낸 이더리움 양(펀딩 할 이더)\n', '\n', '        // 현재 비율에서 구매하게 될 토큰의 수량\n', '        uint256 tokenAmount = SafeMath.mul(toFund,exchangeRate);\n', '        // check validity\n', '        require(!isFinalized);\n', '        require(validPurchase());       // 판매조건 검증(최소 이더량 && 판매시간 준수 && gas량 && 개인하드캡 초과)\n', '        require(whitelist[beneficiary]);// WhitList 등록되어야만 세일에 참여 가능\n', '        require(remainToken >= tokenAmount);// 남은 토큰이 교환해 줄 토큰의 양보다 많아야 한다.\n', '                \n', '\n', '        weiRaised = SafeMath.add(weiRaised, toFund);            //현재까지지 모금액에 펀딩금액 합산\n', '        remainToken = SafeMath.sub(remainToken, tokenAmount);   //남은 판매 수량에서 구매량만큼 차감\n', '        beneficiaryFunded[beneficiary] = SafeMath.add(beneficiaryFunded[msg.sender], toFund);\n', '        beneficiaryBought[beneficiary] = SafeMath.add(beneficiaryBought[msg.sender], tokenAmount);\n', '\n', '        emit Buy(beneficiary, toFund, tokenAmount);\n', '        \n', '    }\n', '\n', '    function validPurchase() internal view returns (bool) {\n', '        //보내준 이더양이 0.1 이상인지 그리고 전체 지불한 Ethere가 1,000을 넘어가는지 체크 \n', '        bool validValue = msg.value >= personalMincap && beneficiaryFunded[msg.sender].add(msg.value) <= personalMaxcap;\n', '\n', '        //현재 판매기간인지 체크 && 정비시간이 아닌지 체크 \n', '        bool validTime = now >= startTime && now <= endTime && !checkMaintenanceTime();\n', '\n', '        return validValue && validTime;\n', '    }\n', '\n', '    function checkMaintenanceTime() public view returns (bool){\n', '        uint256 datetime = now % (60 * 60 * 24);\n', '        return (datetime >= mtStartTime && datetime < mtEndTime);\n', '    }\n', '\n', '    function getNowTime() public view returns(uint256) {\n', '        return now;\n', '    }\n', '\n', '    // Owner only Functions\n', '    function changeStartTime( uint64 newStartTime ) public onlyOwner {\n', '        startTime = newStartTime;\n', '    }\n', '\n', '    function changeEndTime( uint64 newEndTime ) public onlyOwner {\n', '        endTime = newEndTime;\n', '    }\n', '\n', '    function changePersonalMincap( uint256 newpersonalMincap ) public onlyOwner {\n', '        personalMincap = newpersonalMincap * (1 ether);\n', '    }\n', '\n', '    function changePersonalMaxcap( uint256 newpersonalMaxcap ) public onlyOwner {\n', '        personalMaxcap = newpersonalMaxcap * (1 ether);\n', '    }\n', '\n', '    function FinishTokenSale() public onlyOwner {\n', '        require(now > endTime || remainToken == 0);\n', '        isFinalized = true;        \n', '        owner.transfer(weiRaised); //현재까지의 모금액을 Owner지갑으로 전송.\n', '    }\n', '\n', '    function changeRate(uint256 _newRate) public onlyOwner {\n', '        require(checkMaintenanceTime());\n', '        exchangeRate = _newRate; \n', '    }\n', '\n', '    function changeMaintenanceTime(uint256 _startTime, uint256 _endTime) public onlyOwner{\n', '        mtStartTime = _startTime;\n', '        mtEndTime = _endTime;\n', '    }\n', '\n', '    // Fallback Function. 구매자가 컨트랙트 주소로 그냥 이더를 쏜경우 바이프리세일 수행함\n', '    function () public payable {\n', '        buyPresale();\n', '    }\n', '\n', '}']
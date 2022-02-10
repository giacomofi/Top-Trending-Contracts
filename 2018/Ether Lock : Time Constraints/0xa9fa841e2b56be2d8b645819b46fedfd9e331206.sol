['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' *  https://Smart-Pyramid.io\n', ' *\n', ' * Smart-Pyramid Contract\n', ' *  - GAIN 1.23% PER 24 HOURS (every 5900 blocks)\n', ' *  - Minimal contribution 0.01 eth\n', ' *  - Currency and payment - ETH\n', ' *  - Contribution allocation schemes:\n', ' *    -- 84% payments\n', ' *    -- 16% Marketing + Operating Expenses\n', ' *\n', ' *\n', ' * The later widthdrow - the MORE PROFIT !\n', ' * Increase of the total rate of return by 0.01% every day before the payment.\n', ' * The increase in profitability affects all previous days!\n', ' *  After the dividend is paid, the rate of return is returned to 1.23 % per day\n', ' *\n', ' *           For example: if the Deposit is 10 ETH\n', ' *                days      |   %    |   profit\n', ' *          --------------------------------------\n', ' *            1 (>24 hours) | 1.24 % | 0.124 ETH\n', ' *              10          | 1.33 % | 1.330 ETH\n', ' *              30          | 1.53 % | 4.590 ETH\n', ' *              50          | 1.73 % | 8.650 ETH\n', ' *              100         | 2.23 % | 22.30 ETH\n', ' *\n', ' *\n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment\n', ' *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don&#39;t care unless you&#39;re spending too much on GAS)\n', ' *  OR\n', ' *  2b. Send more ether to reinvest AND get your profit at the same time\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 200000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' *\n', ' *\n', ' * Investors Contest rules\n', ' *\n', ' * Investor contest lasts a whole week\n', ' * The results of the competition are confirmed every MON not earlier than 13:00 MSK (10:00 UTC)\n', ' * According to the results, will be determined 3 winners, who during the week invested the maximum amounts\n', ' * in one payment.\n', ' * If two investors invest the same amount - the highest place in the competition is occupied by the one whose operation\n', ' *  was before\n', ' *\n', ' * Prizes:\n', ' * 1st place: 2 ETH\n', ' * 2nd place: 1 ETH\n', ' * 3rd place: 0.5 ETH\n', ' *\n', ' * On the offensive (10:00 UTC) on Monday, it is necessary to initiate the summing up of the competition.\n', ' * Until the results are announced - the competition is still on.\n', ' * To sum up the results, you need to call the PayDay function\n', ' *\n', ' *\n', ' * Contract reviewed and approved by experts!\n', ' *\n', ' */\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = _a * _b;\n', '        require(c / _a == _b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b > 0);\n', '        uint256 c = _a / _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b <= _a);\n', '        uint256 c = _a - _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        uint256 c = _a + _b;\n', '        require(c >= _a);\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract InvestorsStorage {\n', '    address private owner;\n', '\n', '    mapping (address => Investor) private investors;\n', '\n', '    struct Investor {\n', '        uint deposit;\n', '        uint checkpoint;\n', '        address referrer;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function updateInfo(address _address, uint _value) external onlyOwner {\n', '        investors[_address].deposit += _value;\n', '        investors[_address].checkpoint = block.timestamp;\n', '    }\n', '\n', '    function updateCheckpoint(address _address) external onlyOwner {\n', '        investors[_address].checkpoint = block.timestamp;\n', '    }\n', '\n', '    function addReferrer(address _referral, address _referrer) external onlyOwner {\n', '        investors[_referral].referrer = _referrer;\n', '    }\n', '\n', '    function getInterest(address _address) external view returns(uint) {\n', '        if (investors[_address].deposit > 0) {\n', '            return(123 + ((block.timestamp - investors[_address].checkpoint) / 1 days));\n', '        }\n', '    }\n', '\n', '    function d(address _address) external view returns(uint) {\n', '        return investors[_address].deposit;\n', '    }\n', '\n', '    function c(address _address) external view returns(uint) {\n', '        return investors[_address].checkpoint;\n', '    }\n', '\n', '    function r(address _address) external view returns(address) {\n', '        return investors[_address].referrer;\n', '    }\n', '}\n', '\n', 'contract SmartPyramid {\n', '    using SafeMath for uint;\n', '\n', '    address admin;\n', '    uint waveStartUp;\n', '    uint nextPayDay;\n', '\n', '    mapping (uint => Leader) top;\n', '\n', '    event LogInvestment(address _addr, uint _value);\n', '    event LogIncome(address _addr, uint _value, string _type);\n', '    event LogReferralInvestment(address _referrer, address _referral, uint _value);\n', '    event LogGift(address _firstAddr, uint _firstDep, address _secondAddr, uint _secondDep, address _thirdAddr, uint _thirdDep);\n', '    event LogNewWave(uint _waveStartUp);\n', '\n', '    InvestorsStorage private x;\n', '\n', '    modifier notOnPause() {\n', '        require(waveStartUp <= block.timestamp);\n', '        _;\n', '    }\n', '\n', '    struct Leader {\n', '        address addr;\n', '        uint deposit;\n', '    }\n', '\n', '    function bytesToAddress(bytes _source) internal pure returns(address parsedReferrer) {\n', '        assembly {\n', '            parsedReferrer := mload(add(_source,0x14))\n', '        }\n', '        return parsedReferrer;\n', '    }\n', '\n', '    function addReferrer(uint _value) internal {\n', '        address _referrer = bytesToAddress(bytes(msg.data));\n', '        if (_referrer != msg.sender) {\n', '            x.addReferrer(msg.sender, _referrer);\n', '            x.r(msg.sender).transfer(_value / 20);\n', '            emit LogReferralInvestment(_referrer, msg.sender, _value);\n', '            emit LogIncome(_referrer, _value / 20, "referral");\n', '        }\n', '    }\n', '\n', '    constructor(address _admin) public {\n', '        admin = _admin;\n', '        x = new InvestorsStorage();\n', '    }\n', '\n', '    function getInfo(address _address) external view returns(uint deposit, uint amountToWithdraw) {\n', '        deposit = x.d(_address);\n', '        if (block.timestamp >= x.c(_address) + 10 minutes) {\n', '            amountToWithdraw = (x.d(_address).mul(x.getInterest(_address)).div(10000)).mul(block.timestamp.sub(x.c(_address))).div(1 days);\n', '        } else {\n', '            amountToWithdraw = 0;\n', '        }\n', '    }\n', '\n', '    function getTop() external view returns(address, uint, address, uint, address, uint) {\n', '        return(top[1].addr, top[1].deposit, top[2].addr, top[2].deposit, top[3].addr, top[3].deposit);\n', '    }\n', '\n', '    function() external payable {\n', '        if (msg.value == 0) {\n', '            withdraw();\n', '        } else {\n', '            invest();\n', '        }\n', '    }\n', '\n', '    function invest() notOnPause public payable {\n', '\n', '        admin.transfer(msg.value * 4 / 25);\n', '\n', '        if (x.d(msg.sender) > 0) {\n', '            withdraw();\n', '        }\n', '\n', '        x.updateInfo(msg.sender, msg.value);\n', '\n', '        if (msg.value > top[3].deposit) {\n', '            toTheTop();\n', '        }\n', '\n', '        if (x.r(msg.sender) != 0x0) {\n', '            x.r(msg.sender).transfer(msg.value / 20);\n', '            emit LogReferralInvestment(x.r(msg.sender), msg.sender, msg.value);\n', '            emit LogIncome(x.r(msg.sender), msg.value / 20, "referral");\n', '        } else if (msg.data.length == 20) {\n', '            addReferrer(msg.value);\n', '        }\n', '\n', '        emit LogInvestment(msg.sender, msg.value);\n', '    }\n', '\n', '\n', '    function withdraw() notOnPause public {\n', '\n', '        if (block.timestamp >= x.c(msg.sender) + 10 minutes) {\n', '            uint _payout = (x.d(msg.sender).mul(x.getInterest(msg.sender)).div(10000)).mul(block.timestamp.sub(x.c(msg.sender))).div(1 days);\n', '            x.updateCheckpoint(msg.sender);\n', '        }\n', '\n', '        if (_payout > 0) {\n', '\n', '            if (_payout > address(this).balance) {\n', '                nextWave();\n', '                return;\n', '            }\n', '\n', '            msg.sender.transfer(_payout);\n', '            emit LogIncome(msg.sender, _payout, "withdrawn");\n', '        }\n', '    }\n', '\n', '    function toTheTop() internal {\n', '        if (msg.value <= top[2].deposit) {\n', '            top[3] = Leader(msg.sender, msg.value);\n', '        } else {\n', '            if (msg.value <= top[1].deposit) {\n', '                top[3] = top[2];\n', '                top[2] = Leader(msg.sender, msg.value);\n', '            } else {\n', '                top[3] = top[2];\n', '                top[2] = top[1];\n', '                top[1] = Leader(msg.sender, msg.value);\n', '            }\n', '        }\n', '    }\n', '\n', '    function payDay() external {\n', '        require(block.timestamp >= nextPayDay);\n', '        nextPayDay = block.timestamp.sub((block.timestamp - 1538388000).mod(7 days)).add(7 days);\n', '\n', '        emit LogGift(top[1].addr, top[1].deposit, top[2].addr, top[2].deposit, top[3].addr, top[3].deposit);\n', '\n', '        for (uint i = 0; i <= 2; i++) {\n', '            if (top[i+1].addr != 0x0) {\n', '                top[i+1].addr.transfer(2 ether / 2 ** i);\n', '                top[i+1] = Leader(0x0, 0);\n', '            }\n', '        }\n', '    }\n', '\n', '    function nextWave() private {\n', '        for (uint i = 0; i <= 2; i++) {\n', '            top[i+1] = Leader(0x0, 0);\n', '        }\n', '        x = new InvestorsStorage();\n', '        waveStartUp = block.timestamp + 7 days;\n', '        emit LogNewWave(waveStartUp);\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' *  https://Smart-Pyramid.io\n', ' *\n', ' * Smart-Pyramid Contract\n', ' *  - GAIN 1.23% PER 24 HOURS (every 5900 blocks)\n', ' *  - Minimal contribution 0.01 eth\n', ' *  - Currency and payment - ETH\n', ' *  - Contribution allocation schemes:\n', ' *    -- 84% payments\n', ' *    -- 16% Marketing + Operating Expenses\n', ' *\n', ' *\n', ' * The later widthdrow - the MORE PROFIT !\n', ' * Increase of the total rate of return by 0.01% every day before the payment.\n', ' * The increase in profitability affects all previous days!\n', ' *  After the dividend is paid, the rate of return is returned to 1.23 % per day\n', ' *\n', ' *           For example: if the Deposit is 10 ETH\n', ' *                days      |   %    |   profit\n', ' *          --------------------------------------\n', ' *            1 (>24 hours) | 1.24 % | 0.124 ETH\n', ' *              10          | 1.33 % | 1.330 ETH\n', ' *              30          | 1.53 % | 4.590 ETH\n', ' *              50          | 1.73 % | 8.650 ETH\n', ' *              100         | 2.23 % | 22.30 ETH\n', ' *\n', ' *\n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment\n', " *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)\n", ' *  OR\n', ' *  2b. Send more ether to reinvest AND get your profit at the same time\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 200000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' *\n', ' *\n', ' * Investors Contest rules\n', ' *\n', ' * Investor contest lasts a whole week\n', ' * The results of the competition are confirmed every MON not earlier than 13:00 MSK (10:00 UTC)\n', ' * According to the results, will be determined 3 winners, who during the week invested the maximum amounts\n', ' * in one payment.\n', ' * If two investors invest the same amount - the highest place in the competition is occupied by the one whose operation\n', ' *  was before\n', ' *\n', ' * Prizes:\n', ' * 1st place: 2 ETH\n', ' * 2nd place: 1 ETH\n', ' * 3rd place: 0.5 ETH\n', ' *\n', ' * On the offensive (10:00 UTC) on Monday, it is necessary to initiate the summing up of the competition.\n', ' * Until the results are announced - the competition is still on.\n', ' * To sum up the results, you need to call the PayDay function\n', ' *\n', ' *\n', ' * Contract reviewed and approved by experts!\n', ' *\n', ' */\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = _a * _b;\n', '        require(c / _a == _b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b > 0);\n', '        uint256 c = _a / _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b <= _a);\n', '        uint256 c = _a - _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        uint256 c = _a + _b;\n', '        require(c >= _a);\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract InvestorsStorage {\n', '    address private owner;\n', '\n', '    mapping (address => Investor) private investors;\n', '\n', '    struct Investor {\n', '        uint deposit;\n', '        uint checkpoint;\n', '        address referrer;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function updateInfo(address _address, uint _value) external onlyOwner {\n', '        investors[_address].deposit += _value;\n', '        investors[_address].checkpoint = block.timestamp;\n', '    }\n', '\n', '    function updateCheckpoint(address _address) external onlyOwner {\n', '        investors[_address].checkpoint = block.timestamp;\n', '    }\n', '\n', '    function addReferrer(address _referral, address _referrer) external onlyOwner {\n', '        investors[_referral].referrer = _referrer;\n', '    }\n', '\n', '    function getInterest(address _address) external view returns(uint) {\n', '        if (investors[_address].deposit > 0) {\n', '            return(123 + ((block.timestamp - investors[_address].checkpoint) / 1 days));\n', '        }\n', '    }\n', '\n', '    function d(address _address) external view returns(uint) {\n', '        return investors[_address].deposit;\n', '    }\n', '\n', '    function c(address _address) external view returns(uint) {\n', '        return investors[_address].checkpoint;\n', '    }\n', '\n', '    function r(address _address) external view returns(address) {\n', '        return investors[_address].referrer;\n', '    }\n', '}\n', '\n', 'contract SmartPyramid {\n', '    using SafeMath for uint;\n', '\n', '    address admin;\n', '    uint waveStartUp;\n', '    uint nextPayDay;\n', '\n', '    mapping (uint => Leader) top;\n', '\n', '    event LogInvestment(address _addr, uint _value);\n', '    event LogIncome(address _addr, uint _value, string _type);\n', '    event LogReferralInvestment(address _referrer, address _referral, uint _value);\n', '    event LogGift(address _firstAddr, uint _firstDep, address _secondAddr, uint _secondDep, address _thirdAddr, uint _thirdDep);\n', '    event LogNewWave(uint _waveStartUp);\n', '\n', '    InvestorsStorage private x;\n', '\n', '    modifier notOnPause() {\n', '        require(waveStartUp <= block.timestamp);\n', '        _;\n', '    }\n', '\n', '    struct Leader {\n', '        address addr;\n', '        uint deposit;\n', '    }\n', '\n', '    function bytesToAddress(bytes _source) internal pure returns(address parsedReferrer) {\n', '        assembly {\n', '            parsedReferrer := mload(add(_source,0x14))\n', '        }\n', '        return parsedReferrer;\n', '    }\n', '\n', '    function addReferrer(uint _value) internal {\n', '        address _referrer = bytesToAddress(bytes(msg.data));\n', '        if (_referrer != msg.sender) {\n', '            x.addReferrer(msg.sender, _referrer);\n', '            x.r(msg.sender).transfer(_value / 20);\n', '            emit LogReferralInvestment(_referrer, msg.sender, _value);\n', '            emit LogIncome(_referrer, _value / 20, "referral");\n', '        }\n', '    }\n', '\n', '    constructor(address _admin) public {\n', '        admin = _admin;\n', '        x = new InvestorsStorage();\n', '    }\n', '\n', '    function getInfo(address _address) external view returns(uint deposit, uint amountToWithdraw) {\n', '        deposit = x.d(_address);\n', '        if (block.timestamp >= x.c(_address) + 10 minutes) {\n', '            amountToWithdraw = (x.d(_address).mul(x.getInterest(_address)).div(10000)).mul(block.timestamp.sub(x.c(_address))).div(1 days);\n', '        } else {\n', '            amountToWithdraw = 0;\n', '        }\n', '    }\n', '\n', '    function getTop() external view returns(address, uint, address, uint, address, uint) {\n', '        return(top[1].addr, top[1].deposit, top[2].addr, top[2].deposit, top[3].addr, top[3].deposit);\n', '    }\n', '\n', '    function() external payable {\n', '        if (msg.value == 0) {\n', '            withdraw();\n', '        } else {\n', '            invest();\n', '        }\n', '    }\n', '\n', '    function invest() notOnPause public payable {\n', '\n', '        admin.transfer(msg.value * 4 / 25);\n', '\n', '        if (x.d(msg.sender) > 0) {\n', '            withdraw();\n', '        }\n', '\n', '        x.updateInfo(msg.sender, msg.value);\n', '\n', '        if (msg.value > top[3].deposit) {\n', '            toTheTop();\n', '        }\n', '\n', '        if (x.r(msg.sender) != 0x0) {\n', '            x.r(msg.sender).transfer(msg.value / 20);\n', '            emit LogReferralInvestment(x.r(msg.sender), msg.sender, msg.value);\n', '            emit LogIncome(x.r(msg.sender), msg.value / 20, "referral");\n', '        } else if (msg.data.length == 20) {\n', '            addReferrer(msg.value);\n', '        }\n', '\n', '        emit LogInvestment(msg.sender, msg.value);\n', '    }\n', '\n', '\n', '    function withdraw() notOnPause public {\n', '\n', '        if (block.timestamp >= x.c(msg.sender) + 10 minutes) {\n', '            uint _payout = (x.d(msg.sender).mul(x.getInterest(msg.sender)).div(10000)).mul(block.timestamp.sub(x.c(msg.sender))).div(1 days);\n', '            x.updateCheckpoint(msg.sender);\n', '        }\n', '\n', '        if (_payout > 0) {\n', '\n', '            if (_payout > address(this).balance) {\n', '                nextWave();\n', '                return;\n', '            }\n', '\n', '            msg.sender.transfer(_payout);\n', '            emit LogIncome(msg.sender, _payout, "withdrawn");\n', '        }\n', '    }\n', '\n', '    function toTheTop() internal {\n', '        if (msg.value <= top[2].deposit) {\n', '            top[3] = Leader(msg.sender, msg.value);\n', '        } else {\n', '            if (msg.value <= top[1].deposit) {\n', '                top[3] = top[2];\n', '                top[2] = Leader(msg.sender, msg.value);\n', '            } else {\n', '                top[3] = top[2];\n', '                top[2] = top[1];\n', '                top[1] = Leader(msg.sender, msg.value);\n', '            }\n', '        }\n', '    }\n', '\n', '    function payDay() external {\n', '        require(block.timestamp >= nextPayDay);\n', '        nextPayDay = block.timestamp.sub((block.timestamp - 1538388000).mod(7 days)).add(7 days);\n', '\n', '        emit LogGift(top[1].addr, top[1].deposit, top[2].addr, top[2].deposit, top[3].addr, top[3].deposit);\n', '\n', '        for (uint i = 0; i <= 2; i++) {\n', '            if (top[i+1].addr != 0x0) {\n', '                top[i+1].addr.transfer(2 ether / 2 ** i);\n', '                top[i+1] = Leader(0x0, 0);\n', '            }\n', '        }\n', '    }\n', '\n', '    function nextWave() private {\n', '        for (uint i = 0; i <= 2; i++) {\n', '            top[i+1] = Leader(0x0, 0);\n', '        }\n', '        x = new InvestorsStorage();\n', '        waveStartUp = block.timestamp + 7 days;\n', '        emit LogNewWave(waveStartUp);\n', '    }\n', '}']

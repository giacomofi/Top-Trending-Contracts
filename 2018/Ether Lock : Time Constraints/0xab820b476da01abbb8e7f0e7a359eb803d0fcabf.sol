['/*\n', ' * SuperFOMO - зарабатывай до 11,5% в сутки!\n', ' *\n', ' * Мин. размер депозита 0.05 eth\n', ' * Мин. размер депозита для участия в розыгрыше джек-пота: 1eth\n', ' *\n', ' * Схема распределения входящих средств:\n', ' * 100% на выплаты участникам\n', ' *\n', ' * ИНВЕСТИЦИОННЫЙ ПЛАН:\n', ' * чем позже зашел - тем больше заработал!\n', ' *\n', ' * Каждый депозит работает отдельно до своего удвоения\n', ' *\n', ' * Депозиты сделанные в период с 1 по 12 день жизни контракта: 2,5% в день\n', ' * Депозиты сделанные в период с 12 по 18 день жизни контракта: 3,5% в день\n', ' * Депозиты сделанные в период с 18 по 24 день жизни контракта: 4,5% в день\n', ' * Депозиты сделанные в период с 24 по 30 день жизни контракта: 5,5% в день\n', ' * Депозиты сделанные в период с 30 по 36 день жизни контракта: 6,5% в день\n', ' * Депозиты сделанные в период с 36 по 42 день жизни контракта: 7,5% в день\n', ' * Депозиты сделанные в период с 42 по 48 день жизни контракта: 8,5% в день\n', ' * Депозиты сделанные в период с 48 по 54 день жизни контракта: 9,5% в день\n', ' * Депозиты сделанные в период с 54 дня жизни контракта: 10% в день\n', ' *\n', ' * БОНУС ХОЛДЕРАМ:\n', ' * Тем, кто не заказывает вывод процентов в течение 48 часов включается бонус на все депозиты +1,5% в сутки каждый день.\n', ' *\n', ' * ДЖЕК-ПОТ:\n', ' * С каждого депозита 3% "замораживается" на балансе контракта в фонд джек-пота.\n', ' *\n', ' * Условия розыгрыша:\n', ' * При отсутствии новых депозитов (от 1 eth и более) более 24 часов фонд джек-пота распределяется между последними 5 вкладчиками с депозитом 1 eth и более.\n', ' * 60% джек-пота начисляются для вывода последнему вкладчику и по 10% еще 4м вкладчикам с депозитами от  1 eth и более.\n', ' * После розыгрыша джек-пот начинает накапливаться заново.\n', ' *\n', ' * Партнерская программа:\n', ' * Для участия в партнерской программе у вас должен быть свой депозит, по которому вы получаете начисления.\n', ' * Для получения вознаграждения ваш приглашенный должен указать адрес вашего кошелька eth в поле data.\n', ' *\n', ' * Бонус приглашенному: вносимый депозит увечивается на 2%\n', ' * Бонус пригласителю: автоматически выплачивается 5% от суммы пополнения\n', ' *\n', ' * ИНСТРУКЦИЯ:\n', ' * *  1. Отправить eth (больше 0.05) для создания депозита.\n', ' * *  2. Для получения выплаты по всем депозитам необходимо отправить от 0 до 0,05 eth на адрес смарт контракта, счетчик холда при это сбрасывается.\n', ' * *  3. Если отправлено 0,05 или более eth создается новый депозит, но начисленные проценты не выплачиваются и счетчик холда не сбрасывается. С каждой выплаты 12% отправляется на рекламу и 3% на тех. поддержку проекта.\n', ' *\n', ' */\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'pragma solidity 0.4.25;\n', '\n', '\n', 'library SafeMath {\n', '\n', '\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = _a * _b;\n', '        require(c / _a == _b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b > 0);\n', '        uint256 c = _a / _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b <= _a);\n', '        uint256 c = _a - _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        uint256 c = _a + _b;\n', '        require(c >= _a);\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Storage {\n', '\n', '    address private owner;\n', '\n', '    mapping (address => Investor) investors;\n', '\n', '    struct Investor {\n', '        uint index;\n', '        mapping (uint => uint) deposit;\n', '        mapping (uint => uint) interest;\n', '        mapping (uint => uint) withdrawals;\n', '        mapping (uint => uint) start;\n', '        uint checkpoint;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function updateInfo(address _address, uint _value, uint _interest) external onlyOwner {\n', '        investors[_address].deposit[investors[_address].index] += _value;\n', '        investors[_address].start[investors[_address].index] = block.timestamp;\n', '        investors[_address].interest[investors[_address].index] = _interest;\n', '    }\n', '\n', '    function updateCheckpoint(address _address) external onlyOwner {\n', '        investors[_address].checkpoint = block.timestamp;\n', '    }\n', '\n', '    function updateWithdrawals(address _address, uint _index, uint _withdrawal) external onlyOwner {\n', '        investors[_address].withdrawals[_index] += _withdrawal;\n', '    }\n', '\n', '    function updateIndex(address _address) external onlyOwner {\n', '        investors[_address].index += 1;\n', '    }\n', '\n', '    function ind(address _address) external view returns(uint) {\n', '        return investors[_address].index;\n', '    }\n', '\n', '    function d(address _address, uint _index) external view returns(uint) {\n', '        return investors[_address].deposit[_index];\n', '    }\n', '\n', '    function i(address _address, uint _index) external view returns(uint) {\n', '        return investors[_address].interest[_index];\n', '    }\n', '\n', '    function w(address _address, uint _index) external view returns(uint) {\n', '        return investors[_address].withdrawals[_index];\n', '    }\n', '\n', '    function s(address _address, uint _index) external view returns(uint) {\n', '        return investors[_address].start[_index];\n', '    }\n', '\n', '    function c(address _address) external view returns(uint) {\n', '        return investors[_address].checkpoint;\n', '    }\n', '}\n', '\n', 'contract SuperFOMO {\n', '    using SafeMath for uint;\n', '\n', '    address public owner;\n', '    address advertising;\n', '    address techsupport;\n', '\n', '    uint waveStartUp;\n', '    uint jackPot;\n', '    uint lastLeader;\n', '\n', '    address[] top;\n', '\n', '    Storage x;\n', '\n', '    event LogInvestment(address indexed _addr, uint _value);\n', '    event LogPayment(address indexed _addr, uint _value);\n', '    event LogReferralInvestment(address indexed _referrer, address indexed _referral, uint _value);\n', '    event LogGift(address _firstAddr, address _secondAddr, address _thirdAddr, address _fourthAddr, address _fifthAddr);\n', '    event LogNewWave(uint _waveStartUp);\n', '    event LogNewLeader(address _leader);\n', '\n', '    modifier notOnPause() {\n', '        require(waveStartUp <= block.timestamp);\n', '        _;\n', '    }\n', '\n', '    modifier notFromContract() {\n', '        address addr = msg.sender;\n', '        uint size;\n', '        assembly { size := extcodesize(addr) }\n', '        require(size <= 0);\n', '        _;\n', '    }\n', '\n', '    constructor(address _advertising, address _techsupport) public {\n', '        owner = msg.sender;\n', '        advertising = _advertising;\n', '        techsupport = _techsupport;\n', '        waveStartUp = block.timestamp;\n', '        x = new Storage();\n', '    }\n', '\n', '    function renounceOwnership() external {\n', '        require(msg.sender == owner);\n', '        owner = 0x0;\n', '    }\n', '\n', '    function bytesToAddress(bytes _source) internal pure returns(address parsedreferrer) {\n', '        assembly {\n', '            parsedreferrer := mload(add(_source,0x14))\n', '        }\n', '        return parsedreferrer;\n', '    }\n', '\n', '    function setRef() internal returns(uint) {\n', '        address _referrer = bytesToAddress(bytes(msg.data));\n', '        if (_referrer != msg.sender && getDividends(_referrer) > 0) {\n', '            _referrer.transfer(msg.value / 20);\n', '\n', '            emit LogReferralInvestment(_referrer, msg.sender, msg.value);\n', '            return(msg.value / 50);\n', '        } else {\n', '            advertising.transfer(msg.value / 20);\n', '            return(0);\n', '        }\n', '    }\n', '\n', '    function getInterest() public view returns(uint) {\n', '        uint multiplier = (block.timestamp.sub(waveStartUp)) / 6 days;\n', '        if (multiplier == 0) {\n', '            return 25;\n', '        }\n', '        if (multiplier <= 8){\n', '            return(15 + (multiplier * 10));\n', '        } else {\n', '            return 100;\n', '        }\n', '    }\n', '\n', '    function toTheTop() internal {\n', '        top.push(msg.sender);\n', '        lastLeader = block.timestamp;\n', '\n', '        emit LogNewLeader(msg.sender);\n', '    }\n', '\n', '    function payDay() internal {\n', '        top[top.length - 1].transfer(jackPot * 3 / 5);\n', '        top[top.length - 2].transfer(jackPot / 10);\n', '        top[top.length - 3].transfer(jackPot / 10);\n', '        top[top.length - 4].transfer(jackPot / 10);\n', '        top[top.length - 5].transfer(jackPot / 10);\n', '        jackPot = 0;\n', '        lastLeader = block.timestamp;\n', '        emit LogGift(top[top.length - 1], top[top.length - 2], top[top.length - 3], top[top.length - 4], top[top.length - 5]);\n', '    }\n', '\n', '    function() external payable {\n', '        if (msg.value < 50000000000000000) {\n', '            msg.sender.transfer(msg.value);\n', '            withdraw();\n', '        } else {\n', '            invest();\n', '        }\n', '    }\n', '\n', '    function invest() public payable notOnPause notFromContract {\n', '\n', '        require(msg.value >= 0.05 ether);\n', '        jackPot += msg.value * 3 / 100;\n', '\n', '        if (x.d(msg.sender, 0) > 0) {\n', '            x.updateIndex(msg.sender);\n', '        } else {\n', '            x.updateCheckpoint(msg.sender);\n', '        }\n', '\n', '        if (msg.data.length == 20) {\n', '            uint addend = setRef();\n', '        } else {\n', '            advertising.transfer(msg.value / 20);\n', '        }\n', '\n', '        x.updateInfo(msg.sender, msg.value + addend, getInterest());\n', '\n', '\n', '        if (msg.value >= 1 ether) {\n', '            toTheTop();\n', '        }\n', '\n', '        emit LogInvestment(msg.sender, msg.value);\n', '    }\n', '\n', '    function withdraw() public {\n', '\n', '        uint _payout;\n', '\n', '        uint _multiplier;\n', '\n', '        if (block.timestamp > x.c(msg.sender) + 2 days) {\n', '            _multiplier = 1;\n', '        }\n', '\n', '        for (uint i = 0; i <= x.ind(msg.sender); i++) {\n', '            if (x.w(msg.sender, i) < x.d(msg.sender, i) * 2) {\n', '                if (x.s(msg.sender, i) <= x.c(msg.sender)) {\n', '                    uint dividends = (x.d(msg.sender, i).mul(_multiplier.mul(15).add(x.i(msg.sender, i))).div(1000)).mul(block.timestamp.sub(x.c(msg.sender).add(_multiplier.mul(2 days)))).div(1 days);\n', '                    dividends = dividends.add(x.d(msg.sender, i).mul(x.i(msg.sender, i)).div(1000).mul(_multiplier).mul(2));\n', '                    if (x.w(msg.sender, i) + dividends <= x.d(msg.sender, i) * 2) {\n', '                        x.updateWithdrawals(msg.sender, i, dividends);\n', '                        _payout = _payout.add(dividends);\n', '                    } else {\n', '                        _payout = _payout.add((x.d(msg.sender, i).mul(2)).sub(x.w(msg.sender, i)));\n', '                        x.updateWithdrawals(msg.sender, i, x.d(msg.sender, i) * 2);\n', '                    }\n', '                } else {\n', '                    if (x.s(msg.sender, i) + 2 days >= block.timestamp) {\n', '                        dividends = (x.d(msg.sender, i).mul(_multiplier.mul(15).add(x.i(msg.sender, i))).div(1000)).mul(block.timestamp.sub(x.s(msg.sender, i).add(_multiplier.mul(2 days)))).div(1 days);\n', '                        dividends = dividends.add(x.d(msg.sender, i).mul(x.i(msg.sender, i)).div(1000).mul(_multiplier).mul(2));\n', '                        if (x.w(msg.sender, i) + dividends <= x.d(msg.sender, i) * 2) {\n', '                            x.updateWithdrawals(msg.sender, i, dividends);\n', '                            _payout = _payout.add(dividends);\n', '                        } else {\n', '                            _payout = _payout.add((x.d(msg.sender, i).mul(2)).sub(x.w(msg.sender, i)));\n', '                            x.updateWithdrawals(msg.sender, i, x.d(msg.sender, i) * 2);\n', '                        }\n', '                    } else {\n', '                        dividends = (x.d(msg.sender, i).mul(x.i(msg.sender, i)).div(1000)).mul(block.timestamp.sub(x.s(msg.sender, i))).div(1 days);\n', '                        x.updateWithdrawals(msg.sender, i, dividends);\n', '                        _payout = _payout.add(dividends);\n', '                    }\n', '                }\n', '\n', '            }\n', '        }\n', '\n', '        if (_payout > 0) {\n', '            if (_payout > address(this).balance && address(this).balance <= 0.1 ether) {\n', '                nextWave();\n', '                return;\n', '            }\n', '            x.updateCheckpoint(msg.sender);\n', '            advertising.transfer(_payout * 3 / 25);\n', '            techsupport.transfer(_payout * 3 / 100);\n', '            msg.sender.transfer(_payout * 17 / 20);\n', '\n', '            emit LogPayment(msg.sender, _payout * 17 / 20);\n', '        }\n', '\n', '        if (block.timestamp >= lastLeader + 1 days && top.length >= 5) {\n', '            payDay();\n', '        }\n', '    }\n', '\n', '    function nextWave() private {\n', '        top.length = 0;\n', '        x = new Storage();\n', '        waveStartUp = block.timestamp + 10 days;\n', '        emit LogNewWave(waveStartUp);\n', '    }\n', '\n', '    function getDeposits(address _address) public view returns(uint Invested) {\n', '        uint _sum;\n', '        for (uint i = 0; i <= x.ind(_address); i++) {\n', '            if (x.w(_address, i) < x.d(_address, i) * 2) {\n', '                _sum += x.d(_address, i);\n', '            }\n', '        }\n', '        Invested = _sum;\n', '    }\n', '\n', '    function getDepositN(address _address, uint _number) public view returns(uint Deposit_N) {\n', '        if (x.w(_address, _number - 1) < x.d(_address, _number - 1) * 2) {\n', '            Deposit_N = x.d(_address, _number - 1);\n', '        } else {\n', '            Deposit_N = 0;\n', '        }\n', '    }\n', '\n', '    function getDividends(address _address) public view returns(uint Dividends) {\n', '\n', '        uint _payout;\n', '        uint _multiplier;\n', '\n', '        if (block.timestamp > x.c(_address) + 2 days) {\n', '            _multiplier = 1;\n', '        }\n', '\n', '        for (uint i = 0; i <= x.ind(_address); i++) {\n', '            if (x.w(_address, i) < x.d(_address, i) * 2) {\n', '                if (x.s(_address, i) <= x.c(_address)) {\n', '                    uint dividends = (x.d(_address, i).mul(_multiplier.mul(15).add(x.i(_address, i))).div(1000)).mul(block.timestamp.sub(x.c(_address).add(_multiplier.mul(2 days)))).div(1 days);\n', '                    dividends += (x.d(_address, i).mul(x.i(_address, i)).div(1000).mul(_multiplier).mul(2));\n', '                    if (x.w(_address, i) + dividends <= x.d(_address, i) * 2) {\n', '                        _payout = _payout.add(dividends);\n', '                    } else {\n', '                        _payout = _payout.add((x.d(_address, i).mul(2)).sub(x.w(_address, i)));\n', '                    }\n', '                } else {\n', '                    if (x.s(_address, i) + 2 days >= block.timestamp) {\n', '                        dividends = (x.d(_address, i).mul(_multiplier.mul(15).add(x.i(_address, i))).div(1000)).mul(block.timestamp.sub(x.s(_address, i).add(_multiplier.mul(2 days)))).div(1 days);\n', '                        dividends += (x.d(_address, i).mul(x.i(_address, i)).div(1000).mul(_multiplier).mul(2));\n', '                        if (x.w(_address, i) + dividends <= x.d(_address, i) * 2) {\n', '                            _payout = _payout.add(dividends);\n', '                        } else {\n', '                            _payout = _payout.add((x.d(_address, i).mul(2)).sub(x.w(_address, i)));\n', '                        }\n', '                    } else {\n', '                        dividends = (x.d(_address, i).mul(x.i(_address, i)).div(1000)).mul(block.timestamp.sub(x.s(_address, i))).div(1 days);\n', '                        _payout = _payout.add(dividends);\n', '                    }\n', '                }\n', '\n', '            }\n', '        }\n', '\n', '        Dividends = _payout * 17 / 20;\n', '    }\n', '\n', '    function getWithdrawals(address _address) external view returns(uint) {\n', '        uint _sum;\n', '        for (uint i = 0; i <= x.ind(_address); i++) {\n', '            _sum += x.w(_address, i);\n', '        }\n', '        return(_sum);\n', '    }\n', '\n', '    function getTop() external view returns(address, address, address, address, address) {\n', '        return(top[top.length - 1], top[top.length - 2], top[top.length - 3], top[top.length - 4], top[top.length - 5]);\n', '    }\n', '\n', '    function getJackPot() external view returns(uint) {\n', '        return(jackPot);\n', '    }\n', '\n', '    function getNextPayDay() external view returns(uint) {\n', '        return(lastLeader + 1 days);\n', '    }\n', '\n', '}']
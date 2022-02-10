['pragma solidity ^0.4.17;\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract CoinMarketCapApi {\n', '    function requestPrice(string _ticker) public payable;\n', '    function _cost() public returns (uint _price);\n', '}\n', '\n', 'contract ERC20 {\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '}\n', '\n', 'contract DateTime {\n', '    using SafeMath for uint;\n', '    \n', '    uint constant SECONDS_PER_DAY = 24 * 60 * 60;\n', '    int constant OFFSET19700101 = 2440588;\n', '    \n', '    function _timestampToDate(uint256 _timestamp) internal pure returns (uint year, uint month, uint day) {\n', '        uint _days = _timestamp / SECONDS_PER_DAY;\n', '        int __days = int(_days);\n', '        \n', '        int L = __days + 68569 + OFFSET19700101;\n', '        int N = 4 * L / 146097;\n', '        L = L - (146097 * N + 3) / 4;\n', '        int _year = 4000 * (L + 1) / 1461001;\n', '        L = L - 1461 * _year / 4 + 31;\n', '        int _month = 80 * L / 2447;\n', '        int _day = L - 2447 * _month / 80;\n', '        L = _month / 11;\n', '        _month = _month + 2 - 12 * L;\n', '        _year = 100 * (N - 49) + _year + L;\n', '        \n', '        year = uint(_year);\n', '        month = uint(_month);\n', '        day = uint(_day);\n', '    }\n', '    \n', '    function isLeapYear(uint year) internal pure returns (bool) {\n', '        if (year % 4 != 0) {\n', '            return false;\n', '        }\n', '        if (year % 100 != 0) {\n', '            return true;\n', '        }\n', '        if (year % 400 != 0) {\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function getDaysInMonth(uint month, uint year, uint _addMonths) internal pure returns (uint) {\n', '        if(_addMonths > 0){\n', '            (month, year) = addMonth(month, year, _addMonths);\n', '        }\n', '        \n', '        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {\n', '            return 31;\n', '        }\n', '        else if (month == 4 || month == 6 || month == 9 || month == 11) {\n', '            return 30;\n', '        }\n', '        else if (isLeapYear(year)) {\n', '            return 29;\n', '        }\n', '        else {\n', '            return 28;\n', '        }\n', '    }\n', '    \n', '    function diffMonths(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _months) {\n', '        require(fromTimestamp <= toTimestamp);\n', '        uint fromYear;\n', '        uint fromMonth;\n', '        uint fromDay;\n', '        uint toYear;\n', '        uint toMonth;\n', '        uint toDay;\n', '        (fromYear, fromMonth, fromDay) = _timestampToDate(fromTimestamp);\n', '        (toYear, toMonth, toDay) = _timestampToDate(toTimestamp);\n', '        \n', '        _months = (((toYear.mul(12)).add(toMonth)).sub(fromYear.mul(12))).sub(fromMonth);\n', '    }\n', '    \n', '    function addMonth(uint _month, uint _year, uint _add) internal pure returns (uint _nwMonth, uint _nwYear) {\n', '        require(_add < 12);\n', '        \n', '        if(_month + _add > 12){\n', '            _nwYear = _year + 1;\n', '            _nwMonth = 1;\n', '        } else {\n', '            _nwMonth = _month + _add;\n', '            _nwYear = _year;\n', '        }\n', '    }\n', '}\n', '\n', 'contract initLib is DateTime {\n', '    using SafeMath for uint;\n', '    \n', '    string  public symbol = "OWT";\n', '    uint256 public decimals = 18;\n', '    address public tokenAddress;\n', '    uint256 public tokenPrice = 150000;\n', '    \n', '    uint256 public domainCost = 500; \n', '    uint256 public publishCost = 200; \n', '    uint256 public hostRegistryCost = 1000; \n', '    uint256 public userSurfingCost = 10; \n', '    uint256 public registryDuration = 365 * 1 days;\n', '    uint256 public stakeLockTime = 31 * 1 days;\n', '    \n', '    uint public websiteSizeLimit = 512;\n', '    uint public websiteFilesLimit = 20;\n', '    \n', '    address public ow_owner;\n', '    address public cmcAddress;\n', '    uint public lastPriceUpdate;\n', '    \n', '    mapping ( address => uint256 ) public balanceOf;\n', '    mapping ( address => uint256 ) public stakeBalance;\n', '    mapping ( uint => mapping ( uint => uint256 )) public poolBalance;\n', '    mapping ( uint => mapping ( uint => uint256 )) public poolBalanceClaimed;\n', '    mapping ( uint => mapping ( uint => uint256 )) public totalStakes;\n', '    \n', '    uint256 public totalSubscriber;\n', '    uint256 public totalHosts;\n', '    uint256 public totalDomains;\n', '    \n', '    mapping ( address => UserMeta ) public users;\n', '    mapping ( bytes32 => DomainMeta ) public domains;\n', '    mapping ( bytes32 => DomainSaleMeta ) public domain_sale;\n', '    mapping ( address => HostMeta ) public hosts;\n', '    mapping ( uint => address ) public hostAddress;\n', '    mapping ( uint => bytes32 ) public hostConnection;\n', '    mapping ( bytes32 => bool ) public hostConnectionDB;\n', '    \n', '    mapping ( uint => mapping ( uint => mapping ( address => uint256 ) )) public hostStakes;\n', '    mapping ( uint => mapping ( uint => mapping ( address => uint256 ) )) public stakeTmpBalance;\n', '    mapping ( address => uint256 ) public stakesLockups;\n', '    \n', '    mapping ( uint => uint ) public hostUpdates;\n', '    uint public hostUpdatesCounter;\n', '    \n', '    mapping ( uint => string ) public websiteUpdates;\n', '    uint public websiteUpdatesCounter;\n', '    \n', '    struct DomainMeta {\n', '        string name;\n', '        uint admin_index;\n', '        uint total_admins;\n', '        mapping(uint => mapping(address => bool)) admins;\n', '        string git;\n', '        bytes32 domain_bytes;\n', '        bytes32 hash;\n', '        uint total_files;\n', '        uint version;\n', '        mapping(uint => mapping(bytes32 => bytes32)) files_hash;\n', '        uint ttl;\n', '        uint time;\n', '        uint expity_time;\n', '    }\n', '    \n', '    struct DomainSaleMeta {\n', '        address owner;\n', '        address to;\n', '        uint amount;\n', '        uint time;\n', '        uint expity_time;\n', '    }\n', '    \n', '    struct HostMeta {\n', '        uint id;\n', '        address hostAddress;\n', '        bytes32 connection;\n', '        bool active;\n', '        uint start_time;\n', '        uint time;\n', '    }\n', '    \n', '    struct UserMeta {\n', '        bool active;\n', '        uint start_time;\n', '        uint expiry_time;\n', '        uint time;\n', '    }\n', '    \n', '    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {\n', '        bytes memory tempEmptyStringTest = bytes(source);\n', '        if (tempEmptyStringTest.length == 0) {\n', '            return 0x0;\n', '        }\n', '    \n', '        assembly {\n', '            result := mload(add(source, 32))\n', '        }\n', '    }\n', '    \n', '    function setOwOwner(address _address) public {\n', '        require(msg.sender == ow_owner);\n', '        ow_owner = _address;\n', '    }\n', '    \n', '    function _currentPrice(uint256 _price) public view returns (uint256 _getprice) {\n', '        _getprice = (_price * 10**uint(24)) / tokenPrice;\n', '    }\n', '    \n', '    function __response(uint _price) public {\n', '        require(msg.sender == cmcAddress);\n', '        tokenPrice = _price;\n', '    }\n', '    \n', '    function fetchTokenPrice() public payable {\n', '        require(\n', '            lastPriceUpdate + 1 * 1 days <  now\n', '        );\n', '        \n', '        lastPriceUpdate = now;\n', '        uint _getprice = CoinMarketCapApi(cmcAddress)._cost();\n', '        CoinMarketCapApi(cmcAddress).requestPrice.value(_getprice)(symbol);\n', '    }\n', '    \n', '    function _priceFetchingCost() public view returns (uint _getprice) {\n', '        _getprice = CoinMarketCapApi(cmcAddress)._cost();\n', '    }\n', '    \n', '    function debitToken(uint256 _amount) internal {\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);\n', '        balanceOf[ow_owner] = balanceOf[ow_owner].add(_amount);\n', '    }\n', '    \n', '    function creditUserPool(uint _duration, uint256 _price) internal {\n', '        uint _monthDays; uint _remainingDays; \n', '        uint _year; uint _month; uint _day; \n', '        (_year, _month, _day) = _timestampToDate(now);\n', '        \n', '        _day--;\n', '        uint monthDiff = diffMonths(now, now + ( _duration * 1 days )) + 1;\n', '        \n', '        for(uint i = 0; i < monthDiff; i++) {\n', '            _monthDays = getDaysInMonth(_month, _year, 0); \n', '            \n', '            if(_day.add(_duration) > _monthDays){ \n', '                _remainingDays = _monthDays.sub(_day);\n', '                balanceOf[address(0x0)] = balanceOf[address(0x0)].add((_remainingDays * _price * 10) / 100);\n', '                poolBalance[_year][_month] = poolBalance[_year][_month].add((_remainingDays * _price * 90) / 100);\n', '                \n', '                (_month, _year) = addMonth(_month, _year, 1);\n', '                \n', '                _duration = _duration.sub(_remainingDays);\n', '                _day = 0;\n', '                \n', '            } else {\n', '                balanceOf[address(0x0)] = balanceOf[address(0x0)].add((_duration * _price * 10) / 100);\n', '                poolBalance[_year][_month] = poolBalance[_year][_month].add((_duration * _price * 90) / 100);\n', '            }\n', '            \n', '        }\n', '    }\n', '}\n', '\n', 'contract owContract is initLib {\n', '    \n', '    function owContract(address _token, address _cmc) public {\n', '        tokenAddress = _token;\n', '        ow_owner = msg.sender;\n', '        cmcAddress = _cmc;\n', '    }\n', '    \n', '    function _validateDomain(string _domain) internal pure returns (bool){\n', '        bytes memory b = bytes(_domain);\n', '        if(b.length > 32) return false;\n', '        \n', '        uint counter = 0;\n', '        for(uint i; i<b.length; i++){\n', '            bytes1 char = b[i];\n', '            \n', '            if(\n', '                !(char >= 0x30 && char <= 0x39)   //9-0\n', '                && !(char >= 0x61 && char <= 0x7A)  //a-z\n', '                && !(char == 0x2D) // - \n', '                && !(char == 0x2E && counter == 0) // . \n', '            ){\n', '                    return false;\n', '            }\n', '            \n', '            if(char == 0x2E) counter++; \n', '        }\n', '    \n', '        return true;\n', '    }\n', '    \n', '    function registerDomain(string _domain, uint _ttl) public returns (bool _status) {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        DomainMeta storage d = domains[_domainBytes];\n', '        uint256 _cPrice = _currentPrice(domainCost);\n', '        \n', '        require(\n', '            d.expity_time < now \n', '            && _ttl >= 1 hours \n', '            && balanceOf[msg.sender] >= _cPrice \n', '            && _validateDomain(_domain)\n', '        );\n', '        \n', '        debitToken(_cPrice);\n', '        uint _adminIndex = d.admin_index + 1;\n', '        \n', '        if(d.expity_time == 0){\n', '            totalDomains++;\n', '        }\n', '        \n', '        d.name = _domain;\n', '        d.domain_bytes = _domainBytes;\n', '        d.admin_index = _adminIndex;\n', '        d.total_admins = 1;\n', '        d.admins[_adminIndex][msg.sender] = true;\n', '        d.ttl = _ttl;\n', '        d.expity_time = now + registryDuration;\n', '        d.time = now;\n', '        \n', '        _status = true;\n', '    }\n', '    \n', '    function updateDomainTTL(string _domain, uint _ttl) public returns (bool _status) {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        DomainMeta storage d = domains[_domainBytes];\n', '        require(\n', '            d.admins[d.admin_index][msg.sender] \n', '            && _ttl >= 1 hours \n', '            && d.expity_time > now\n', '        );\n', '        \n', '        d.ttl = _ttl;\n', '        _status = true;\n', '    }\n', '    \n', '    function renewDomain(string _domain) public returns (bool _status) {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        DomainMeta storage d = domains[_domainBytes];\n', '        uint256 _cPrice = _currentPrice(domainCost);\n', '        \n', '        require(\n', '            d.expity_time > now \n', '            && balanceOf[msg.sender] >= _cPrice\n', '        );\n', '        \n', '        debitToken(_cPrice);\n', '        d.expity_time = d.expity_time.add(registryDuration);\n', '        \n', '        _status = true;\n', '    }\n', '    \n', '    function addDomainAdmin(string _domain, address _admin) public returns (bool _status) {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        DomainMeta storage d = domains[_domainBytes];\n', '        require(\n', '            d.admins[d.admin_index][msg.sender] \n', '            && !d.admins[d.admin_index][_admin]\n', '            && d.expity_time > now\n', '        );\n', '        \n', '        d.total_admins = d.total_admins.add(1);\n', '        d.admins[d.admin_index][_admin] = true;\n', '        \n', '        _status = true;\n', '    }\n', '    \n', '    function removeDomainAdmin(string _domain, address _admin) public returns (bool _status) {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        DomainMeta storage d = domains[_domainBytes];\n', '        require(\n', '            d.admins[d.admin_index][msg.sender] \n', '            && d.admins[d.admin_index][_admin] \n', '            && d.expity_time > now\n', '        );\n', '        \n', '        d.total_admins = d.total_admins.sub(1);\n', '        d.admins[d.admin_index][_admin] = false;\n', '        \n', '        _status = true;\n', '    }\n', '    \n', '    function sellDomain(\n', '        string _domain, \n', '        address _owner, \n', '        address _to, \n', '        uint256 _amount, \n', '        uint _expiry\n', '    ) public returns (bool _status) {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        uint _sExpiry = now + ( _expiry * 1 days );\n', '        \n', '        DomainMeta storage d = domains[_domainBytes];\n', '        DomainSaleMeta storage ds = domain_sale[_domainBytes];\n', '        \n', '        require(\n', '            _amount > 0\n', '            && d.admins[d.admin_index][msg.sender] \n', '            && d.expity_time > _sExpiry \n', '            && ds.expity_time < now\n', '        );\n', '        \n', '        ds.owner = _owner;\n', '        ds.to = _to;\n', '        ds.amount = _amount;\n', '        ds.time = now;\n', '        ds.expity_time = _sExpiry;\n', '        \n', '        _status = true;\n', '    }\n', '    \n', '    function cancelSellDomain(string _domain) public returns (bool _status) {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        DomainMeta storage d = domains[_domainBytes];\n', '        DomainSaleMeta storage ds = domain_sale[_domainBytes];\n', '        \n', '        require(\n', '            d.admins[d.admin_index][msg.sender] \n', '            && d.expity_time > now \n', '            && ds.expity_time > now\n', '        );\n', '        \n', '        ds.owner = address(0x0);\n', '        ds.to = address(0x0);\n', '        ds.amount = 0;\n', '        ds.time = 0;\n', '        ds.expity_time = 0;\n', '        \n', '        _status = true;\n', '    }\n', '    \n', '    function buyDomain(string _domain) public returns (bool _status) {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        DomainMeta storage d = domains[_domainBytes];\n', '        DomainSaleMeta storage ds = domain_sale[_domainBytes];\n', '        \n', '        if(ds.to != address(0x0)){\n', '            require( ds.to == msg.sender );\n', '        }\n', '        \n', '        require(\n', '            balanceOf[msg.sender] >= ds.amount \n', '            && d.expity_time > now \n', '            && ds.expity_time > now\n', '        );\n', '        \n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(ds.amount);\n', '        balanceOf[ds.owner] = balanceOf[ds.owner].add(ds.amount);\n', '        \n', '        uint _adminIndex = d.admin_index + 1;\n', '        \n', '        d.total_admins = 1;\n', '        d.admin_index = _adminIndex;\n', '        d.admins[_adminIndex][msg.sender] = true;\n', '        ds.expity_time = 0;\n', '        \n', '        _status = true;\n', '    }\n', '    \n', '    function publishWebsite(\n', '        string _domain, \n', '        string _git, \n', '        bytes32 _filesHash,\n', '        bytes32[] _file_name, \n', '        bytes32[] _file_hash\n', '    ) public returns (bool _status) {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        DomainMeta storage d = domains[_domainBytes];\n', '        uint256 _cPrice = _currentPrice(publishCost);\n', '        \n', '        require(\n', '            d.admins[d.admin_index][msg.sender] \n', '            && balanceOf[msg.sender] >= _cPrice \n', '            && _file_name.length <= websiteFilesLimit \n', '            && _file_name.length == _file_hash.length\n', '            && d.expity_time > now\n', '        );\n', '        \n', '        debitToken(_cPrice);\n', '        d.version++;\n', '        \n', '        for(uint i = 0; i < _file_name.length; i++) {\n', '            d.files_hash[d.version][_file_name[i]] = _file_hash[i];\n', '        }\n', '        \n', '        d.git = _git;\n', '        d.total_files = _file_name.length;\n', '        d.hash = _filesHash;\n', '        \n', '        websiteUpdates[websiteUpdatesCounter] = _domain;\n', '        websiteUpdatesCounter++;\n', '        \n', '        _status = true;\n', '    }\n', '    \n', '    function getDomainMeta(string _domain) public view \n', '        returns (\n', '            string _name,  \n', '            string _git, \n', '            bytes32 _domain_bytes, \n', '            bytes32 _hash, \n', '            uint _total_admins,\n', '            uint _adminIndex, \n', '            uint _total_files, \n', '            uint _version, \n', '            uint _ttl, \n', '            uint _time, \n', '            uint _expity_time\n', '        )\n', '    {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        DomainMeta storage d = domains[_domainBytes];\n', '        \n', '        _name = d.name;\n', '        _git = d.git;\n', '        _domain_bytes = d.domain_bytes;\n', '        _hash = d.hash;\n', '        _total_admins = d.total_admins;\n', '        _adminIndex = d.admin_index;\n', '        _total_files = d.total_files;\n', '        _version = d.version;\n', '        _ttl = d.ttl;\n', '        _time = d.time;\n', '        _expity_time = d.expity_time;\n', '    }\n', '    \n', '    function getDomainFileHash(string _domain, bytes32 _file_name) public view \n', '        returns ( \n', '            bytes32 _hash\n', '        )\n', '    {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        DomainMeta storage d = domains[_domainBytes];\n', '        \n', '        _hash = d.files_hash[d.version][_file_name];\n', '    }\n', '    \n', '    function verifyDomainFileHash(string _domain, bytes32 _file_name, bytes32 _file_hash) public view \n', '        returns ( \n', '            bool _status\n', '        )\n', '    {\n', '        bytes32 _domainBytes = stringToBytes32(_domain);\n', '        DomainMeta storage d = domains[_domainBytes];\n', '        \n', '        _status = ( d.files_hash[d.version][_file_name] == _file_hash );\n', '    }\n', '    \n', '    function registerHost(string _connection) public returns (bool _status) {\n', '        bytes32 hostConn = stringToBytes32(_connection);\n', '        HostMeta storage h = hosts[msg.sender];\n', '        uint256 _cPrice = _currentPrice(hostRegistryCost);\n', '        \n', '        require(\n', '            !h.active \n', '            && balanceOf[msg.sender] >= _cPrice \n', '            && !hostConnectionDB[hostConn]\n', '        );\n', '        \n', '        debitToken(_cPrice);\n', '        \n', '        h.id = totalHosts;\n', '        h.connection = hostConn;\n', '        h.active = true;\n', '        h.time = now;\n', '        \n', '        hostAddress[totalHosts] = msg.sender;\n', '        hostConnection[totalHosts] = h.connection;\n', '        hostConnectionDB[hostConn] = true;\n', '        totalHosts++;\n', '        \n', '        _status = true;\n', '    }\n', '    \n', '    function updateHost(string _connection) public returns (bool _status) {\n', '        bytes32 hostConn = stringToBytes32(_connection);\n', '        HostMeta storage h = hosts[msg.sender];\n', '        \n', '        require(\n', '            h.active \n', '            && h.connection != hostConn \n', '            && !hostConnectionDB[hostConn]\n', '        );\n', '        \n', '        hostConnectionDB[h.connection] = false;\n', '        h.connection = hostConn;\n', '        \n', '        hostConnectionDB[hostConn] = true;\n', '        hostUpdates[hostUpdatesCounter] = h.id;\n', '        hostConnection[h.id] = hostConn;\n', '        hostUpdatesCounter++;\n', '        \n', '        _status = true;\n', '    }\n', '    \n', '    function userSubscribe(uint _duration) public {\n', '        uint256 _cPrice = _currentPrice(userSurfingCost);\n', '        uint256 _cost = _duration * _cPrice;\n', '        \n', '        require(\n', '            _duration < 400 \n', '            && _duration > 0\n', '            && balanceOf[msg.sender] >= _cost\n', '        );\n', '        \n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_cost);\n', '        creditUserPool(_duration, _cPrice);\n', '        \n', '        UserMeta storage u = users[msg.sender];\n', '        if(!u.active){\n', '            u.active = true;\n', '            u.time = now;\n', '            \n', '            totalSubscriber++;\n', '        }\n', '        \n', '        if(u.expiry_time < now){\n', '            u.start_time = now;\n', '            u.expiry_time = now + (_duration * 1 days);\n', '        } else {\n', '            u.expiry_time = u.expiry_time.add(_duration * 1 days);\n', '        }\n', '    }\n', '    \n', '    function stakeTokens(address _hostAddress, uint256 _amount) public {\n', '        require( balanceOf[msg.sender] >= _amount );\n', '        \n', '        uint _year; uint _month; uint _day; \n', '        (_year, _month, _day) = _timestampToDate(now);\n', '        \n', '        HostMeta storage h = hosts[_hostAddress];\n', '        require( h.active );\n', '        \n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);\n', '        stakeBalance[msg.sender] = stakeBalance[msg.sender].add(_amount);\n', '        stakeTmpBalance[_year][_month][msg.sender] = stakeTmpBalance[_year][_month][msg.sender].add(_amount);\n', '        \n', '        stakesLockups[msg.sender] = now + stakeLockTime;\n', '        \n', '        hostStakes[_year][_month][_hostAddress] = hostStakes[_year][_month][_hostAddress].add(_amount);\n', '        totalStakes[_year][_month] = totalStakes[_year][_month].add(_amount);\n', '    }\n', '    \n', '    function validateMonth(uint _year, uint _month) internal view {\n', '        uint __year; uint __month; uint __day; \n', '        (__year, __month, __day) = _timestampToDate(now);\n', '        if(__month == 1){ __year--; __month = 12; } else { __month--; }\n', '        \n', '        require( (((__year.mul(12)).add(__month)).sub(_year.mul(12))).sub(_month) >= 0 );\n', '    }\n', '    \n', '    function claimHostTokens(uint _year, uint _month) public {\n', '        validateMonth(_year, _month);\n', '        \n', '        HostMeta storage h = hosts[msg.sender];\n', '        require( h.active );\n', '        \n', '        if(totalStakes[_year][_month] > 0){\n', '            uint256 _tmpHostStake = hostStakes[_year][_month][msg.sender];\n', '            \n', '            if(_tmpHostStake > 0){\n', '                uint256 _totalStakes = totalStakes[_year][_month];\n', '                uint256 _poolAmount = poolBalance[_year][_month];\n', '                \n', '                hostStakes[_year][_month][msg.sender] = 0;\n', '                uint256 _amount = ((_tmpHostStake.mul(_poolAmount)).mul(50)).div(_totalStakes.mul(100));\n', '                if(_amount > 0){\n', '                    balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);\n', '                    poolBalanceClaimed[_year][_month] = poolBalanceClaimed[_year][_month].add(_amount);\n', '                }\n', '            }\n', '        }\n', '    }\n', '    \n', '    function claimStakeTokens(uint _year, uint _month) public {\n', '        validateMonth(_year, _month);\n', '        require(stakesLockups[msg.sender] < now);\n', '        \n', '        if(totalStakes[_year][_month] > 0){\n', '            uint256 _tmpStake = stakeTmpBalance[_year][_month][msg.sender];\n', '            \n', '            if(_tmpStake > 0){\n', '                uint256 _totalStakesBal = stakeBalance[msg.sender];\n', '                \n', '                uint256 _totalStakes = totalStakes[_year][_month];\n', '                uint256 _poolAmount = poolBalance[_year][_month];\n', '                \n', '                uint256 _amount = ((_tmpStake.mul(_poolAmount)).mul(50)).div(_totalStakes.mul(100));\n', '                \n', '                stakeTmpBalance[_year][_month][msg.sender] = 0;\n', '                stakeBalance[msg.sender] = 0;\n', '                uint256 _totamount = _amount.add(_totalStakesBal);\n', '                \n', '                if(_totamount > 0){\n', '                    balanceOf[msg.sender] = balanceOf[msg.sender].add(_totamount);\n', '                    poolBalanceClaimed[_year][_month] = poolBalanceClaimed[_year][_month].add(_amount);\n', '                }\n', '            }\n', '        }\n', '    }\n', '    \n', '    function getHostTokens(address _address, uint _year, uint _month) public view returns (uint256 _amount) {\n', '        validateMonth(_year, _month);\n', '        \n', '        HostMeta storage h = hosts[_address];\n', '        require( h.active );\n', '        \n', '        _amount = 0;\n', '        if(h.active && totalStakes[_year][_month] > 0){\n', '            uint256 _tmpHostStake = hostStakes[_year][_month][_address];\n', '            \n', '            if(_tmpHostStake > 0){\n', '                uint256 _totalStakes = totalStakes[_year][_month];\n', '                uint256 _poolAmount = poolBalance[_year][_month];\n', '                \n', '                _amount = ((_tmpHostStake.mul(_poolAmount)).mul(50)).div(_totalStakes.mul(100));\n', '            }\n', '        }\n', '    }\n', '    \n', '    function getStakeTokens(address _address, uint _year, uint _month) public view returns (uint256 _amount) {\n', '        validateMonth(_year, _month);\n', '        require(stakesLockups[_address] < now);\n', '        \n', '        _amount = 0;\n', '        if(stakesLockups[_address] < now && totalStakes[_year][_month] > 0){\n', '            uint256 _tmpStake = stakeTmpBalance[_year][_month][_address];\n', '            \n', '            if(_tmpStake > 0){\n', '                uint256 _totalStakesBal = stakeBalance[_address];\n', '                \n', '                uint256 _totalStakes = totalStakes[_year][_month];\n', '                uint256 _poolAmount = poolBalance[_year][_month];\n', '                \n', '                _amount = ((_tmpStake.mul(_poolAmount)).mul(50)).div(_totalStakes.mul(100));\n', '                _amount = _amount.add(_totalStakesBal);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function burnPoolTokens(uint _year, uint _month) public {\n', '        validateMonth(_year, _month);\n', '        \n', '        if(totalStakes[_year][_month] == 0){\n', '            uint256 _poolAmount = poolBalance[_year][_month];\n', '            \n', '            if(_poolAmount > 0){\n', '                poolBalance[_year][_month] = 0;\n', '                balanceOf[address(0x0)] = balanceOf[address(0x0)].add(_poolAmount);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function poolDonate(uint _year, uint _month, uint256 _amount) public {\n', '        require(\n', '            _amount > 0\n', '            && balanceOf[msg.sender] >= _amount\n', '        );\n', '        \n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);\n', '        \n', '        balanceOf[address(0x0)] = balanceOf[address(0x0)].add((_amount * 10) / 100);\n', '        poolBalance[_year][_month] = poolBalance[_year][_month].add((_amount * 90) / 100);\n', '    }\n', '    \n', '    function internalTransfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(\n', '            _value > 0\n', '            && balanceOf[msg.sender] >= _value\n', '        );\n', '        \n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(\n', '            _value > 0\n', '            && balanceOf[msg.sender] >= _value\n', '        );\n', '        \n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        ERC20(tokenAddress).transfer(_to, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function burn() public {\n', '        uint256 _amount = balanceOf[address(0x0)];\n', '        require( _amount > 0 );\n', '        \n', '        balanceOf[address(0x0)] = 0;\n', '        ERC20(tokenAddress).transfer(address(0x0), _amount);\n', '    }\n', '    \n', '    function notifyBalance(address sender, uint tokens) public {\n', '        require(\n', '            msg.sender == tokenAddress\n', '        );\n', '        \n', '        balanceOf[sender] = balanceOf[sender].add(tokens);\n', '    }\n', '    \n', '    function () public payable {} \n', '}']
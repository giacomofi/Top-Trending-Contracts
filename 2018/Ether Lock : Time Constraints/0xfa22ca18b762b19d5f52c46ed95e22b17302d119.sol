['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', '\n', 'contract Ownable {\n', '    \n', '    address[] public owners;\n', '    \n', '    mapping(address => bool) bOwner;\n', '    \n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owners = [ 0x315C082246FFF04c9E790620867E6e0AD32f2FE3 ];\n', '                    \n', '        for (uint i=0; i< owners.length; i++){\n', '            bOwner[owners[i]]=true;\n', '        }\n', '    }\n', '    \n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        \n', '        require(bOwner[msg.sender]);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '\n', '}\n', '\n', '\n', 'contract ClothingToken is Ownable {\n', '    \n', '\n', '    uint256 public totalSupply;\n', '    uint256 public totalSupplyMarket;\n', '    uint256 public totalSupplyYear;\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    \n', '    string public constant name = "ClothingCoin";\n', '    string public constant symbol = "CC";\n', '    uint32 public constant decimals = 0;\n', '\n', '    uint256 public constant hardcap = 300000000;\n', '    uint256 public constant marketCap= 150000000;\n', '    uint256 public yearCap=75000000 ;\n', '    \n', '    uint currentyear=2018;\n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '    struct DateTime {\n', '        uint16 year;\n', '        uint8 month;\n', '        uint8 day;\n', '        uint8 hour;\n', '        uint8 minute;\n', '        uint8 second;\n', '        uint8 weekday;\n', '    }\n', '\n', '    uint constant DAY_IN_SECONDS = 86400;\n', '    uint constant YEAR_IN_SECONDS = 31536000;\n', '    uint constant LEAP_YEAR_IN_SECONDS = 31622400;\n', '\n', '    uint constant HOUR_IN_SECONDS = 3600;\n', '    uint constant MINUTE_IN_SECONDS = 60;\n', '\n', '    uint16 constant ORIGIN_YEAR = 1970;\n', '\n', '    function isLeapYear(uint16 year) constant returns (bool) {\n', '        if (year % 4 != 0) {\n', '            return false;\n', '        }\n', '        if (year % 100 != 0) {\n', '            return true;\n', '        }\n', '        if (year % 400 != 0) {\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '    function parseTimestamp(uint timestamp) internal returns (DateTime dt) {\n', '        uint secondsAccountedFor = 0;\n', '        uint buf;\n', '        uint8 i;\n', '\n', '        dt.year = ORIGIN_YEAR;\n', '\n', '        // Year\n', '        while (true) {\n', '            if (isLeapYear(dt.year)) {\n', '                    buf = LEAP_YEAR_IN_SECONDS;\n', '            }\n', '            else {\n', '                    buf = YEAR_IN_SECONDS;\n', '            }\n', '\n', '            if (secondsAccountedFor + buf > timestamp) {\n', '                    break;\n', '            }\n', '            dt.year += 1;\n', '            secondsAccountedFor += buf;\n', '        }\n', '\n', '        // Month\n', '        uint8[12] monthDayCounts;\n', '        monthDayCounts[0] = 31;\n', '        if (isLeapYear(dt.year)) {\n', '            monthDayCounts[1] = 29;\n', '        }\n', '        else {\n', '            monthDayCounts[1] = 28;\n', '        }\n', '        monthDayCounts[2] = 31;\n', '        monthDayCounts[3] = 30;\n', '        monthDayCounts[4] = 31;\n', '        monthDayCounts[5] = 30;\n', '        monthDayCounts[6] = 31;\n', '        monthDayCounts[7] = 31;\n', '        monthDayCounts[8] = 30;\n', '        monthDayCounts[9] = 31;\n', '        monthDayCounts[10] = 30;\n', '        monthDayCounts[11] = 31;\n', '\n', '        uint secondsInMonth;\n', '        for (i = 0; i < monthDayCounts.length; i++) {\n', '            secondsInMonth = DAY_IN_SECONDS * monthDayCounts[i];\n', '            if (secondsInMonth + secondsAccountedFor > timestamp) {\n', '                    dt.month = i + 1;\n', '                    break;\n', '            }\n', '            secondsAccountedFor += secondsInMonth;\n', '        }\n', '\n', '        // Day\n', '        for (i = 0; i < monthDayCounts[dt.month - 1]; i++) {\n', '            if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {\n', '                    dt.day = i + 1;\n', '                    break;\n', '            }\n', '            secondsAccountedFor += DAY_IN_SECONDS;\n', '        }\n', '\n', '        // Hour\n', '        for (i = 0; i < 24; i++) {\n', '            if (HOUR_IN_SECONDS + secondsAccountedFor > timestamp) {\n', '                    dt.hour = i;\n', '                    break;\n', '            }\n', '            secondsAccountedFor += HOUR_IN_SECONDS;\n', '        }\n', '\n', '        // Minute\n', '        for (i = 0; i < 60; i++) {\n', '            if (MINUTE_IN_SECONDS + secondsAccountedFor > timestamp) {\n', '                    dt.minute = i;\n', '                    break;\n', '            }\n', '            secondsAccountedFor += MINUTE_IN_SECONDS;\n', '        }\n', '\n', '        if (timestamp - secondsAccountedFor > 60) {\n', '            __throw();\n', '        }\n', '        \n', '        // Second\n', '        dt.second = uint8(timestamp - secondsAccountedFor);\n', '\n', '        // Day of week.\n', '        buf = timestamp / DAY_IN_SECONDS;\n', '        dt.weekday = uint8((buf + 3) % 7);\n', '    }\n', '        \n', '    function __throw() {\n', '        uint[] arst;\n', '        arst[1];\n', '    }\n', '    \n', '    function getYear(uint timestamp) constant returns (uint16) {\n', '        return parseTimestamp(timestamp).year;\n', '    }\n', '    \n', '    modifier canYearMint() {\n', '        if(getYear(now) != currentyear){\n', '            currentyear=getYear(now);\n', '            yearCap=yearCap/2;\n', '            totalSupplyYear=0;\n', '        }\n', '        require(totalSupply <= marketCap);\n', '        require(totalSupplyYear <= yearCap);\n', '        _;\n', '        \n', '    }\n', '    \n', '    modifier canMarketMint(){\n', '        require(totalSupplyMarket <= marketCap);\n', '        _;\n', '    }\n', '\n', '    function mintForMarket (address _to, uint256 _value) public onlyOwner canMarketMint returns (bool){\n', '        \n', '        if (_value + totalSupplyMarket <= marketCap) {\n', '        \n', '            totalSupplyMarket = totalSupplyMarket + _value;\n', '            \n', '            assert(totalSupplyMarket >= _value);\n', '             \n', '            balances[msg.sender] = balances[msg.sender] + _value;\n', '            assert(balances[msg.sender] >= _value);\n', '            Mint(msg.sender, _value);\n', '        \n', '            _transfer(_to, _value);\n', '            \n', '        }\n', '        return true;\n', '    }\n', '\n', '    function _transfer( address _to, uint256 _value) internal {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(!frozenAccount[_to]);\n', '\n', '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public  returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(!frozenAccount[msg.sender]);\n', '        require(!frozenAccount[_to]);\n', '\n', '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        balances[_from] = balances[_from] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '        //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '    \n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    \n', '    function mintForYear(address _to, uint256 _value) public onlyOwner canYearMint returns (bool) {\n', '        require(_to != address(0));\n', '        \n', '        if (_value + totalSupplyYear <= yearCap) {\n', '            \n', '            totalSupply = totalSupply + _value;\n', '        \n', '            totalSupplyYear = totalSupplyYear + _value;\n', '            \n', '            assert(totalSupplyYear >= _value);\n', '             \n', '            balances[msg.sender] = balances[msg.sender] + _value;\n', '            assert(balances[msg.sender] >= _value);\n', '            Mint(msg.sender, _value);\n', '        \n', '            _transfer(_to, _value);\n', '            \n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '\n', '    function burn(uint256 _value) public returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        totalSupply = totalSupply - _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);   \n', '        balances[_from] = balances[_from] - _value;\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;\n', '        totalSupply = totalSupply - _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) public onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', ' \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '}']
['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', '\n', 'contract Ownable {\n', '    \n', '    address[] public owners;\n', '    \n', '    mapping(address => bool) bOwner;\n', '    \n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owners = [ 0x315C082246FFF04c9E790620867E6e0AD32f2FE3 ];\n', '                    \n', '        for (uint i=0; i< owners.length; i++){\n', '            bOwner[owners[i]]=true;\n', '        }\n', '    }\n', '    \n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        \n', '        require(bOwner[msg.sender]);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '\n', '}\n', '\n', '\n', 'contract ClothingToken is Ownable {\n', '    \n', '\n', '    uint256 public totalSupply;\n', '    uint256 public totalSupplyMarket;\n', '    uint256 public totalSupplyYear;\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    \n', '    string public constant name = "ClothingCoin";\n', '    string public constant symbol = "CC";\n', '    uint32 public constant decimals = 0;\n', '\n', '    uint256 public constant hardcap = 300000000;\n', '    uint256 public constant marketCap= 150000000;\n', '    uint256 public yearCap=75000000 ;\n', '    \n', '    uint currentyear=2018;\n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '    struct DateTime {\n', '        uint16 year;\n', '        uint8 month;\n', '        uint8 day;\n', '        uint8 hour;\n', '        uint8 minute;\n', '        uint8 second;\n', '        uint8 weekday;\n', '    }\n', '\n', '    uint constant DAY_IN_SECONDS = 86400;\n', '    uint constant YEAR_IN_SECONDS = 31536000;\n', '    uint constant LEAP_YEAR_IN_SECONDS = 31622400;\n', '\n', '    uint constant HOUR_IN_SECONDS = 3600;\n', '    uint constant MINUTE_IN_SECONDS = 60;\n', '\n', '    uint16 constant ORIGIN_YEAR = 1970;\n', '\n', '    function isLeapYear(uint16 year) constant returns (bool) {\n', '        if (year % 4 != 0) {\n', '            return false;\n', '        }\n', '        if (year % 100 != 0) {\n', '            return true;\n', '        }\n', '        if (year % 400 != 0) {\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '    function parseTimestamp(uint timestamp) internal returns (DateTime dt) {\n', '        uint secondsAccountedFor = 0;\n', '        uint buf;\n', '        uint8 i;\n', '\n', '        dt.year = ORIGIN_YEAR;\n', '\n', '        // Year\n', '        while (true) {\n', '            if (isLeapYear(dt.year)) {\n', '                    buf = LEAP_YEAR_IN_SECONDS;\n', '            }\n', '            else {\n', '                    buf = YEAR_IN_SECONDS;\n', '            }\n', '\n', '            if (secondsAccountedFor + buf > timestamp) {\n', '                    break;\n', '            }\n', '            dt.year += 1;\n', '            secondsAccountedFor += buf;\n', '        }\n', '\n', '        // Month\n', '        uint8[12] monthDayCounts;\n', '        monthDayCounts[0] = 31;\n', '        if (isLeapYear(dt.year)) {\n', '            monthDayCounts[1] = 29;\n', '        }\n', '        else {\n', '            monthDayCounts[1] = 28;\n', '        }\n', '        monthDayCounts[2] = 31;\n', '        monthDayCounts[3] = 30;\n', '        monthDayCounts[4] = 31;\n', '        monthDayCounts[5] = 30;\n', '        monthDayCounts[6] = 31;\n', '        monthDayCounts[7] = 31;\n', '        monthDayCounts[8] = 30;\n', '        monthDayCounts[9] = 31;\n', '        monthDayCounts[10] = 30;\n', '        monthDayCounts[11] = 31;\n', '\n', '        uint secondsInMonth;\n', '        for (i = 0; i < monthDayCounts.length; i++) {\n', '            secondsInMonth = DAY_IN_SECONDS * monthDayCounts[i];\n', '            if (secondsInMonth + secondsAccountedFor > timestamp) {\n', '                    dt.month = i + 1;\n', '                    break;\n', '            }\n', '            secondsAccountedFor += secondsInMonth;\n', '        }\n', '\n', '        // Day\n', '        for (i = 0; i < monthDayCounts[dt.month - 1]; i++) {\n', '            if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {\n', '                    dt.day = i + 1;\n', '                    break;\n', '            }\n', '            secondsAccountedFor += DAY_IN_SECONDS;\n', '        }\n', '\n', '        // Hour\n', '        for (i = 0; i < 24; i++) {\n', '            if (HOUR_IN_SECONDS + secondsAccountedFor > timestamp) {\n', '                    dt.hour = i;\n', '                    break;\n', '            }\n', '            secondsAccountedFor += HOUR_IN_SECONDS;\n', '        }\n', '\n', '        // Minute\n', '        for (i = 0; i < 60; i++) {\n', '            if (MINUTE_IN_SECONDS + secondsAccountedFor > timestamp) {\n', '                    dt.minute = i;\n', '                    break;\n', '            }\n', '            secondsAccountedFor += MINUTE_IN_SECONDS;\n', '        }\n', '\n', '        if (timestamp - secondsAccountedFor > 60) {\n', '            __throw();\n', '        }\n', '        \n', '        // Second\n', '        dt.second = uint8(timestamp - secondsAccountedFor);\n', '\n', '        // Day of week.\n', '        buf = timestamp / DAY_IN_SECONDS;\n', '        dt.weekday = uint8((buf + 3) % 7);\n', '    }\n', '        \n', '    function __throw() {\n', '        uint[] arst;\n', '        arst[1];\n', '    }\n', '    \n', '    function getYear(uint timestamp) constant returns (uint16) {\n', '        return parseTimestamp(timestamp).year;\n', '    }\n', '    \n', '    modifier canYearMint() {\n', '        if(getYear(now) != currentyear){\n', '            currentyear=getYear(now);\n', '            yearCap=yearCap/2;\n', '            totalSupplyYear=0;\n', '        }\n', '        require(totalSupply <= marketCap);\n', '        require(totalSupplyYear <= yearCap);\n', '        _;\n', '        \n', '    }\n', '    \n', '    modifier canMarketMint(){\n', '        require(totalSupplyMarket <= marketCap);\n', '        _;\n', '    }\n', '\n', '    function mintForMarket (address _to, uint256 _value) public onlyOwner canMarketMint returns (bool){\n', '        \n', '        if (_value + totalSupplyMarket <= marketCap) {\n', '        \n', '            totalSupplyMarket = totalSupplyMarket + _value;\n', '            \n', '            assert(totalSupplyMarket >= _value);\n', '             \n', '            balances[msg.sender] = balances[msg.sender] + _value;\n', '            assert(balances[msg.sender] >= _value);\n', '            Mint(msg.sender, _value);\n', '        \n', '            _transfer(_to, _value);\n', '            \n', '        }\n', '        return true;\n', '    }\n', '\n', '    function _transfer( address _to, uint256 _value) internal {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(!frozenAccount[_to]);\n', '\n', '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public  returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(!frozenAccount[msg.sender]);\n', '        require(!frozenAccount[_to]);\n', '\n', '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        balances[_from] = balances[_from] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '        //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '    \n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    \n', '    function mintForYear(address _to, uint256 _value) public onlyOwner canYearMint returns (bool) {\n', '        require(_to != address(0));\n', '        \n', '        if (_value + totalSupplyYear <= yearCap) {\n', '            \n', '            totalSupply = totalSupply + _value;\n', '        \n', '            totalSupplyYear = totalSupplyYear + _value;\n', '            \n', '            assert(totalSupplyYear >= _value);\n', '             \n', '            balances[msg.sender] = balances[msg.sender] + _value;\n', '            assert(balances[msg.sender] >= _value);\n', '            Mint(msg.sender, _value);\n', '        \n', '            _transfer(_to, _value);\n', '            \n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '\n', '    function burn(uint256 _value) public returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        totalSupply = totalSupply - _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);   \n', '        balances[_from] = balances[_from] - _value;\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;\n', '        totalSupply = totalSupply - _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) public onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', ' \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '}']

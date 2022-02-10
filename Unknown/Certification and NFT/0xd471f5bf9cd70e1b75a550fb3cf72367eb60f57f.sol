['pragma solidity ^0.4.16;\n', '\n', '/*\n', '    Overflow protected math functions\n', '*/\n', 'contract SafeMath {\n', '    /**\n', '        constructor\n', '    */\n', '    function SafeMath() {\n', '    }\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', '    // these functions aren&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function name() public constant returns (string name) { name; }\n', '    function symbol() public constant returns (string symbol) { symbol; }\n', '    function decimals() public constant returns (uint8 decimals) { decimals; }\n', '    function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '/**\n', '    COSS Token implementation\n', '*/\n', 'contract COSSToken is IERC20Token, SafeMath {\n', '    string public standard = &#39;COSS&#39;;\n', '    string public name = &#39;COSS&#39;;\n', '    string public symbol = &#39;COSS&#39;;\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 54359820;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    mapping (address => uint256) public revenueShareList;\n', '    mapping (address => string) public revenueShareCurrency;\n', '    mapping (address => uint256) public revenueShareDistribution;\n', '\n', '    uint256 public decimalMultiplier = 1000000000000000000;\n', '    uint256 public icoSold = 9359820;\n', '    address public revenueShareOwnerAddress;\n', '    address public icoWalletAddress = 0xbf7aa06109ce182203ee3805614736fe18dead43;\n', '    address public teamWalletAddress = 0x552b3f0c1747cfefc726bc669bd4fde2d20f9cf2;\n', '    address public affiliateProgramWalletAddress = 0xd30e8e92ee0cc95a7fefb5eafdd0deb678ab41d7;\n', '    address public shareholdersWalletAddress = 0x56a8330345e75bafbb17443889e19302ba528e7c;\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function COSSToken() {\n', '        revenueShareOwnerAddress = msg.sender;\n', '        balanceOf[icoWalletAddress] = safeMul(icoSold,decimalMultiplier);\n', '        balanceOf[teamWalletAddress] = safeMul(30000000,decimalMultiplier);\n', '        balanceOf[affiliateProgramWalletAddress] = safeMul(10000000,decimalMultiplier);\n', '        balanceOf[shareholdersWalletAddress] = safeMul(5000000,decimalMultiplier);\n', '    }\n', '\n', '    // validates an address - currently only checks that it isn&#39;t null\n', '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        _;\n', '    }\n', '\n', '    function activateRevenueShareReference(uint256 _revenueShareItem) {\n', '        revenueShareList[msg.sender] = _revenueShareItem;\n', '    }\n', '\n', '    function addRevenueShareCurrency(address _currencyAddress,string _currencyName) {\n', '        if (msg.sender == revenueShareOwnerAddress) {\n', '            revenueShareCurrency[_currencyAddress] = _currencyName;\n', '            revenueShareDistribution[_currencyAddress] = 0;\n', '        }\n', '    }\n', '\n', '    function saveRevenueShareDistribution(address _currencyAddress, uint256 _value) {\n', '        if (msg.sender == revenueShareOwnerAddress) {\n', '            revenueShareDistribution[_currencyAddress] = safeAdd(revenueShareDistribution[_currencyAddress], _value);\n', '        }\n', '    }\n', '\n', '    /**\n', '        @dev send coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, false if it wasn&#39;t\n', '    */\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev an account/contract attempts to get the coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _from    source address\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, false if it wasn&#39;t\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        validAddress(_from)\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev allow another account/contract to spend some tokens on your behalf\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        also, to minimize the risk of the approve/transferFrom attack vector\n', '        (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice\n', '        in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value\n', '\n', '        @param _spender approved address\n', '        @param _value   allowance amount\n', '\n', '        @return true if the approval was successful, false if it wasn&#39;t\n', '    */\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        validAddress(_spender)\n', '        returns (bool success)\n', '    {\n', '        // if the allowance isn&#39;t 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', '/*\n', '    Overflow protected math functions\n', '*/\n', 'contract SafeMath {\n', '    /**\n', '        constructor\n', '    */\n', '    function SafeMath() {\n', '    }\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', "    // these functions aren't abstract since the compiler emits automatically generated getter functions as external\n", '    function name() public constant returns (string name) { name; }\n', '    function symbol() public constant returns (string symbol) { symbol; }\n', '    function decimals() public constant returns (uint8 decimals) { decimals; }\n', '    function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '/**\n', '    COSS Token implementation\n', '*/\n', 'contract COSSToken is IERC20Token, SafeMath {\n', "    string public standard = 'COSS';\n", "    string public name = 'COSS';\n", "    string public symbol = 'COSS';\n", '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 54359820;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    mapping (address => uint256) public revenueShareList;\n', '    mapping (address => string) public revenueShareCurrency;\n', '    mapping (address => uint256) public revenueShareDistribution;\n', '\n', '    uint256 public decimalMultiplier = 1000000000000000000;\n', '    uint256 public icoSold = 9359820;\n', '    address public revenueShareOwnerAddress;\n', '    address public icoWalletAddress = 0xbf7aa06109ce182203ee3805614736fe18dead43;\n', '    address public teamWalletAddress = 0x552b3f0c1747cfefc726bc669bd4fde2d20f9cf2;\n', '    address public affiliateProgramWalletAddress = 0xd30e8e92ee0cc95a7fefb5eafdd0deb678ab41d7;\n', '    address public shareholdersWalletAddress = 0x56a8330345e75bafbb17443889e19302ba528e7c;\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function COSSToken() {\n', '        revenueShareOwnerAddress = msg.sender;\n', '        balanceOf[icoWalletAddress] = safeMul(icoSold,decimalMultiplier);\n', '        balanceOf[teamWalletAddress] = safeMul(30000000,decimalMultiplier);\n', '        balanceOf[affiliateProgramWalletAddress] = safeMul(10000000,decimalMultiplier);\n', '        balanceOf[shareholdersWalletAddress] = safeMul(5000000,decimalMultiplier);\n', '    }\n', '\n', "    // validates an address - currently only checks that it isn't null\n", '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        _;\n', '    }\n', '\n', '    function activateRevenueShareReference(uint256 _revenueShareItem) {\n', '        revenueShareList[msg.sender] = _revenueShareItem;\n', '    }\n', '\n', '    function addRevenueShareCurrency(address _currencyAddress,string _currencyName) {\n', '        if (msg.sender == revenueShareOwnerAddress) {\n', '            revenueShareCurrency[_currencyAddress] = _currencyName;\n', '            revenueShareDistribution[_currencyAddress] = 0;\n', '        }\n', '    }\n', '\n', '    function saveRevenueShareDistribution(address _currencyAddress, uint256 _value) {\n', '        if (msg.sender == revenueShareOwnerAddress) {\n', '            revenueShareDistribution[_currencyAddress] = safeAdd(revenueShareDistribution[_currencyAddress], _value);\n', '        }\n', '    }\n', '\n', '    /**\n', '        @dev send coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', "        @return true if the transfer was successful, false if it wasn't\n", '    */\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev an account/contract attempts to get the coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _from    source address\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', "        @return true if the transfer was successful, false if it wasn't\n", '    */\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        validAddress(_from)\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev allow another account/contract to spend some tokens on your behalf\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        also, to minimize the risk of the approve/transferFrom attack vector\n', '        (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice\n', '        in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value\n', '\n', '        @param _spender approved address\n', '        @param _value   allowance amount\n', '\n', "        @return true if the approval was successful, false if it wasn't\n", '    */\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        validAddress(_spender)\n', '        returns (bool success)\n', '    {\n', "        // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal\n", '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}']

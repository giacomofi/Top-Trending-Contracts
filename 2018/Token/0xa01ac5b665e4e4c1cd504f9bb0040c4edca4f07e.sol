['pragma solidity 0.4.25;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// Used for function invoke restriction\n', 'contract Owned {\n', '\n', '    address public owner; // temporary address\n', '\n', '    constructor() internal {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner)\n', '            revert();\n', '        _; // function code inserted here\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner returns (bool success) {\n', '        if (msg.sender != owner)\n', '            revert();\n', '        owner = _newOwner;\n', '        return true;\n', '\n', '    }\n', '}\n', '\n', 'contract ClickGem is Owned {\n', '    using SafeMath for uint256;\n', '\n', '    uint256     public  totalSupply;\n', '    uint8       public  decimals;\n', '    string      public  name;\n', '    string      public  symbol;\n', '    bool        public  tokenIsFrozen;\n', '    bool        public  tokenMintingEnabled;\n', '    bool        public  contractLaunched;\n', '    bool\t\tpublic\tstakingStatus;\n', '\n', '    mapping (address => mapping (address => uint256))   public allowance;\n', '    mapping (address => uint256)                        public balances;\n', '    event Transfer(address indexed _sender, address indexed _recipient, uint256 _amount);\n', '    event Approve(address indexed _owner, address indexed _spender, uint256 _amount);\n', '    event LaunchContract(address indexed _launcher, bool _launched);\n', '    event FreezeTransfers(address indexed _invoker, bool _frozen);\n', '    event UnFreezeTransfers(address indexed _invoker, bool _thawed);\n', '    event MintTokens(address indexed _minter, uint256 _amount, bool indexed _minted);\n', '    event TokenMintingDisabled(address indexed _invoker, bool indexed _disabled);\n', '    event TokenMintingEnabled(address indexed _invoker, bool indexed _enabled);\n', '\n', '\n', '    constructor() public {\n', '        name = "ClickGem Token";\n', '        symbol = "CGMT";\n', '        decimals = 18;\n', '\n', '        totalSupply = 300000000000000000000000000000;\n', '        balances[msg.sender] = totalSupply;\n', '        tokenIsFrozen = false;\n', '        tokenMintingEnabled = false;\n', '        contractLaunched = false;\n', '    }\n', '\n', '\n', '\n', '    /// @notice Used to launch the contract, and enabled token minting\n', '    function launchContract() public onlyOwner {\n', '        require(!contractLaunched);\n', '        tokenIsFrozen = false;\n', '        tokenMintingEnabled = true;\n', '        contractLaunched = true;\n', '        emit LaunchContract(msg.sender, true);\n', '    }\n', '\n', '    function disableTokenMinting() public onlyOwner returns (bool disabled) {\n', '        tokenMintingEnabled = false;\n', '        emit TokenMintingDisabled(msg.sender, true);\n', '        return true;\n', '    }\n', '\n', '    function enableTokenMinting() public onlyOwner returns (bool enabled) {\n', '        tokenMintingEnabled = true;\n', '        emit TokenMintingEnabled(msg.sender, true);\n', '        return true;\n', '    }\n', '\n', '    \n', '\n', '    /// @notice Used to transfer funds\n', '    /// @param _receiver Eth address to send TEMPLATE-TOKENToken tokens too\n', '    /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to send\n', '    function transfer(address _receiver, uint256 _amount)\n', '    public\n', '    returns (bool success)\n', '    {\n', '        require(transferCheck(msg.sender, _receiver, _amount));\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_receiver] = balances[_receiver].add(_amount);\n', '        emit Transfer(msg.sender, _receiver, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice Used to burn tokens and decrease total supply\n', '    /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to burn\n', '    function tokenBurner(uint256 _amount) public\n', '    onlyOwner\n', '    returns (bool burned)\n', '    {\n', '        require(_amount > 0);\n', '        require(totalSupply.sub(_amount) > 0);\n', '        require(balances[msg.sender] > _amount);\n', '        require(balances[msg.sender].sub(_amount) > 0);\n', '        totalSupply = totalSupply.sub(_amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        emit Transfer(msg.sender, 0, _amount);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Low level function Used to create new tokens and increase total supply\n', '    /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to create\n', '\n', '    function tokenMinter(uint256 _amount)\n', '    internal\n', '    view\n', '    returns (bool valid)\n', '    {\n', '        require(tokenMintingEnabled);\n', '        require(_amount > 0);\n', '        require(totalSupply.add(_amount) > 0);\n', '        require(totalSupply.add(_amount) > totalSupply);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice Used to create new tokens and increase total supply\n', '    /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to create\n', '    function tokenFactory(uint256 _amount) public\n', '    onlyOwner\n', '    returns (bool success)\n', '    {\n', '        require(tokenMinter(_amount));\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[msg.sender] = balances[msg.sender].add(_amount);\n', '        emit Transfer(0, msg.sender, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice Reusable code to do sanity check of transfer variables\n', '    function transferCheck(address _sender, address _receiver, uint256 _amount)\n', '    private\n', '    constant\n', '    returns (bool success)\n', '    {\n', '        require(!tokenIsFrozen);\n', '        require(_amount > 0);\n', '        require(_receiver != address(0));\n', '        require(balances[_sender].sub(_amount) >= 0);\n', '        require(balances[_receiver].add(_amount) > 0);\n', '        require(balances[_receiver].add(_amount) > balances[_receiver]);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice Used to retrieve total supply\n', '    function totalSupply()\n', '    public\n', '    constant\n', '    returns (uint256 _totalSupply)\n', '    {\n', '        return totalSupply;\n', '    }\n', '\n', '    /// @notice Used to look up balance of a person\n', '    function balanceOf(address _person)\n', '    public\n', '    constant\n', '    returns (uint256 _balance)\n', '    {\n', '        return balances[_person];\n', '    }\n', '\n', '    function AirDropper(address[] _to, uint256[] _value) public onlyOwner returns (bool) {\n', '        require(_to.length > 0);\n', '        require(_to.length == _value.length);\n', '\n', '        for (uint i = 0; i < _to.length; i++) {\n', '            if (transfer(_to[i], _value[i]) == false) {\n', '                return false;\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice Used to look up the allowance of someone\n', '    function allowance(address _owner, address _spender)\n', '    public\n', '    constant\n', '    returns (uint256 _amount)\n', '    {\n', '        return allowance[_owner][_spender];\n', '    }\n', '}']
['pragma solidity 0.4.25;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// Used for function invoke restriction\n', 'contract Owned {\n', '\n', '    address public owner; // temporary address\n', '\n', '    constructor() internal {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner)\n', '            revert();\n', '        _; // function code inserted here\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner returns (bool success) {\n', '        if (msg.sender != owner)\n', '            revert();\n', '        owner = _newOwner;\n', '        return true;\n', '\n', '    }\n', '}\n', '\n', 'contract ClickGem is Owned {\n', '    using SafeMath for uint256;\n', '\n', '    uint256     public  totalSupply;\n', '    uint8       public  decimals;\n', '    string      public  name;\n', '    string      public  symbol;\n', '    bool        public  tokenIsFrozen;\n', '    bool        public  tokenMintingEnabled;\n', '    bool        public  contractLaunched;\n', '    bool\t\tpublic\tstakingStatus;\n', '\n', '    mapping (address => mapping (address => uint256))   public allowance;\n', '    mapping (address => uint256)                        public balances;\n', '    event Transfer(address indexed _sender, address indexed _recipient, uint256 _amount);\n', '    event Approve(address indexed _owner, address indexed _spender, uint256 _amount);\n', '    event LaunchContract(address indexed _launcher, bool _launched);\n', '    event FreezeTransfers(address indexed _invoker, bool _frozen);\n', '    event UnFreezeTransfers(address indexed _invoker, bool _thawed);\n', '    event MintTokens(address indexed _minter, uint256 _amount, bool indexed _minted);\n', '    event TokenMintingDisabled(address indexed _invoker, bool indexed _disabled);\n', '    event TokenMintingEnabled(address indexed _invoker, bool indexed _enabled);\n', '\n', '\n', '    constructor() public {\n', '        name = "ClickGem Token";\n', '        symbol = "CGMT";\n', '        decimals = 18;\n', '\n', '        totalSupply = 300000000000000000000000000000;\n', '        balances[msg.sender] = totalSupply;\n', '        tokenIsFrozen = false;\n', '        tokenMintingEnabled = false;\n', '        contractLaunched = false;\n', '    }\n', '\n', '\n', '\n', '    /// @notice Used to launch the contract, and enabled token minting\n', '    function launchContract() public onlyOwner {\n', '        require(!contractLaunched);\n', '        tokenIsFrozen = false;\n', '        tokenMintingEnabled = true;\n', '        contractLaunched = true;\n', '        emit LaunchContract(msg.sender, true);\n', '    }\n', '\n', '    function disableTokenMinting() public onlyOwner returns (bool disabled) {\n', '        tokenMintingEnabled = false;\n', '        emit TokenMintingDisabled(msg.sender, true);\n', '        return true;\n', '    }\n', '\n', '    function enableTokenMinting() public onlyOwner returns (bool enabled) {\n', '        tokenMintingEnabled = true;\n', '        emit TokenMintingEnabled(msg.sender, true);\n', '        return true;\n', '    }\n', '\n', '    \n', '\n', '    /// @notice Used to transfer funds\n', '    /// @param _receiver Eth address to send TEMPLATE-TOKENToken tokens too\n', '    /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to send\n', '    function transfer(address _receiver, uint256 _amount)\n', '    public\n', '    returns (bool success)\n', '    {\n', '        require(transferCheck(msg.sender, _receiver, _amount));\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_receiver] = balances[_receiver].add(_amount);\n', '        emit Transfer(msg.sender, _receiver, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice Used to burn tokens and decrease total supply\n', '    /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to burn\n', '    function tokenBurner(uint256 _amount) public\n', '    onlyOwner\n', '    returns (bool burned)\n', '    {\n', '        require(_amount > 0);\n', '        require(totalSupply.sub(_amount) > 0);\n', '        require(balances[msg.sender] > _amount);\n', '        require(balances[msg.sender].sub(_amount) > 0);\n', '        totalSupply = totalSupply.sub(_amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        emit Transfer(msg.sender, 0, _amount);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Low level function Used to create new tokens and increase total supply\n', '    /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to create\n', '\n', '    function tokenMinter(uint256 _amount)\n', '    internal\n', '    view\n', '    returns (bool valid)\n', '    {\n', '        require(tokenMintingEnabled);\n', '        require(_amount > 0);\n', '        require(totalSupply.add(_amount) > 0);\n', '        require(totalSupply.add(_amount) > totalSupply);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice Used to create new tokens and increase total supply\n', '    /// @param _amount The amount of TEMPLATE-TOKENToken tokens in wei to create\n', '    function tokenFactory(uint256 _amount) public\n', '    onlyOwner\n', '    returns (bool success)\n', '    {\n', '        require(tokenMinter(_amount));\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[msg.sender] = balances[msg.sender].add(_amount);\n', '        emit Transfer(0, msg.sender, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice Reusable code to do sanity check of transfer variables\n', '    function transferCheck(address _sender, address _receiver, uint256 _amount)\n', '    private\n', '    constant\n', '    returns (bool success)\n', '    {\n', '        require(!tokenIsFrozen);\n', '        require(_amount > 0);\n', '        require(_receiver != address(0));\n', '        require(balances[_sender].sub(_amount) >= 0);\n', '        require(balances[_receiver].add(_amount) > 0);\n', '        require(balances[_receiver].add(_amount) > balances[_receiver]);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice Used to retrieve total supply\n', '    function totalSupply()\n', '    public\n', '    constant\n', '    returns (uint256 _totalSupply)\n', '    {\n', '        return totalSupply;\n', '    }\n', '\n', '    /// @notice Used to look up balance of a person\n', '    function balanceOf(address _person)\n', '    public\n', '    constant\n', '    returns (uint256 _balance)\n', '    {\n', '        return balances[_person];\n', '    }\n', '\n', '    function AirDropper(address[] _to, uint256[] _value) public onlyOwner returns (bool) {\n', '        require(_to.length > 0);\n', '        require(_to.length == _value.length);\n', '\n', '        for (uint i = 0; i < _to.length; i++) {\n', '            if (transfer(_to[i], _value[i]) == false) {\n', '                return false;\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice Used to look up the allowance of someone\n', '    function allowance(address _owner, address _spender)\n', '    public\n', '    constant\n', '    returns (uint256 _amount)\n', '    {\n', '        return allowance[_owner][_spender];\n', '    }\n', '}']

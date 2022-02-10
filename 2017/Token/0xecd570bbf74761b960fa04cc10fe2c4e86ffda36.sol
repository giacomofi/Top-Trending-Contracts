['pragma solidity ^0.4.18;\n', '\n', '/// Implements ERC20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', 'interface ERC20Token {\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    function transfer(address _to, uint _value) public returns (bool);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool);\n', '    function approve(address _spender, uint _value) public returns (bool);\n', '    function balanceOf(address _owner) public view returns (uint);\n', '    function allowance(address _owner, address _spender) public view returns (uint);    \n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable()\n', '        public\n', '    {        \n', '        owner = msg.sender;\n', '    }\n', ' \n', '    modifier onlyOwner {\n', '        assert(msg.sender == owner);    \n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner)\n', '        public\n', '        onlyOwner\n', '    {\n', '        owner = newOwner;\n', '    } \n', '}\n', '\n', '\n', 'contract Freezable is Ownable {\n', '\n', '    mapping (address => bool) public frozenAccount;      \n', '    \n', '    modifier onlyUnfrozen(address _target) {\n', '        assert(!isFrozen(_target));\n', '        _;\n', '    }\n', '    \n', '    // @dev Owners funds are frozen on token creation\n', '    function isFrozen(address _target)\n', '        public\n', '        view\n', '        returns (bool)\n', '    {\n', '        return frozenAccount[_target];\n', '    }\n', '}\n', '\n', 'contract Token is ERC20Token, Freezable {\n', '    /*\n', '     *  Storage\n', '     */\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowances; \n', '    mapping (address => string) public data;\n', '    uint    public totalSupply;\n', '    uint    public timeTransferbleUntil = 1538262000;                        // Transferable until 29/09/2018 23:00 pm UTC\n', '    bool    public stopped = false;\n', ' \n', '    event Burn(address indexed from, uint256 value, string data);\n', '    event LogStop();\n', '\n', '    modifier transferable() {\n', '        assert(!stopped);\n', '        _;\n', '    }\n', '\n', '    /*\n', '     *  Public functions\n', '     */\n', "    /// @dev Transfers sender's tokens to a given address. Returns success\n", '    /// @param _to Address of token receiver\n', '    /// @param _value Number of tokens to transfer\n', '    /// @return Returns success of function call\n', '    function transfer(address _to, uint _value)\n', '        public      \n', '        onlyUnfrozen(msg.sender)                                           \n', '        transferable()\n', '        returns (bool)        \n', '    {                         \n', '        assert(_to != 0x0);                                                // Prevent transfer to 0x0 address. Use burn() instead\n', '        assert(balances[msg.sender] >= _value);                            // Check if the sender has enough\n', '        assert(!isFrozen(_to));                                            // Do not allow transfers to frozen accounts\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value); // Subtract from the sender\n', '        balances[_to] = SafeMath.add(balances[_to], _value);               // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                                 // Notify anyone listening that this transfer took place\n', '        return true;       \n', '    }\n', '\n', '    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success\n', '    /// @param _from Address from where tokens are withdrawn\n', '    /// @param _to Address to where tokens are sent\n', '    /// @param _value Number of tokens to transfer\n', '    /// @return Returns success of function call\n', '    function transferFrom(address _from, address _to, uint _value)\n', '        public    \n', '        onlyUnfrozen(_from)                                               // Owners can never transfer funds\n', '        transferable()                 \n', '        returns (bool)\n', '    {        \n', '        assert(_to != 0x0);                                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        assert(balances[_from] >= _value);                                // Check if the sender has enough\n', '        assert(_value <= allowances[_from][msg.sender]);                  // Check allowance\n', '        assert(!isFrozen(_to));                                           // Do not allow transfers to frozen accounts\n', '        balances[_from] = SafeMath.sub(balances[_from], _value);          // Subtract from the sender\n', '        balances[_to] = SafeMath.add(balances[_to], _value);              // Add the same to the recipient\n', '        allowances[_from][msg.sender] = SafeMath.sub(allowances[_from][msg.sender], _value); \n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @dev Sets approved amount of tokens for spender. Returns success\n', '    /// @param _spender Address of allowed account\n', '    /// @param _value Number of approved tokens\n', '    /// @return Returns success of function call    \n', '    function approve(address _spender, uint _value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowances[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @dev Returns number of allowed tokens for given address\n', '    /// @param _owner Address of token owner\n', '    /// @param _spender Address of token spender\n', '    /// @return Returns remaining allowance for spender    \n', '    function allowance(address _owner, address _spender)\n', '        public\n', '        view\n', '        returns (uint)\n', '    {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address\n', '    /// @param _owner Address of token owner\n', '    /// @return Returns balance of owner    \n', '    function balanceOf(address _owner)\n', '        public\n', '        view\n', '        returns (uint)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // @title Burns tokens\n', '    // @dev remove `_value` tokens from the system irreversibly     \n', '    // @param _value the amount of tokens to burn   \n', '    function burn(uint256 _value, string _data) \n', '        public \n', '        returns (bool success) \n', '    {\n', '        assert(_value > 0);                                                // Amount must be greater than zero\n', '        assert(balances[msg.sender] >= _value);                            // Check if the sender has enough\n', '        uint previousTotal = totalSupply;                                  // Start integrity check\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value); // Subtract from the sender\n', '        data[msg.sender] = _data;                                          // Additional data\n', '        totalSupply = SafeMath.sub(totalSupply, _value);                   // Updates totalSupply\n', '        assert(previousTotal - _value == totalSupply);                     // End integrity check \n', '        Burn(msg.sender, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    // Anyone can freeze the token after transfer time has expired\n', '    function stop() \n', '        public\n', '    {\n', '        assert(now > timeTransferbleUntil);\n', '        stopped = true;\n', '        LogStop();\n', '    }\n', '\n', '    function totalSupply() \n', '        constant public \n', '        returns (uint) \n', '    {\n', '        return totalSupply;\n', '    }\n', '\n', '    function getData(address addr) \n', '        public \n', '        view\n', '        returns (string) \n', '    {\n', '        return data[addr];\n', '    }    \n', '}\n', '\n', '\n', '// Contract Owner 0xb42db275AdCCd23e2cB52CfFc2D4Fe984fbF53B2     \n', 'contract STP is Token {\n', '    string  public name = "STASHPAY";\n', '    string  public symbol = "STP";\n', '    uint8   public decimals = 8;\n', '    uint8   public publicKeySize = 65;\n', '    address public sale = 0xB155c16c13FC1eD2F015e24D6C7Ae8Cc38cea74E;\n', '    address public adviserAndBounty = 0xf40bF198eD3bE9d3E1312d2717b964b377135728;    \n', '    mapping (address => string) public publicKeys;\n', '    uint256 constant D160 = 0x0010000000000000000000000000000000000000000;    \n', '\n', '    event RegisterKey(address indexed _from, string _publicKey);\n', '    event ModifyPublicKeySize(uint8 _size);\n', '\n', '    function STP()\n', '    public \n', '    {             \n', '        uint256[29] memory owners = [\n', '            uint256(0xb5e620f480007f0dfc26a56b0f7ccd8100eaf31b75dd40bae01f),\n', '            uint256(0x162b3f376600078c63f73a2f46c19a4cd91e700203bbbe4084093),\n', '            uint256(0x16bcc41e900004ae21e3c9b0e63dbc2832f1fa3e6e4dd60f42ae1),\n', '            uint256(0x1c6bf52634000b9b206c23965553889ebdaee326d4da4a457b9b1),\n', '            uint256(0x16bcc41e90000d26061a8d47cc712c61a8fa23ce21d593e50f668),\n', '            uint256(0x110d9316ec000d69106be0299d0a83b9a9e32f2df85ec7739fa59),\n', '            uint256(0x16bcc41e90000d6d813fd0394bfec48996e20d8fbcf55a003c19a),\n', '            uint256(0x1c6bf52634000e34dc2c4481561224114ad004c824b1f9e142e31),\n', '            uint256(0x110d9316ec0006e19b79b974fa039c1356f6814da22b0a04e8d29),\n', '            uint256(0x16bcc41e900005d2f999136e12e54f4a9a873a9d9ab7407591249),\n', '            uint256(0x110d9316ec0002b0013a364a997b9856127fd0ababef72baec159),\n', '            uint256(0x16bcc41e90000db46260f78efa6c904d7dafc5c584ca34d5234be),\n', '            uint256(0x1c6bf5263400073a4077adf235164f4944f138fc9d982ea549eba),\n', '            uint256(0x9184e72a0003617280cabfe0356a2af3cb4f652c3aca3ab8216),\n', '            uint256(0xb5e620f480003d106c1220c49f75ddb8a475b73a1517cef163f6),\n', '            uint256(0x9184e72a000d6aaf14fee58fd90e6518179e94f02b5e0098a78),\n', '            uint256(0x162b3f37660009c98c23e430b4270f47685e46d651b9150272b16),\n', '            uint256(0xb5e620f48000cc3e7d55bba108b07c08d014f13fe0ee5c09ec08),\n', '            uint256(0x110d9316ec000e4a92d9c2c31789250956b1b0b439cf72baf8a27),\n', '            uint256(0x16bcc41e900002edc2b7f7191cf9414d9bf8febdd165b0cd91ee1),\n', '            uint256(0x110d9316ec000332f79ebb69d00cb3f13fcb2be185ed944f64298),\n', '            uint256(0x221b262dd80005594aae7ae31a3316691ab7a11de3ddee2f015e0),\n', '            uint256(0x1c6bf52634000c08b91c50ed4303d1b90ffd47237195e4bfc165e),\n', '            uint256(0x110d9316ec000bf6f7c6a13b9629b673c023e54fba4c2cd4ccbba),\n', '            uint256(0x16bcc41e90000629048b47ed4fb881bacfb7ca85e7275cd663cf7),\n', '            uint256(0x110d9316ec000451861e95aa32ce053f15f6ae013d1eface88e9e),\n', '            uint256(0x16bcc41e9000094d79beb8c57e54ff3fce49ae35078c6df228b9c),\n', '            uint256(0x1c6bf52634000e2b1430b79b5be8bf3c7d70eb4faf36926b369f3),\n', '            uint256(0xb5e620f4800025b772bda67719d2ba404c04fa4390443bf993ed)\n', '        ];\n', '\n', '        /* \n', '            Token Distrubution\n', '            -------------------\n', '            500M Total supply\n', '            72% Token Sale\n', '            20% Founders (frozen for entire duration of contract)\n', '            8% Bounty and advisters\n', '        */\n', '\n', '        totalSupply = 500000000 * 10**uint256(decimals); \n', '        balances[sale] = 360000000 * 10**uint256(decimals); \n', '        balances[adviserAndBounty] = 40000000 * 10**uint256(decimals);\n', '            \n', '        Transfer(0, sale, balances[sale]);\n', '        Transfer(0, adviserAndBounty, balances[adviserAndBounty]);\n', '        \n', '        /* \n', '            Founders are provably frozen for duration of contract            \n', '        */\n', '        uint assignedTokens = balances[sale] + balances[adviserAndBounty];\n', '        for (uint i = 0; i < owners.length; i++) {\n', '            address addr = address(owners[i] & (D160 - 1));                    // get address\n', '            uint256 amount = owners[i] / D160;                                 // get amount\n', '            balances[addr] = SafeMath.add(balances[addr], amount);             // update balance            \n', '            assignedTokens = SafeMath.add(assignedTokens, amount);             // keep track of total assigned\n', '            frozenAccount[addr] = true;                                        // Owners funds are provably frozen for duration of contract\n', '            Transfer(0, addr, amount);                                         // transfer the tokens\n', '        }        \n', '        /*\n', '            balance check \n', '        */\n', '        require(assignedTokens == totalSupply);             \n', '    }  \n', '    \n', '    function registerKey(string publicKey)\n', '    public\n', '    transferable\n', '    { \n', '        assert(balances[msg.sender] > 0);\n', '        assert(bytes(publicKey).length <= publicKeySize);\n', '              \n', '        publicKeys[msg.sender] = publicKey; \n', '        RegisterKey(msg.sender, publicKey);    \n', '    }           \n', '  \n', '    function modifyPublicKeySize(uint8 _publicKeySize)\n', '    public\n', '    onlyOwner\n', '    { \n', '        publicKeySize = _publicKeySize;\n', '    }\n', '\n', '    function multiDistribute(uint256[] data) \n', '    public\n', '    onlyUnfrozen(sale)\n', '    onlyOwner \n', '    {\n', '      for (uint256 i = 0; i < data.length; i++) {\n', '        address addr = address(data[i] & (D160 - 1));\n', '        uint256 amount = data[i] / D160;\n', '        balances[sale] -= amount;                        \n', '        balances[addr] += amount;                                       \n', '        Transfer(sale, addr, amount);    \n', '      }\n', '    }\n', '\n', '    function multiDistributeAdviserBounty(uint256[] data, bool freeze) \n', '    public\n', '    onlyOwner\n', '    {\n', '        for (uint256 i = 0; i < data.length; i++) {\n', '            address addr = address(data[i] & (D160 - 1));\n', '            uint256 amount = data[i] / D160;\n', '            distributeAdviserBounty(addr, amount, freeze);\n', '        }\n', '    }\n', '   \n', '    function distributeAdviserBounty(address addr, uint256 amount, bool freeze)\n', '    public        \n', '    onlyOwner \n', '    {   \n', '        // can only freeze when no balance exists        \n', '        frozenAccount[addr] = freeze && balances[addr] == 0;\n', '\n', '        balances[addr] = SafeMath.add(balances[addr], amount);\n', '        balances[adviserAndBounty] = SafeMath.sub(balances[adviserAndBounty], amount);\n', '        Transfer(adviserAndBounty, addr, amount);           \n', '    }\n', '\n', '    /// @dev when token distrubution is complete freeze any remaining tokens\n', '    function distributionComplete()\n', '    public\n', '    onlyOwner\n', '    {\n', '        frozenAccount[sale] = true;\n', '    }\n', '\n', '    function setName(string _name)\n', '    public \n', '    onlyOwner \n', '    {\n', '        name = _name;\n', '    }\n', '\n', '    function setSymbol(string _symbol)\n', '    public \n', '    onlyOwner \n', '    {\n', '        symbol = _symbol;\n', '    }\n', '}']
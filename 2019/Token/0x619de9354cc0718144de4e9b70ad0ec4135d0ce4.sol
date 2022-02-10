['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-07\n', '*/\n', '\n', 'pragma solidity >=0.4.22 <0.6.0;\n', '\n', 'contract IERC20 {\n', '    function totalSupply() constant public returns (uint256);\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remianing);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/*\n', 'CREATED BY ANDRAS SZEKELY, SaiTech (c) 2019\n', '\n', '*/ \n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\tuint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'contract LYCCoin is IERC20, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    uint public _totalSupply = 0;\n', '    uint public constant INITIAL_SUPPLY = 175000000000000000000000000;\n', '    uint public MAXUM_SUPPLY =            175000000000000000000000000;\n', '    uint256 public _currentSupply = 0;\n', '\n', '    string public constant symbol = "LYC";\n', '    string public constant name = "LYCCoin";\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 public RATE;\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\tmapping (address => uint256) public freezeOf;\n', '    mapping(address => bool) whitelisted;\n', '    mapping(address => bool) blockListed;\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event Freeze(address indexed from, uint256 value);\n', '    event Unfreeze(address indexed from, uint256 value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '    event LogUserAdded(address user);\n', '    event LogUserRemoved(address user);\n', '\n', '\n', '\n', '\n', '    constructor() public {\n', '        setRate(1);\n', '        _totalSupply = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    function createTokens() payable public {\n', '        require(msg.value > 0);\n', '        require(whitelisted[msg.sender]);\n', '\n', '        uint256 tokens = msg.value.mul(RATE);\n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '        _totalSupply = _totalSupply.add(tokens);\n', '\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '    function totalSupply() constant public returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '\n', '        require(\n', '            balances[msg.sender] >= _value\n', '            && _value > 0\n', '            && !blockListed[_to]\n', '            && !blockListed[msg.sender]\n', '        );\n', '\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balances[msg.sender] + balances[_to];\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);                     // Subtract from the sender\n', '        balances[_to] = SafeMath.add(balances[_to], _value);                            // Add the same to the recipient\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[msg.sender] + balances[_to] == previousBalances);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(\n', '            balances[msg.sender] >= _value\n', '            && balances[_from] >= _value\n', '            && _value > 0\n', '            && whitelisted[msg.sender]\n', '            && !blockListed[_to]\n', '            && !blockListed[msg.sender]\n', '        );\n', '        balances[_from] = SafeMath.sub(balances[_from], _value);                           // Subtract from the sender\n', '        balances[_to] = SafeMath.add(balances[_to], _value);                             // Add the same to the recipient\n', '        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        whitelisted[_spender] = true;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remianing) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function getRate() public constant returns (uint256) {\n', '        return RATE;\n', '    }\n', '\n', '    function setRate(uint256 _rate) public returns (bool success) {\n', '        RATE = _rate;\n', '        return true;\n', '    }\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    modifier hasMintPermission() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {\n', '        uint256 tokens = _amount.mul(RATE);\n', '        require(\n', '            _currentSupply.add(tokens) < MAXUM_SUPPLY\n', '            && whitelisted[msg.sender]\n', '            && !blockListed[_to]\n', '        );\n', '\n', '        if (_currentSupply >= INITIAL_SUPPLY) {\n', '            _totalSupply = _totalSupply.add(tokens);\n', '        }\n', '\n', '        _currentSupply = _currentSupply.add(tokens);\n', '        balances[_to] = balances[_to].add(tokens);\n', '        emit Mint(_to, tokens);\n', '        emit Transfer(address(0), _to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '\n', '    // Add a user to the whitelist\n', '    function addUser(address user) onlyOwner public {\n', '        whitelisted[user] = true;\n', '        emit LogUserAdded(user);\n', '    }\n', '\n', '    // Remove an user from the whitelist\n', '    function removeUser(address user) onlyOwner public {\n', '        whitelisted[user] = false;\n', '        emit LogUserRemoved(user);\n', '    }\n', '\n', '    function getCurrentOwnerBallence() constant public returns (uint256) {\n', '        return balances[msg.sender];\n', '    }\n', '\n', '    function addBlockList(address wallet) onlyOwner public {\n', '        blockListed[wallet] = true;\n', '    }\n', '\n', '    function removeBlockList(address wallet) onlyOwner public {\n', '        blockListed[wallet] = false;\n', '    }\n', '\n', ' \n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);           // Subtract from the sender\n', '        _totalSupply = SafeMath.sub(_totalSupply,_value);                                // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowed[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        _totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '\tfunction freeze(uint256 _value) onlyOwner public returns (bool success) {\n', '        if (balances[msg.sender] < _value) revert();            // Check if the sender has enough\n', '\t\tif (_value <= 0) revert(); \n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);                      // Subtract from the sender\n', '        freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value);                        // Updates totalSupply\n', '        emit Freeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction unfreeze(uint256 _value) onlyOwner public returns (bool success) {\n', '        if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough\n', '\t\tif (_value <= 0) revert(); \n', '        freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value);                      // Subtract from the sender\n', '\t\tbalances[msg.sender] = SafeMath.add(balances[msg.sender], _value);\n', '        emit Unfreeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity >=0.4.22 <0.6.0;\n', '\n', 'contract IERC20 {\n', '    function totalSupply() constant public returns (uint256);\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remianing);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/*\n', 'CREATED BY ANDRAS SZEKELY, SaiTech (c) 2019\n', '\n', '*/ \n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\tuint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'contract LYCCoin is IERC20, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    uint public _totalSupply = 0;\n', '    uint public constant INITIAL_SUPPLY = 175000000000000000000000000;\n', '    uint public MAXUM_SUPPLY =            175000000000000000000000000;\n', '    uint256 public _currentSupply = 0;\n', '\n', '    string public constant symbol = "LYC";\n', '    string public constant name = "LYCCoin";\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 public RATE;\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\tmapping (address => uint256) public freezeOf;\n', '    mapping(address => bool) whitelisted;\n', '    mapping(address => bool) blockListed;\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event Freeze(address indexed from, uint256 value);\n', '    event Unfreeze(address indexed from, uint256 value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '    event LogUserAdded(address user);\n', '    event LogUserRemoved(address user);\n', '\n', '\n', '\n', '\n', '    constructor() public {\n', '        setRate(1);\n', '        _totalSupply = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    function createTokens() payable public {\n', '        require(msg.value > 0);\n', '        require(whitelisted[msg.sender]);\n', '\n', '        uint256 tokens = msg.value.mul(RATE);\n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '        _totalSupply = _totalSupply.add(tokens);\n', '\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '    function totalSupply() constant public returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '\n', '        require(\n', '            balances[msg.sender] >= _value\n', '            && _value > 0\n', '            && !blockListed[_to]\n', '            && !blockListed[msg.sender]\n', '        );\n', '\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balances[msg.sender] + balances[_to];\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);                     // Subtract from the sender\n', '        balances[_to] = SafeMath.add(balances[_to], _value);                            // Add the same to the recipient\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[msg.sender] + balances[_to] == previousBalances);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(\n', '            balances[msg.sender] >= _value\n', '            && balances[_from] >= _value\n', '            && _value > 0\n', '            && whitelisted[msg.sender]\n', '            && !blockListed[_to]\n', '            && !blockListed[msg.sender]\n', '        );\n', '        balances[_from] = SafeMath.sub(balances[_from], _value);                           // Subtract from the sender\n', '        balances[_to] = SafeMath.add(balances[_to], _value);                             // Add the same to the recipient\n', '        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        whitelisted[_spender] = true;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remianing) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function getRate() public constant returns (uint256) {\n', '        return RATE;\n', '    }\n', '\n', '    function setRate(uint256 _rate) public returns (bool success) {\n', '        RATE = _rate;\n', '        return true;\n', '    }\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    modifier hasMintPermission() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {\n', '        uint256 tokens = _amount.mul(RATE);\n', '        require(\n', '            _currentSupply.add(tokens) < MAXUM_SUPPLY\n', '            && whitelisted[msg.sender]\n', '            && !blockListed[_to]\n', '        );\n', '\n', '        if (_currentSupply >= INITIAL_SUPPLY) {\n', '            _totalSupply = _totalSupply.add(tokens);\n', '        }\n', '\n', '        _currentSupply = _currentSupply.add(tokens);\n', '        balances[_to] = balances[_to].add(tokens);\n', '        emit Mint(_to, tokens);\n', '        emit Transfer(address(0), _to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '\n', '    // Add a user to the whitelist\n', '    function addUser(address user) onlyOwner public {\n', '        whitelisted[user] = true;\n', '        emit LogUserAdded(user);\n', '    }\n', '\n', '    // Remove an user from the whitelist\n', '    function removeUser(address user) onlyOwner public {\n', '        whitelisted[user] = false;\n', '        emit LogUserRemoved(user);\n', '    }\n', '\n', '    function getCurrentOwnerBallence() constant public returns (uint256) {\n', '        return balances[msg.sender];\n', '    }\n', '\n', '    function addBlockList(address wallet) onlyOwner public {\n', '        blockListed[wallet] = true;\n', '    }\n', '\n', '    function removeBlockList(address wallet) onlyOwner public {\n', '        blockListed[wallet] = false;\n', '    }\n', '\n', ' \n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);           // Subtract from the sender\n', '        _totalSupply = SafeMath.sub(_totalSupply,_value);                                // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        _totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '\tfunction freeze(uint256 _value) onlyOwner public returns (bool success) {\n', '        if (balances[msg.sender] < _value) revert();            // Check if the sender has enough\n', '\t\tif (_value <= 0) revert(); \n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);                      // Subtract from the sender\n', '        freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value);                        // Updates totalSupply\n', '        emit Freeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction unfreeze(uint256 _value) onlyOwner public returns (bool success) {\n', '        if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough\n', '\t\tif (_value <= 0) revert(); \n', '        freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value);                      // Subtract from the sender\n', '\t\tbalances[msg.sender] = SafeMath.add(balances[msg.sender], _value);\n', '        emit Unfreeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '}']
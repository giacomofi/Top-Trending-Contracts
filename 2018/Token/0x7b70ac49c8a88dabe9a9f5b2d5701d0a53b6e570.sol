['pragma solidity ^0.4.18;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint256);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract VanityToken is owned, ERC20Interface {\n', '    // Public variables of the token\n', '    string  public name = "Vanity Token";\n', '    string  public symbol = "VNT";\n', '    uint8   public decimals = 18;\n', '    \n', '    uint256 public currentSupply = 0;\n', '    uint256 public maxSupply = 1333337;\n', '    uint256 public bonusAmtThreshold = 20000;\n', '    uint256 public bonusSignalValue = 0.001 ether;\n', '    uint256 public _totalSupply;\n', '    uint256 public tokenXchangeRate ;\n', '    uint    public icoStartTime;\n', '    bool    public purchasingAllowed = false;\n', '    bool    public demo = false;\n', '\n', '    uint    public windowBonusMax = 43200 seconds;\n', '    uint    public windowBonusMin = 10800 seconds; \n', '    uint    public windowBonusStep1 = 21600 seconds;\n', '    uint    public windowBonusStep2 = 28800 seconds;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public _balanceOf;\n', '    mapping (address => uint256) public bonusOf;\n', '    mapping (address => uint) public timeBought;\n', '    mapping (address => uint256) public transferredAtSupplyValue;\n', '    mapping (address => mapping (address => uint256)) public _allowance;\n', '\n', '\n', '    function setBonuses(bool _d) onlyOwner public {\n', '        if (_d == true) {\n', '            windowBonusMax = 20 minutes;\n', '            windowBonusMin = 30 seconds;\n', '            windowBonusStep1 = 60 seconds;\n', '            windowBonusStep2 = 120 seconds;\n', '            bonusAmtThreshold = 500;\n', '            maxSupply = 13337;\n', '        } else {\n', '            windowBonusMax = 12 hours;\n', '            windowBonusMin = 3 hours;\n', '            windowBonusStep1 = 6 hours;\n', '            windowBonusStep2 = 8 hours;\n', '            bonusAmtThreshold = 20000;\n', '            maxSupply = 1333337;\n', '        }\n', '        demo = _d;\n', '    }\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '     modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4 || msg.data.length == 4);\n', '        _;\n', '    }\n', ' \n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function VanityToken() public payable {\n', '        tokenXchangeRate = 300;\n', '        _balanceOf[address(this)] = 0;\n', '        owner = msg.sender;     \n', '        setBonuses(false);      \n', '        //enablePurchasing();              \n', '        _totalSupply = maxSupply * 10 ** uint256(decimals);  \n', '    }\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256) { return _balanceOf[_owner] ; }\n', '\n', '    function allowance(address tokenOwner, address spender) onlyPayloadSize(2 * 32) public constant returns (uint remaining) {\n', '        return _allowance[tokenOwner][spender];\n', '    }\n', '\n', '    function kill() public {\n', '        if (msg.sender == owner) \n', '            selfdestruct(owner);\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint256 _value, uint256 _bonusValue) onlyPayloadSize(4*32) internal returns (bool) {\n', '\n', '        if (_value == 0 && _bonusValue == 0) {return false;}\n', '        if (_value!=0&&_bonusValue!=0) {return false;}  \n', '\n', '        require(_to != 0x0);\n', '       \n', '        // Check for overflows[]       \n', '        require(_balanceOf[_to] + _value >= _balanceOf[_to]);\n', '        require(bonusOf[_to] + _bonusValue >= bonusOf[_to]);\n', '        \n', '        if (_value > 0) {\n', '            _balanceOf[_from] += _value;\n', '            _balanceOf[_to] += _value;\n', '            timeBought[_to] = now;\n', '            Transfer(_from, _to, _value);\n', '        } else if (_bonusValue > 0) {\n', '            _balanceOf[_from] += _bonusValue;\n', '            _balanceOf[_to] += _bonusValue;\n', '            bonusOf[_to] += _bonusValue;     \n', '            timeBought[_to] = 0;\n', '            Transfer(_from, _to, _bonusValue);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    function buy() public payable {\n', '        require(purchasingAllowed);\n', '        require(msg.value > 0);\n', '        require(msg.value >= 0.01 ether || msg.value == bonusSignalValue);\n', '        _buy(msg.value);\n', '    }\n', '\n', '    function() public payable {\n', '        buy();\n', '    }\n', '\n', '    function _buy(uint256 value) internal {\n', '\n', '        uint tPassed = now - icoStartTime;\n', '        if (tPassed <= 3 days) {\n', '            tokenXchangeRate = 300;\n', '        } else if (tPassed <= 5 days) {\n', '            tokenXchangeRate = 250;\n', '        } else if (tPassed <= 7 days) {\n', '            tokenXchangeRate = 200;\n', '        } else if (tPassed >= 10 days) {\n', '          tokenXchangeRate = 100;\n', '        }\n', '\n', '        bool requestedBonus = false;\n', '        uint256 amount = value * tokenXchangeRate;\n', '        \n', '        if (value == bonusSignalValue) {\n', '            require (timeBought[msg.sender] > 0 && transferredAtSupplyValue[msg.sender] > 0);\n', '\n', '            uint dif = now - timeBought[msg.sender];\n', '            //verify window\n', '            require (dif <= windowBonusMax && dif >= windowBonusMin); \n', '            requestedBonus = true;\n', '            amount = _balanceOf[msg.sender] - bonusOf[msg.sender];\n', '            assert (amount > 0);\n', '\n', '            if (dif >= windowBonusStep2) {\n', '                amount = amount * 3;\n', '            } else if (dif >= windowBonusStep1) {\n', '                amount = amount * 2;\n', '            } \n', '\n', '            if (_balanceOf[address(this)] - transferredAtSupplyValue[msg.sender] < bonusAmtThreshold) {\n', '                owner.transfer(value);\n', '                return;\n', '           }\n', '        }\n', '\n', '        uint256 newBalance = _balanceOf[address(this)] + amount;\n', '        require (newBalance <= _totalSupply); \n', '        owner.transfer(value);\n', '\n', '        currentSupply = newBalance;\n', '        transferredAtSupplyValue[msg.sender] = currentSupply;\n', '\n', '        if (requestedBonus == false) {\n', '            _transfer(address(this), msg.sender, amount, 0);\n', '        } else {\n', '            _transfer(address(this), msg.sender, 0, amount);\n', '        }\n', '       \n', '    }\n', '    \n', ' \n', '   /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '       return _transfer(msg.sender, _to, _value, 0);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= _allowance[_from][msg.sender]);     // Check _allowance\n', '        _allowance[_from][msg.sender] -= _value;\n', '        return _transfer(_from, _to, _value, 0);\n', '    }\n', '\n', '    /**\n', '     * Set _allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        _allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(_balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        _balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        _totalSupply -= _value;                      // Updates _totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnTokens(uint256 _value) onlyOwner public returns (bool success) {\n', '        require(_balanceOf[address(this)] >= _value);   // Check if the sender has enough\n', '        _balanceOf[address(this)] -= _value;            // Subtract from the sender\n', '        _totalSupply -= _value;                      // Updates _totalSupply\n', '        if (currentSupply > _totalSupply) {\n', '            currentSupply = _totalSupply;\n', '        }\n', '        Burn(address(this), _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(_balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= _allowance[_from][msg.sender]);    // Check _allowance\n', '        _balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        _allowance[_from][msg.sender] -= _value;             // Subtract from the sender's _allowance\n", '        _totalSupply -= _value;                              // Update _totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '     function enablePurchasing() onlyOwner public {\n', '        purchasingAllowed = true;\n', '        icoStartTime = now;\n', '    }\n', '\n', '    function disablePurchasing() onlyOwner public {\n', '        purchasingAllowed = false;\n', '    }\n', '\n', '    \n', '\n', '}']
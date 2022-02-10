['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', ' \n', '}\n', '\n', 'contract QUC is SafeMath{\n', '    string  public constant name = "QUCash";\n', '    string  public constant symbol = "QUC";\n', '    uint8   public constant decimals = 18;\n', '\n', '    uint256 public totalSupply = 10000000000 * (10 ** uint256(decimals));\n', '\taddress public owner;\n', '\n', '    uint256 public buyPrice = 100000;\n', '    bool public crowdsaleClosed;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\tmapping (address => uint256) public freezeOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\t\n', '\t/* This notifies clients about the amount frozen */\n', '    event Freeze(address indexed from, uint256 value);\n', '\t\n', '\t/* This notifies clients about the amount unfrozen */\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor() public {        \n', '        balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens\n', '\t\towner = msg.sender;\n', '        emit Transfer(0x0, msg.sender, totalSupply);\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        if (_to == 0x0)  revert();                               // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\tif (_value <= 0)  revert(); \n', '        if (balanceOf[msg.sender] < _value)  revert();           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to])  revert(); // Check for overflows\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient\n', '        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '        return true;\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '\t\tif (_value <= 0)  revert(); \n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '       \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (_to == 0x0)  revert();                                // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\tif (_value <= 0)  revert(); \n', '        if (balanceOf[_from] < _value)  revert();                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to])  revert();  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender])  revert();     // Check allowance\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        if (balanceOf[msg.sender] < _value)  revert();            // Check if the sender has enough\n', '\t\tif (_value <= 0)  revert(); \n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender\n', '        totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction freeze(uint256 _value) public returns (bool success) {\n', '        if (balanceOf[msg.sender] < _value)  revert();            // Check if the sender has enough\n', '\t\tif (_value <= 0)  revert(); \n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender\n', '        freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply\n', '        emit Freeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction unfreeze(uint256 _value) public returns (bool success) {\n', '        if (freezeOf[msg.sender] < _value)  revert();            // Check if the sender has enough\n', '\t\tif (_value <= 0)  revert(); \n', '        freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender\n', '\t\tbalanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);\n', '        emit Unfreeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    \t// transfer balance to owner\n', '\tfunction withdrawEther(uint256 amount) public  {\n', '\t\tif(msg.sender != owner) revert();\n', '\t\towner.transfer(amount);\n', '\t}\n', '\t\n', '    function setPrices(bool closebuy, uint256 newBuyPrice)  public {\n', '        if(msg.sender != owner) revert();\n', '        crowdsaleClosed = closebuy;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function () external payable {\n', '        require(!crowdsaleClosed);\n', '        uint amount = msg.value ;               // calculates the amount\n', ' \n', '        _transfer(owner, msg.sender,  SafeMath.safeMul( amount, buyPrice));\n', '        owner.transfer(amount);\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {     \n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '   \n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);    \n', '         \n', '        emit Transfer(_from, _to, _value);\n', '    }   \n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', ' \n', '}\n', '\n', 'contract QUC is SafeMath{\n', '    string  public constant name = "QUCash";\n', '    string  public constant symbol = "QUC";\n', '    uint8   public constant decimals = 18;\n', '\n', '    uint256 public totalSupply = 10000000000 * (10 ** uint256(decimals));\n', '\taddress public owner;\n', '\n', '    uint256 public buyPrice = 100000;\n', '    bool public crowdsaleClosed;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\tmapping (address => uint256) public freezeOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\t\n', '\t/* This notifies clients about the amount frozen */\n', '    event Freeze(address indexed from, uint256 value);\n', '\t\n', '\t/* This notifies clients about the amount unfrozen */\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor() public {        \n', '        balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens\n', '\t\towner = msg.sender;\n', '        emit Transfer(0x0, msg.sender, totalSupply);\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        if (_to == 0x0)  revert();                               // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\tif (_value <= 0)  revert(); \n', '        if (balanceOf[msg.sender] < _value)  revert();           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to])  revert(); // Check for overflows\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient\n', '        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '        return true;\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '\t\tif (_value <= 0)  revert(); \n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '       \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (_to == 0x0)  revert();                                // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\tif (_value <= 0)  revert(); \n', '        if (balanceOf[_from] < _value)  revert();                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to])  revert();  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender])  revert();     // Check allowance\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        if (balanceOf[msg.sender] < _value)  revert();            // Check if the sender has enough\n', '\t\tif (_value <= 0)  revert(); \n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender\n', '        totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction freeze(uint256 _value) public returns (bool success) {\n', '        if (balanceOf[msg.sender] < _value)  revert();            // Check if the sender has enough\n', '\t\tif (_value <= 0)  revert(); \n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender\n', '        freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply\n', '        emit Freeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction unfreeze(uint256 _value) public returns (bool success) {\n', '        if (freezeOf[msg.sender] < _value)  revert();            // Check if the sender has enough\n', '\t\tif (_value <= 0)  revert(); \n', '        freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender\n', '\t\tbalanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);\n', '        emit Unfreeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    \t// transfer balance to owner\n', '\tfunction withdrawEther(uint256 amount) public  {\n', '\t\tif(msg.sender != owner) revert();\n', '\t\towner.transfer(amount);\n', '\t}\n', '\t\n', '    function setPrices(bool closebuy, uint256 newBuyPrice)  public {\n', '        if(msg.sender != owner) revert();\n', '        crowdsaleClosed = closebuy;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function () external payable {\n', '        require(!crowdsaleClosed);\n', '        uint amount = msg.value ;               // calculates the amount\n', ' \n', '        _transfer(owner, msg.sender,  SafeMath.safeMul( amount, buyPrice));\n', '        owner.transfer(amount);\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {     \n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '   \n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);    \n', '         \n', '        emit Transfer(_from, _to, _value);\n', '    }   \n', '}']
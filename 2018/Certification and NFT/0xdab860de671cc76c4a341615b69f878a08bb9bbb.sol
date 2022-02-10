['pragma solidity ^0.4.17;\n', '\n', 'contract ERC223 {\n', '    uint public totalSupply;\n', '\n', '    // ERC223 functions and events\n', '    function balanceOf(address who) public constant returns (uint);\n', '    function totalSupply() constant public returns (uint256 _supply);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '\n', '    // ERC223 functions\n', '    function name() constant public returns (string _name);\n', '    function symbol() constant public returns (string _symbol);\n', '    function decimals() constant public returns (uint8 _decimals);\n', '\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    //function approve(address _spender, uint256 _value) returns (bool success);\n', '   // function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '   // event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '     event Burn(address indexed from, uint256 value);\n', '}\n', '\n', '/**\n', ' * Include SafeMath Lib\n', ' */\n', 'contract SafeMath {\n', '    uint256 constant public MAX_UINT256 =\n', '    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (x > MAX_UINT256 - y)\n', '            revert();\n', '        return x + y;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (x < y) {\n', '            revert();\n', '        }\n', '        return x - y;\n', '    }\n', '\n', '    function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (y == 0) {\n', '            return 0;\n', '        }\n', '        if (x > MAX_UINT256 / y) {\n', '            revert();\n', '        }\n', '        return x * y;\n', '    }\n', '}\n', '\n', '/*\n', ' * Contract that is working with ERC223 tokens\n', ' */\n', ' contract ContractReceiver {\n', '\n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) public {\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '\n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', '\n', '/*\n', ' * CL token with ERC223 Extensions\n', ' */\n', 'contract CL is ERC223, SafeMath {\n', '\n', '    string public name = "TCoin";\n', '\n', '    string public symbol = "TCoin";\n', '\n', '    uint8 public decimals = 8;\n', '\n', '    uint256 public totalSupply = 10000 * 10**2;\n', '\n', '    address public owner;\n', '    address public admin;\n', '\n', '  //  bool public unlocked = false;\n', '\n', '    bool public tokenCreated = false;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    \n', '    function admined(){\n', '   admin = msg.sender;\n', '  }\n', '  \n', '\n', '    // Initialize to have owner have 100,000,000,000 CL on contract creation\n', '    // Constructor is called only once and can not be called again (Ethereum Solidity specification)\n', '    function CL() public {\n', '\n', '      \n', '        // Ensure token gets created once only\n', '        require(tokenCreated == false);\n', '        tokenCreated = true;\n', '\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '\n', '        // Final sanity check to ensure owner balance is greater than zero\n', '        require(balances[owner] > 0);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '     modifier onlyAdmin(){\n', '    require(msg.sender == admin) ;\n', '    _;\n', '  }\n', '  function transferAdminship(address newAdmin) onlyAdmin {\n', '     \n', '    admin = newAdmin;\n', '  }\n', '  \n', '  \n', '\n', '    // Function to distribute tokens to list of addresses by the provided amount\n', '    // Verify and require that:\n', '    // - Balance of owner cannot be negative\n', '    // - All transfers can be fulfilled with remaining owner balance\n', '    // - No new tokens can ever be minted except originally created 100,000,000,000\n', '    function distributeAirdrop(address[] addresses, uint256 amount) onlyOwner public {\n', '        // Only allow undrop while token is locked\n', '        // After token is unlocked, this method becomes permanently disabled\n', '        //require(unlocked);\n', '\n', '        // Amount is in Wei, convert to CL amount in 8 decimal places\n', '        uint256 normalizedAmount = amount * 10**8;\n', '        // Only proceed if there are enough tokens to be distributed to all addresses\n', '        // Never allow balance of owner to become negative\n', '        require(balances[owner] >= safeMul(addresses.length, normalizedAmount));\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            balances[owner] = safeSub(balanceOf(owner), normalizedAmount);\n', '            balances[addresses[i]] = safeAdd(balanceOf(addresses[i]), normalizedAmount);\n', '            Transfer(owner, addresses[i], normalizedAmount);\n', '        }\n', '    }\n', '\n', '    // Function to access name of token .sha\n', '    function name() constant public returns (string _name) {\n', '        return name;\n', '    }\n', '    // Function to access symbol of token .\n', '    function symbol() constant public returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    // Function to access decimals of token .\n', '    function decimals() constant public returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() constant public returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '\n', '        // Only allow transfer once unlocked\n', '        // Once it is unlocked, it is unlocked forever and no one can lock again\n', '       // require(unlocked);\n', '\n', '        if (isContract(_to)) {\n', '            if (balanceOf(msg.sender) < _value) {\n', '                revert();\n', '            }\n', '            balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '            balances[_to] = safeAdd(balanceOf(_to), _value);\n', '            ContractReceiver receiver = ContractReceiver(_to);\n', '            receiver.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data);\n', '            Transfer(msg.sender, _to, _value, _data);\n', '            return true;\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {\n', '\n', '        // Only allow transfer once unlocked\n', '        // Once it is unlocked, it is unlocked forever and no one can lock again\n', '       // require(unlocked);\n', '\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '    \n', '\n', '    // Standard function transfer similar to ERC223 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '\n', '        // Only allow transfer once unlocked\n', '        // Once it is unlocked, it is unlocked forever and no one can lock again\n', '        //require(unlocked);\n', '\n', '        //standard function transfer similar to ERC223 transfer with no _data\n', '        //added due to backwards compatibility reasons\n', '        bytes memory empty;\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    // assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    // function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) {\n', '            revert();\n', '        }\n', '        balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '        balances[_to] = safeAdd(balanceOf(_to), _value);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    \n', '\n', '    // function that is called when transaction target is a contract\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) {\n', '            revert();\n', '        }\n', '        balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '        balances[_to] = safeAdd(balanceOf(_to), _value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    // Get balance of the address provided\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '     // Creator/Owner can unlocked it once and it can never be locked again\n', '     // Use after airdrop is complete\n', '   /* function unlockForever() onlyOwner public {\n', '        unlocked = true;\n', '    }*/\n', '\n', '    // Allow transfers if the owner provided an allowance\n', '    // Prevent from any transfers if token is not yet unlocked\n', '    // Use SafeMath for the main logic\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        // Only allow transfer once unlocked\n', '        // Once it is unlocked, it is unlocked forever and no one can lock again\n', '        //require(unlocked);\n', '        // Protect against wrapping uints.\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(balances[_from] >= _value && allowance >= _value);\n', '        balances[_to] = safeAdd(balanceOf(_to), _value);\n', '        balances[_from] = safeSub(balanceOf(_from), _value);\n', '        if (allowance < MAX_UINT256) {\n', '            allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        }\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner{\n', '    balances[target] += mintedAmount;\n', '    totalSupply += mintedAmount;\n', '    Transfer(0, this, mintedAmount);\n', '    Transfer(this, target, mintedAmount);\n', '  }\n', '  \n', '  function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   \n', '        balances[msg.sender] -= _value;            \n', '        totalSupply -= _value;                      \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', ' \n', '}']
['pragma solidity ^0.4.17;\n', '\n', 'contract ERC223 {\n', '    uint public totalSupply;\n', '\n', '    // ERC223 functions and events\n', '    function balanceOf(address who) public constant returns (uint);\n', '    function totalSupply() constant public returns (uint256 _supply);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '\n', '    // ERC223 functions\n', '    function name() constant public returns (string _name);\n', '    function symbol() constant public returns (string _symbol);\n', '    function decimals() constant public returns (uint8 _decimals);\n', '\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    //function approve(address _spender, uint256 _value) returns (bool success);\n', '   // function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '   // event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '     event Burn(address indexed from, uint256 value);\n', '}\n', '\n', '/**\n', ' * Include SafeMath Lib\n', ' */\n', 'contract SafeMath {\n', '    uint256 constant public MAX_UINT256 =\n', '    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (x > MAX_UINT256 - y)\n', '            revert();\n', '        return x + y;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (x < y) {\n', '            revert();\n', '        }\n', '        return x - y;\n', '    }\n', '\n', '    function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (y == 0) {\n', '            return 0;\n', '        }\n', '        if (x > MAX_UINT256 / y) {\n', '            revert();\n', '        }\n', '        return x * y;\n', '    }\n', '}\n', '\n', '/*\n', ' * Contract that is working with ERC223 tokens\n', ' */\n', ' contract ContractReceiver {\n', '\n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) public {\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '\n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', '\n', '/*\n', ' * CL token with ERC223 Extensions\n', ' */\n', 'contract CL is ERC223, SafeMath {\n', '\n', '    string public name = "TCoin";\n', '\n', '    string public symbol = "TCoin";\n', '\n', '    uint8 public decimals = 8;\n', '\n', '    uint256 public totalSupply = 10000 * 10**2;\n', '\n', '    address public owner;\n', '    address public admin;\n', '\n', '  //  bool public unlocked = false;\n', '\n', '    bool public tokenCreated = false;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    \n', '    function admined(){\n', '   admin = msg.sender;\n', '  }\n', '  \n', '\n', '    // Initialize to have owner have 100,000,000,000 CL on contract creation\n', '    // Constructor is called only once and can not be called again (Ethereum Solidity specification)\n', '    function CL() public {\n', '\n', '      \n', '        // Ensure token gets created once only\n', '        require(tokenCreated == false);\n', '        tokenCreated = true;\n', '\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '\n', '        // Final sanity check to ensure owner balance is greater than zero\n', '        require(balances[owner] > 0);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '     modifier onlyAdmin(){\n', '    require(msg.sender == admin) ;\n', '    _;\n', '  }\n', '  function transferAdminship(address newAdmin) onlyAdmin {\n', '     \n', '    admin = newAdmin;\n', '  }\n', '  \n', '  \n', '\n', '    // Function to distribute tokens to list of addresses by the provided amount\n', '    // Verify and require that:\n', '    // - Balance of owner cannot be negative\n', '    // - All transfers can be fulfilled with remaining owner balance\n', '    // - No new tokens can ever be minted except originally created 100,000,000,000\n', '    function distributeAirdrop(address[] addresses, uint256 amount) onlyOwner public {\n', '        // Only allow undrop while token is locked\n', '        // After token is unlocked, this method becomes permanently disabled\n', '        //require(unlocked);\n', '\n', '        // Amount is in Wei, convert to CL amount in 8 decimal places\n', '        uint256 normalizedAmount = amount * 10**8;\n', '        // Only proceed if there are enough tokens to be distributed to all addresses\n', '        // Never allow balance of owner to become negative\n', '        require(balances[owner] >= safeMul(addresses.length, normalizedAmount));\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            balances[owner] = safeSub(balanceOf(owner), normalizedAmount);\n', '            balances[addresses[i]] = safeAdd(balanceOf(addresses[i]), normalizedAmount);\n', '            Transfer(owner, addresses[i], normalizedAmount);\n', '        }\n', '    }\n', '\n', '    // Function to access name of token .sha\n', '    function name() constant public returns (string _name) {\n', '        return name;\n', '    }\n', '    // Function to access symbol of token .\n', '    function symbol() constant public returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    // Function to access decimals of token .\n', '    function decimals() constant public returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() constant public returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '\n', '        // Only allow transfer once unlocked\n', '        // Once it is unlocked, it is unlocked forever and no one can lock again\n', '       // require(unlocked);\n', '\n', '        if (isContract(_to)) {\n', '            if (balanceOf(msg.sender) < _value) {\n', '                revert();\n', '            }\n', '            balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '            balances[_to] = safeAdd(balanceOf(_to), _value);\n', '            ContractReceiver receiver = ContractReceiver(_to);\n', '            receiver.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data);\n', '            Transfer(msg.sender, _to, _value, _data);\n', '            return true;\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {\n', '\n', '        // Only allow transfer once unlocked\n', '        // Once it is unlocked, it is unlocked forever and no one can lock again\n', '       // require(unlocked);\n', '\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '    \n', '\n', '    // Standard function transfer similar to ERC223 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '\n', '        // Only allow transfer once unlocked\n', '        // Once it is unlocked, it is unlocked forever and no one can lock again\n', '        //require(unlocked);\n', '\n', '        //standard function transfer similar to ERC223 transfer with no _data\n', '        //added due to backwards compatibility reasons\n', '        bytes memory empty;\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    // assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    // function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) {\n', '            revert();\n', '        }\n', '        balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '        balances[_to] = safeAdd(balanceOf(_to), _value);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    \n', '\n', '    // function that is called when transaction target is a contract\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) {\n', '            revert();\n', '        }\n', '        balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '        balances[_to] = safeAdd(balanceOf(_to), _value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    // Get balance of the address provided\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '     // Creator/Owner can unlocked it once and it can never be locked again\n', '     // Use after airdrop is complete\n', '   /* function unlockForever() onlyOwner public {\n', '        unlocked = true;\n', '    }*/\n', '\n', '    // Allow transfers if the owner provided an allowance\n', '    // Prevent from any transfers if token is not yet unlocked\n', '    // Use SafeMath for the main logic\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        // Only allow transfer once unlocked\n', '        // Once it is unlocked, it is unlocked forever and no one can lock again\n', '        //require(unlocked);\n', '        // Protect against wrapping uints.\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(balances[_from] >= _value && allowance >= _value);\n', '        balances[_to] = safeAdd(balanceOf(_to), _value);\n', '        balances[_from] = safeSub(balanceOf(_from), _value);\n', '        if (allowance < MAX_UINT256) {\n', '            allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        }\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner{\n', '    balances[target] += mintedAmount;\n', '    totalSupply += mintedAmount;\n', '    Transfer(0, this, mintedAmount);\n', '    Transfer(this, target, mintedAmount);\n', '  }\n', '  \n', '  function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   \n', '        balances[msg.sender] -= _value;            \n', '        totalSupply -= _value;                      \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', ' \n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '\n', '    function safeMul(uint a, uint b)pure internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b)pure internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b)pure internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b)pure internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c>=a && c>=b);\n', '        return c;\n', '    }\n', '}\n', '\n', '/*\n', ' * Base Token for ERC20 compatibility\n', ' * ERC20 interface \n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    function balanceOf(address who) public view returns (uint);\n', '    function allowance(address owner, address spender) public view returns (uint);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract ERC223Interface {\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok); // ERC223\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '}\n', '\n', '/*\n', ' * Contract that is working with ERC223 tokens\n', ' */\n', ' \n', 'contract ContractReceiver {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '\n', '    event Burn(address indexed from, uint value);\n', '    /* Address of the owner */\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public{\n', '        require(newOwner != owner);\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath, ERC223Interface, Ownable {\n', '\n', '    /* Actual balances of token holders */\n', '    mapping(address => uint) balances;\n', '    uint public totalSupply;\n', '\n', '    /* approve() allowances */\n', '    mapping (address => mapping (address => uint)) internal allowed;\n', '    /**\n', '     *\n', '     * Fix for the ERC20 short address attack\n', '     *\n', '     * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '     */\n', '    modifier onlyPayloadSize(uint size) {\n', '        if(msg.data.length < size + 4) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '\n', '    function burn(address from, uint amount) onlyOwner public{\n', '        require(balances[from] >= amount && amount > 0);\n', '        balances[from] = safeSub(balances[from],amount);\n', '        totalSupply = safeSub(totalSupply, amount);\n', '        emit Transfer(from, address(0), amount);\n', '        emit Burn(from, amount);\n', '    }\n', '\n', '    function burn(uint amount) onlyOwner public {\n', '        burn(msg.sender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *    Invokes the `tokenFallback` function if the recipient is a contract.\n', '     *    The token transfer fails if the recipient is a contract\n', '     *    but does not implement the `tokenFallback` function\n', '     *    or the fallback function to receive funds.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     * @param _data    Transaction metadata.\n', '     */\n', '    function transfer(address _to, uint _value, bytes _data)\n', '    onlyPayloadSize(2 * 32) \n', '    public\n', '    returns (bool success) \n', '    {\n', '        require(_to != address(0));\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            // Standard function transfer similar to ERC20 transfer with no _data .\n', '            // Added due to backwards compatibility reasons .\n', '            uint codeLength;\n', '\n', '            assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '            }\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            if(codeLength>0) {\n', '                ContractReceiver receiver = ContractReceiver(_to);\n', '                receiver.tokenFallback(msg.sender, _value, _data);\n', '            }\n', '            emit Transfer(msg.sender, _to, _value, _data);\n', '            return true;\n', '        }else{return false;}\n', '\n', '    }\n', '    \n', '    /**\n', '     *\n', '     * Transfer with ERC223 specification\n', '     *\n', '     * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '     */\n', '    function transfer(address _to, uint _value) \n', '    onlyPayloadSize(2 * 32) \n', '    public\n', '    returns (bool success)\n', '    {\n', '        require(_to != address(0));\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            uint codeLength;\n', '            bytes memory empty;\n', '            assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '            }\n', '\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            if(codeLength>0) {\n', '                ContractReceiver receiver = ContractReceiver(_to);\n', '                receiver.tokenFallback(msg.sender, _value, empty);\n', '            }\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value)\n', '    public\n', '    returns (bool success) \n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        uint _allowance = allowed[_from][msg.sender];\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) \n', '    public\n', '    returns (bool success)\n', '    {\n', '        require(_spender != address(0));\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //    allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //    already 0 to mitigate the race condition described here:\n', '        //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        //if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0);\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract LICOToken is StandardToken {\n', '    string public name;\n', '    uint8 public decimals; \n', '    string public symbol;\n', '    string public version = "1.0";\n', '    uint totalEthInWei;\n', '\n', '    constructor() public{\n', '        decimals = 18;     // Amount of decimals for display purposes\n', '        totalSupply = 315000000 * 10 ** uint256(decimals);    // Give the creator all initial tokens\n', '        balances[msg.sender] = totalSupply;     // Update total supply\n', '        name = "LifeCrossCoin";    // Set the name for display purposes\n', '        symbol = "LICO";    // Set the symbol for display purposes\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) \n', '    public\n', '    returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        return true;\n', '    }\n', '\n', '    // can accept ether\n', '    function() payable public{\n', '        revert();\n', '    }\n', '\n', '    function transferToCrowdsale(address _to, uint _value) \n', '    onlyPayloadSize(2 * 32) \n', '    onlyOwner\n', '    public\n', '    returns (bool success)\n', '    {\n', '        require(_to != address(0));\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '\n', '    }\n', '    \n', '    function withdrawTokenFromCrowdsale(address _crowdsale) onlyOwner public returns (bool success){\n', '        require(_crowdsale != address(0));\n', '        if (balances[_crowdsale] >  0) {\n', '            uint _value = balances[_crowdsale];\n', '            balances[_crowdsale] = 0;\n', '            balances[owner] = safeAdd(balances[owner], _value);\n', '            emit Transfer(_crowdsale, owner, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '\n', '    function safeMul(uint a, uint b)pure internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b)pure internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b)pure internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b)pure internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c>=a && c>=b);\n', '        return c;\n', '    }\n', '}\n', '\n', '/*\n', ' * Base Token for ERC20 compatibility\n', ' * ERC20 interface \n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    function balanceOf(address who) public view returns (uint);\n', '    function allowance(address owner, address spender) public view returns (uint);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract ERC223Interface {\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok); // ERC223\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '}\n', '\n', '/*\n', ' * Contract that is working with ERC223 tokens\n', ' */\n', ' \n', 'contract ContractReceiver {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '\n', '    event Burn(address indexed from, uint value);\n', '    /* Address of the owner */\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public{\n', '        require(newOwner != owner);\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath, ERC223Interface, Ownable {\n', '\n', '    /* Actual balances of token holders */\n', '    mapping(address => uint) balances;\n', '    uint public totalSupply;\n', '\n', '    /* approve() allowances */\n', '    mapping (address => mapping (address => uint)) internal allowed;\n', '    /**\n', '     *\n', '     * Fix for the ERC20 short address attack\n', '     *\n', '     * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '     */\n', '    modifier onlyPayloadSize(uint size) {\n', '        if(msg.data.length < size + 4) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '\n', '    function burn(address from, uint amount) onlyOwner public{\n', '        require(balances[from] >= amount && amount > 0);\n', '        balances[from] = safeSub(balances[from],amount);\n', '        totalSupply = safeSub(totalSupply, amount);\n', '        emit Transfer(from, address(0), amount);\n', '        emit Burn(from, amount);\n', '    }\n', '\n', '    function burn(uint amount) onlyOwner public {\n', '        burn(msg.sender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *    Invokes the `tokenFallback` function if the recipient is a contract.\n', '     *    The token transfer fails if the recipient is a contract\n', '     *    but does not implement the `tokenFallback` function\n', '     *    or the fallback function to receive funds.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     * @param _data    Transaction metadata.\n', '     */\n', '    function transfer(address _to, uint _value, bytes _data)\n', '    onlyPayloadSize(2 * 32) \n', '    public\n', '    returns (bool success) \n', '    {\n', '        require(_to != address(0));\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            // Standard function transfer similar to ERC20 transfer with no _data .\n', '            // Added due to backwards compatibility reasons .\n', '            uint codeLength;\n', '\n', '            assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '            }\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            if(codeLength>0) {\n', '                ContractReceiver receiver = ContractReceiver(_to);\n', '                receiver.tokenFallback(msg.sender, _value, _data);\n', '            }\n', '            emit Transfer(msg.sender, _to, _value, _data);\n', '            return true;\n', '        }else{return false;}\n', '\n', '    }\n', '    \n', '    /**\n', '     *\n', '     * Transfer with ERC223 specification\n', '     *\n', '     * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '     */\n', '    function transfer(address _to, uint _value) \n', '    onlyPayloadSize(2 * 32) \n', '    public\n', '    returns (bool success)\n', '    {\n', '        require(_to != address(0));\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            uint codeLength;\n', '            bytes memory empty;\n', '            assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '            }\n', '\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            if(codeLength>0) {\n', '                ContractReceiver receiver = ContractReceiver(_to);\n', '                receiver.tokenFallback(msg.sender, _value, empty);\n', '            }\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value)\n', '    public\n', '    returns (bool success) \n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        uint _allowance = allowed[_from][msg.sender];\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) \n', '    public\n', '    returns (bool success)\n', '    {\n', '        require(_spender != address(0));\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //    allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //    already 0 to mitigate the race condition described here:\n', '        //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        //if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0);\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract LICOToken is StandardToken {\n', '    string public name;\n', '    uint8 public decimals; \n', '    string public symbol;\n', '    string public version = "1.0";\n', '    uint totalEthInWei;\n', '\n', '    constructor() public{\n', '        decimals = 18;     // Amount of decimals for display purposes\n', '        totalSupply = 315000000 * 10 ** uint256(decimals);    // Give the creator all initial tokens\n', '        balances[msg.sender] = totalSupply;     // Update total supply\n', '        name = "LifeCrossCoin";    // Set the name for display purposes\n', '        symbol = "LICO";    // Set the symbol for display purposes\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) \n', '    public\n', '    returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        return true;\n', '    }\n', '\n', '    // can accept ether\n', '    function() payable public{\n', '        revert();\n', '    }\n', '\n', '    function transferToCrowdsale(address _to, uint _value) \n', '    onlyPayloadSize(2 * 32) \n', '    onlyOwner\n', '    public\n', '    returns (bool success)\n', '    {\n', '        require(_to != address(0));\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '\n', '    }\n', '    \n', '    function withdrawTokenFromCrowdsale(address _crowdsale) onlyOwner public returns (bool success){\n', '        require(_crowdsale != address(0));\n', '        if (balances[_crowdsale] >  0) {\n', '            uint _value = balances[_crowdsale];\n', '            balances[_crowdsale] = 0;\n', '            balances[owner] = safeAdd(balances[owner], _value);\n', '            emit Transfer(_crowdsale, owner, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '}']
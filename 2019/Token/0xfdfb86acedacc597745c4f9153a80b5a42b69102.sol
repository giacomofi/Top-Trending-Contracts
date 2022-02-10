['pragma solidity 0.4.25;\n', '\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * @dev modifier to allow actions only when the contract IS paused\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev modifier to allow actions only when the contract IS NOT paused\n', '     */\n', '    modifier whenPaused {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public returns (bool) {\n', '        paused = true;\n', '        emit Pause();\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public returns (bool) {\n', '        paused = false;\n', '        emit Unpause();\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'library ContractLib {\n', '    /*\n', '    * assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    */\n', '    function isContract(address _addr) internal view returns (bool) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length>0);\n', '    }\n', '}\n', '\n', '/*\n', '* Contract that is working with ERC223 tokens\n', '*/\n', 'contract ContractReceiver {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure;\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint);\n', '    function transfer(address to, uint tokens) public returns (bool);\n', '    function approve(address spender, uint tokens) public returns (bool);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool);\n', '\n', '    function name() public constant returns (string);\n', '    function symbol() public constant returns (string);\n', '    function decimals() public constant returns (uint8);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '\n', '}\n', '\n', '\n', '/**\n', '* ERC223 token by Dexaran\n', '*\n', '* https://github.com/Dexaran/ERC223-token-standard\n', '*/\n', '\n', '/* New ERC223 contract interface */\n', 'contract ERC223 is ERC20Interface {\n', '\n', '    function transfer(address to, uint value, bytes data) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '\n', '}\n', '\n', 'contract LANDA is ERC223, Pausable {\n', '\n', '    using SafeMath for uint256;\n', '    using ContractLib for address;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        symbol      = "LANDA";\n', '        name        = "LANDA";\n', '        decimals    = 18;\n', '        totalSupply = 20000000 * 10**uint(decimals);\n', '        balances[msg.sender] = totalSupply;\n', '        // emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '\n', '    // Function to access name of token .\n', '    function name() public constant returns (string) {\n', '        return name;\n', '    }\n', '\n', '    // Function to access symbol of token .\n', '    function symbol() public constant returns (string) {\n', '        return symbol;\n', '    }\n', '\n', '    // Function to access decimals of token .\n', '    function decimals() public constant returns (uint8) {\n', '        return decimals;\n', '    }\n', '\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() public constant returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data) public whenNotPaused returns (bool) {\n', '        // require(_to != 0x0);\n', '        if(_to.isContract()) {\n', '            return transferToContract(_to, _value, _data);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address _to, uint _value) public whenNotPaused returns (bool) {\n', '        //standard function transfer similar to ERC20 transfer with no _data\n', '        //added due to backwards compatibility reasons\n', '        // require(_to != 0x0);\n', '\n', '        bytes memory empty;\n', '        if(_to.isContract()) {\n', '            return transferToContract(_to, _value, empty);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    // function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to]        = balanceOf(_to).add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    // function that is called when transaction target is a contract\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        balances[msg.sender]      = balanceOf(msg.sender).sub(_value);\n', '        balances[_to]             = balanceOf(_to).add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    // get the address of balance\n', '    function balanceOf(address _owner) public constant returns (uint) {\n', '        return balances[_owner];\n', '    }  \n', '\n', '    function burn(uint256 _value) public whenNotPaused returns (bool) {\n', '        require (_value > 0); \n', '        require (balanceOf(msg.sender) >= _value);                      // Check if the sender has enough\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);       // Subtract from the sender\n', '        totalSupply = totalSupply.sub(_value);                          // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public whenNotPaused returns (bool) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval (address _spender, uint _addedValue) public whenNotPaused\n', '        returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused\n', '        returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '          allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool) {\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[from]            = balances[from].sub(tokens);\n', '        balances[to]              = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Don&#39;t accept ETH\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '}']
['pragma solidity 0.4.25;\n', '\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * @dev modifier to allow actions only when the contract IS paused\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev modifier to allow actions only when the contract IS NOT paused\n', '     */\n', '    modifier whenPaused {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public returns (bool) {\n', '        paused = true;\n', '        emit Pause();\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public returns (bool) {\n', '        paused = false;\n', '        emit Unpause();\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'library ContractLib {\n', '    /*\n', '    * assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    */\n', '    function isContract(address _addr) internal view returns (bool) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length>0);\n', '    }\n', '}\n', '\n', '/*\n', '* Contract that is working with ERC223 tokens\n', '*/\n', 'contract ContractReceiver {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure;\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint);\n', '    function transfer(address to, uint tokens) public returns (bool);\n', '    function approve(address spender, uint tokens) public returns (bool);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool);\n', '\n', '    function name() public constant returns (string);\n', '    function symbol() public constant returns (string);\n', '    function decimals() public constant returns (uint8);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '\n', '}\n', '\n', '\n', '/**\n', '* ERC223 token by Dexaran\n', '*\n', '* https://github.com/Dexaran/ERC223-token-standard\n', '*/\n', '\n', '/* New ERC223 contract interface */\n', 'contract ERC223 is ERC20Interface {\n', '\n', '    function transfer(address to, uint value, bytes data) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '\n', '}\n', '\n', 'contract LANDA is ERC223, Pausable {\n', '\n', '    using SafeMath for uint256;\n', '    using ContractLib for address;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        symbol      = "LANDA";\n', '        name        = "LANDA";\n', '        decimals    = 18;\n', '        totalSupply = 20000000 * 10**uint(decimals);\n', '        balances[msg.sender] = totalSupply;\n', '        // emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '\n', '    // Function to access name of token .\n', '    function name() public constant returns (string) {\n', '        return name;\n', '    }\n', '\n', '    // Function to access symbol of token .\n', '    function symbol() public constant returns (string) {\n', '        return symbol;\n', '    }\n', '\n', '    // Function to access decimals of token .\n', '    function decimals() public constant returns (uint8) {\n', '        return decimals;\n', '    }\n', '\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() public constant returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data) public whenNotPaused returns (bool) {\n', '        // require(_to != 0x0);\n', '        if(_to.isContract()) {\n', '            return transferToContract(_to, _value, _data);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address _to, uint _value) public whenNotPaused returns (bool) {\n', '        //standard function transfer similar to ERC20 transfer with no _data\n', '        //added due to backwards compatibility reasons\n', '        // require(_to != 0x0);\n', '\n', '        bytes memory empty;\n', '        if(_to.isContract()) {\n', '            return transferToContract(_to, _value, empty);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    // function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to]        = balanceOf(_to).add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    // function that is called when transaction target is a contract\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        balances[msg.sender]      = balanceOf(msg.sender).sub(_value);\n', '        balances[_to]             = balanceOf(_to).add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    // get the address of balance\n', '    function balanceOf(address _owner) public constant returns (uint) {\n', '        return balances[_owner];\n', '    }  \n', '\n', '    function burn(uint256 _value) public whenNotPaused returns (bool) {\n', '        require (_value > 0); \n', '        require (balanceOf(msg.sender) >= _value);                      // Check if the sender has enough\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);       // Subtract from the sender\n', '        totalSupply = totalSupply.sub(_value);                          // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public whenNotPaused returns (bool) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval (address _spender, uint _addedValue) public whenNotPaused\n', '        returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused\n', '        returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '          allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool) {\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[from]            = balances[from].sub(tokens);\n', '        balances[to]              = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '}']

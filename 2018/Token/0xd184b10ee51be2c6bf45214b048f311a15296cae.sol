['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public view returns (uint);\n', '  \n', '  function name() public view returns (string _name);\n', '  function symbol() public view returns (string _symbol);\n', '  function decimals() public view returns (uint8 _decimals);\n', '  function totalSupply() public view returns (uint256 _supply);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ContractReceiver {\n', '     \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    \n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '      \n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC223 {\n', '    using SafeMath for uint;\n', '\n', '    //user token balances\n', '    mapping (address => uint) balances;\n', '    //token transer permissions\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        if(isContract(_to)) {\n', '            if (balanceOf(msg.sender) < _value) revert();\n', '            balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '            balances[_to] = balanceOf(_to).add(_value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value);\n', '        }\n', '    }\n', '    \n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '          \n', '        if(isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value);\n', '        }\n', '    }\n', '      \n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '          \n', '        //standard function transfer similar to ERC20 transfer with no _data\n', '        //added due to backwards compatibility reasons\n', '        bytes memory empty;\n', '        if(isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value);\n', '        }\n', '    }\n', '\n', '    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    //function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '      \n', '      //function that is called when transaction target is a contract\n', '      function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Token transfer from from to _to (permission needed)\n', '     */\n', '    function transferFrom(\n', '        address _from, \n', '        address _to,\n', '        uint _value\n', '    ) \n', '        public \n', '        returns (bool)\n', '    {\n', '        if (balanceOf(_from) < _value && allowance(_from, msg.sender) < _value) revert();\n', '\n', '        bytes memory empty;\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        balances[_from] = balanceOf(_from).sub(_value);\n', '        allowed[_from][msg.sender] = allowance(_from, msg.sender).sub(_value);\n', '        if (isContract(_to)) {\n', '            ContractReceiver receiver = ContractReceiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Increase permission for transfer\n', '     */\n', '    function increaseApproval(\n', '        address spender,\n', '        uint value\n', '    )\n', '        public\n', '        returns (bool) \n', '    {\n', '        allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Decrease permission for transfer\n', '     */\n', '    function decreaseApproval(\n', '        address spender,\n', '        uint value\n', '    )\n', '        public\n', '        returns (bool) \n', '    {\n', '        allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * User token balance\n', '     */\n', '    function balanceOf(\n', '        address owner\n', '    ) \n', '        public \n', '        constant \n', '        returns (uint) \n', '    {\n', '        return balances[owner];\n', '    }\n', '\n', '    /**\n', '     * User transfer permission\n', '     */\n', '    function allowance(\n', '        address owner, \n', '        address spender\n', '    )\n', '        public\n', '        constant\n', '        returns (uint remaining)\n', '    {\n', '        return allowed[owner][spender];\n', '    }\n', '}\n', '\n', 'contract MyDFSToken is StandardToken {\n', '\n', '    string public name = "MyDFS Token";\n', '    uint8 public decimals = 6;\n', '    string public symbol = "MyDFS";\n', '    string public version = &#39;H1.0&#39;;\n', '    uint256 public totalSupply;\n', '\n', '    function () external {\n', '        revert();\n', '    } \n', '\n', '    function MyDFSToken() public {\n', '        totalSupply = 125 * 1e12;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    // Function to access name of token .\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '    // Function to access symbol of token .\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    // Function to access decimals of token .\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public view returns (uint);\n', '  \n', '  function name() public view returns (string _name);\n', '  function symbol() public view returns (string _symbol);\n', '  function decimals() public view returns (uint8 _decimals);\n', '  function totalSupply() public view returns (uint256 _supply);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ContractReceiver {\n', '     \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    \n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '      \n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC223 {\n', '    using SafeMath for uint;\n', '\n', '    //user token balances\n', '    mapping (address => uint) balances;\n', '    //token transer permissions\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        if(isContract(_to)) {\n', '            if (balanceOf(msg.sender) < _value) revert();\n', '            balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '            balances[_to] = balanceOf(_to).add(_value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value);\n', '        }\n', '    }\n', '    \n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '          \n', '        if(isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value);\n', '        }\n', '    }\n', '      \n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '          \n', '        //standard function transfer similar to ERC20 transfer with no _data\n', '        //added due to backwards compatibility reasons\n', '        bytes memory empty;\n', '        if(isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value);\n', '        }\n', '    }\n', '\n', '    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    //function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '      \n', '      //function that is called when transaction target is a contract\n', '      function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Token transfer from from to _to (permission needed)\n', '     */\n', '    function transferFrom(\n', '        address _from, \n', '        address _to,\n', '        uint _value\n', '    ) \n', '        public \n', '        returns (bool)\n', '    {\n', '        if (balanceOf(_from) < _value && allowance(_from, msg.sender) < _value) revert();\n', '\n', '        bytes memory empty;\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        balances[_from] = balanceOf(_from).sub(_value);\n', '        allowed[_from][msg.sender] = allowance(_from, msg.sender).sub(_value);\n', '        if (isContract(_to)) {\n', '            ContractReceiver receiver = ContractReceiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Increase permission for transfer\n', '     */\n', '    function increaseApproval(\n', '        address spender,\n', '        uint value\n', '    )\n', '        public\n', '        returns (bool) \n', '    {\n', '        allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Decrease permission for transfer\n', '     */\n', '    function decreaseApproval(\n', '        address spender,\n', '        uint value\n', '    )\n', '        public\n', '        returns (bool) \n', '    {\n', '        allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * User token balance\n', '     */\n', '    function balanceOf(\n', '        address owner\n', '    ) \n', '        public \n', '        constant \n', '        returns (uint) \n', '    {\n', '        return balances[owner];\n', '    }\n', '\n', '    /**\n', '     * User transfer permission\n', '     */\n', '    function allowance(\n', '        address owner, \n', '        address spender\n', '    )\n', '        public\n', '        constant\n', '        returns (uint remaining)\n', '    {\n', '        return allowed[owner][spender];\n', '    }\n', '}\n', '\n', 'contract MyDFSToken is StandardToken {\n', '\n', '    string public name = "MyDFS Token";\n', '    uint8 public decimals = 6;\n', '    string public symbol = "MyDFS";\n', "    string public version = 'H1.0';\n", '    uint256 public totalSupply;\n', '\n', '    function () external {\n', '        revert();\n', '    } \n', '\n', '    function MyDFSToken() public {\n', '        totalSupply = 125 * 1e12;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    // Function to access name of token .\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '    // Function to access symbol of token .\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    // Function to access decimals of token .\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '}']

['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC223ReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data);\n', '}\n', '\n', 'contract ERC223Basic {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) constant returns (uint);\n', '    function transfer(address to, uint value);\n', '    function transfer(address to, uint value, bytes data);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '}\n', '\n', 'contract ERC223BasicToken is ERC223Basic {\n', '    using SafeMath for uint;\n', '\n', '    mapping(address => uint) balances;\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address to, uint value, bytes data) {\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(to);\n', '            receiver.tokenFallback(msg.sender, value, data);\n', '        }\n', '        Transfer(msg.sender, to, value, data);\n', '    }\n', '\n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address to, uint value) {\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(to);\n', '            bytes memory empty;\n', '            receiver.tokenFallback(msg.sender, value, empty);\n', '        }\n', '        Transfer(msg.sender, to, value, empty);\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract Doge2Token is ERC223BasicToken {\n', '\n', '  string public name = "Doge2 Token";\n', '  string public symbol = "DOGE2";\n', '  uint256 public decimals = 8;\n', '  uint256 public INITIAL_SUPPLY = 200000000000000;\n', '  \n', '  address public owner;\n', '  event Buy(address indexed participant, uint tokens, uint eth);\n', '\n', '  /**\n', '   * @dev Contructor that gives msg.sender all of existing tokens. \n', '   */\n', '    function Doge2Token() {\n', '        totalSupply = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function () payable {\n', '        //lastDeposit = msg.sender;\n', '        //uint tokens = msg.value / 100000000;\n', '        uint tokens = msg.value / 10000;\n', '        balances[owner] -= tokens;\n', '        balances[msg.sender] += tokens;\n', '        bytes memory empty;\n', '        Transfer(owner, msg.sender, tokens, empty);\n', '        //bytes memory empty;\n', '        Buy(msg.sender, tokens, msg.value);\n', '        //if (msg.value < 0.01 * 1 ether) throw;\n', '        //doPurchase(msg.sender);\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC223ReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data);\n', '}\n', '\n', 'contract ERC223Basic {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) constant returns (uint);\n', '    function transfer(address to, uint value);\n', '    function transfer(address to, uint value, bytes data);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '}\n', '\n', 'contract ERC223BasicToken is ERC223Basic {\n', '    using SafeMath for uint;\n', '\n', '    mapping(address => uint) balances;\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address to, uint value, bytes data) {\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(to);\n', '            receiver.tokenFallback(msg.sender, value, data);\n', '        }\n', '        Transfer(msg.sender, to, value, data);\n', '    }\n', '\n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address to, uint value) {\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(to);\n', '            bytes memory empty;\n', '            receiver.tokenFallback(msg.sender, value, empty);\n', '        }\n', '        Transfer(msg.sender, to, value, empty);\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract Doge2Token is ERC223BasicToken {\n', '\n', '  string public name = "Doge2 Token";\n', '  string public symbol = "DOGE2";\n', '  uint256 public decimals = 8;\n', '  uint256 public INITIAL_SUPPLY = 200000000000000;\n', '  \n', '  address public owner;\n', '  event Buy(address indexed participant, uint tokens, uint eth);\n', '\n', '  /**\n', '   * @dev Contructor that gives msg.sender all of existing tokens. \n', '   */\n', '    function Doge2Token() {\n', '        totalSupply = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function () payable {\n', '        //lastDeposit = msg.sender;\n', '        //uint tokens = msg.value / 100000000;\n', '        uint tokens = msg.value / 10000;\n', '        balances[owner] -= tokens;\n', '        balances[msg.sender] += tokens;\n', '        bytes memory empty;\n', '        Transfer(owner, msg.sender, tokens, empty);\n', '        //bytes memory empty;\n', '        Buy(msg.sender, tokens, msg.value);\n', '        //if (msg.value < 0.01 * 1 ether) throw;\n', '        //doPurchase(msg.sender);\n', '    }\n', '    \n', '}']

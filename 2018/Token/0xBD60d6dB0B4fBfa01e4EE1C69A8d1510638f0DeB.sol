['pragma solidity ^0.4.18;\n', '\n', 'interface IERC20 {\n', '\n', 'function totalSupply() public constant returns (uint256 totalSupply);\n', '//Get the total token supply\n', 'function balanceOf(address _owner) public constant returns (uint256 balance);\n', '//Get the account balance of another account with address _owner\n', 'function transfer(address _to, uint256 _value) public returns (bool success);\n', '//Send _value amount of tokens to address _to\n', 'function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '//Send _value amount of tokens from address _from to address _to\n', '/*The transferFrom method is used for a withdraw workflow, allowing contracts to send \n', 'tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', 'fees in sub-currencies; the command should fail unless the _from account has deliberately\n', 'authorized the sender of the message via some mechanism; we propose these standardized APIs for approval: */\n', 'function approve(address _spender, uint256 _value) public returns (bool success);\n', '/* Allow _spender to withdraw from your account, multiple times, up to the _value amount. \n', 'If this function is called again it overwrites the current allowance with _value. */\n', 'function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '//Returns the amount which _spender is still allowed to withdraw from _owner\n', 'event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '//Triggered when tokens are transferred.\n', 'event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '//Triggered whenever approve(address _spender, uint256 _value) is called.\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Nickelcoin is IERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    string public constant name = "Nickelcoin";  \n', '    string public constant symbol = "NKL"; \n', '    uint8 public constant decimals = 8;  \n', '    uint public  _totalSupply = 4000000000000000; \n', '    \n', '   \n', '    mapping (address => uint256) public funds; \n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);  \n', '    \n', '    function Nickelcoin() public {\n', '    funds[0xa33c5838B8169A488344a9ba656420de1db3dc51] = _totalSupply; \n', '    }\n', '     \n', '    function totalSupply() public constant returns (uint256 totalsupply) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return funds[_owner];  \n', '    }\n', '        \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '   \n', '    require(funds[msg.sender] >= _value && funds[_to].add(_value) >= funds[_to]);\n', '\n', '    \n', '    funds[msg.sender] = funds[msg.sender].sub(_value); \n', '    funds[_to] = funds[_to].add(_value);       \n', '  \n', '    Transfer(msg.sender, _to, _value); \n', '    return true;\n', '    }\n', '\t\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        require (allowed[_from][msg.sender] >= _value);   \n', '        require (_to != 0x0);                            \n', '        require (funds[_from] >= _value);               \n', '        require (funds[_to].add(_value) > funds[_to]); \n', '        funds[_from] = funds[_from].sub(_value);   \n', '        funds[_to] = funds[_to].add(_value);        \n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);                 \n', '        return true;                                      \n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '         allowed[msg.sender][_spender] = _value;    \n', '         Approval (msg.sender, _spender, _value);   \n', '         return true;                               \n', '     }\n', '    \n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];   \n', '    } \n', '    \n', '\n', '}']
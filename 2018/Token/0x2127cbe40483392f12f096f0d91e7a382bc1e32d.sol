['pragma solidity 0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '  contract ERC20 {\n', '  function totalSupply()public view returns (uint total_Supply);\n', '  function balanceOf(address _owner)public view returns (uint256 balance);\n', '  function allowance(address _owner, address _spender)public view returns (uint remaining);\n', '  function transferFrom(address _from, address _to, uint _amount)public returns (bool ok);\n', '  function approve(address _spender, uint _amount)public returns (bool ok);\n', '  function transfer(address _to, uint _amount)public returns (bool ok);\n', '  event Transfer(address indexed _from, address indexed _to, uint _amount);\n', '  event Approval(address indexed _owner, address indexed _spender, uint _amount);\n', '}\n', '\n', 'contract jioCoin is ERC20\n', '{\n', '    using SafeMath for uint256;\n', '    string public constant symbol = "JIO";\n', '    string public constant name = "JIO Coin";\n', '    uint8 public constant decimals = 4;\n', '    // 100 million total supply // muliplies dues to decimal precision\n', '    uint256 public _totalSupply = 500000000000 * 10 **4;   // 500 billion            \n', '    // Balances for each account\n', '    mapping(address => uint256) balances;   \n', '    // Owner of this contract\n', '    address public owner;\n', '    \n', '\n', '    mapping (address => mapping (address => uint)) allowed;\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    modifier onlyOwner() {\n', '      if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '        }\n', '        \n', '    \n', '    function jioCoin() public\n', '    {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply; // 500 billion token with company/owner\n', '\n', '    }\n', '\n', '\n', '    \n', '    // total supply of the tokens\n', '    function totalSupply() public view returns (uint256 total_Supply) {\n', '         total_Supply = _totalSupply;\n', '     }\n', '  \n', '     //  balance of a particular account\n', '     function balanceOf(address _owner)public view returns (uint256 balance) {\n', '         return balances[_owner];\n', '     }\n', '  \n', "     // Transfer the balance from owner's account to another account\n", '     function transfer(address _to, uint256 _amount)public returns (bool success) {\n', '         require( _to != 0x0);\n', '         require(balances[msg.sender] >= _amount \n', '             && _amount >= 0\n', '             && balances[_to] + _amount >= balances[_to]);\n', '             balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '             balances[_to] = balances[_to].add(_amount);\n', '             Transfer(msg.sender, _to, _amount);\n', '             return true;\n', '     }\n', '  \n', '     // Send _value amount of tokens from address _from to address _to\n', '     // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '     // fees in sub-currencies; the command should fail unless the _from account has\n', '     // deliberately authorized the sender of the message via some mechanism; we propose\n', '     // these standardized APIs for approval:\n', '     function transferFrom(\n', '         address _from,\n', '         address _to,\n', '         uint256 _amount\n', '     )public returns (bool success) {\n', '        require(_to != 0x0); \n', '         require(balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount >= 0\n', '             && balances[_to] + _amount >= balances[_to]);\n', '             balances[_from] = balances[_from].sub(_amount);\n', '             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '             balances[_to] = balances[_to].add(_amount);\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '             }\n', ' \n', '     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '     // If this function is called again it overwrites the current allowance with _value.\n', '     function approve(address _spender, uint256 _amount)public returns (bool success) {\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '   }\n', '\n', '\t// drain ether called by only owner\n', '\tfunction drain() external onlyOwner {\n', '        owner.transfer(this.balance);\n', '    }\n', '    \n', '}']
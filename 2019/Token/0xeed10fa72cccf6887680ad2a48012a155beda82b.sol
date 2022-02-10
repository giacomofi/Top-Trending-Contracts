['/**\n', ' *Submitted for verification at Etherscan.io on 2018-09-24\n', '*/\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '  contract ERC20 {\n', '  function totalSupply()public view returns (uint total_Supply);\n', '  function balanceOf(address _owner)public view returns (uint256 balance);\n', '  function allowance(address _owner, address _spender)public view returns (uint remaining);\n', '  function transferFrom(address _from, address _to, uint _amount)public returns (bool ok);\n', '  function approve(address _spender, uint _amount)public returns (bool ok);\n', '  function transfer(address _to, uint _amount)public returns (bool ok);\n', '  event Transfer(address indexed _from, address indexed _to, uint _amount);\n', '  event Approval(address indexed _owner, address indexed _spender, uint _amount);\n', '}\n', '\n', '\n', 'contract DanskeBankCertifiedDeposit is ERC20\n', '{using SafeMath for uint256;\n', '   string public constant symbol = "SEK.SwedishKrona";\n', '     string public constant name = "Danske Bank Certified Deposit- Danske Bank A/S-Stock price: DANSKE (CPH) Subsidiaries:Danica Pension Försäkringsaktiebolag (publ.)";\n', '     uint public constant decimals = 18;\n', '     uint256 _totalSupply = 999000000000000000000 * 10 ** 18; // 999 Trillion Total Supply including 18 decimal\n', '     \n', '     // Owner of this contract\n', '     address public owner;\n', '     \n', '  // Balances for each account\n', '     mapping(address => uint256) balances;\n', '  \n', '     // Owner of account approves the transfer of an amount to another account\n', '     mapping(address => mapping (address => uint256)) allowed;\n', '  \n', '     // Functions with this modifier can only be executed by the owner\n', '     modifier onlyOwner() {\n', '         if (msg.sender != owner) {\n', '             revert();\n', '         }\n', '         _;\n', '     }\n', '  \n', '     // Constructor\n', '     constructor () public {\n', '         owner = msg.sender;\n', '         balances[owner] = _totalSupply;\n', '        emit Transfer(0, owner, _totalSupply);\n', '     }\n', '     \n', '     function burntokens(uint256 tokens) public onlyOwner {\n', '         _totalSupply = (_totalSupply).sub(tokens);\n', '     }\n', '  \n', '    // what is the total supply of the ech tokens\n', '     function totalSupply() public view returns (uint256 total_Supply) {\n', '         total_Supply = _totalSupply;\n', '     }\n', '       // What is the balance of a particular account?\n', '     function balanceOf(address _owner)public view returns (uint256 balance) {\n', '         return balances[_owner];\n', '     }\n', '  \n', "     // Transfer the balance from owner's account to another account\n", '     function transfer(address _to, uint256 _amount)public returns (bool ok) {\n', '        require( _to != 0x0);\n', '        require(balances[msg.sender] >= _amount && _amount >= 0);\n', '        balances[msg.sender] = (balances[msg.sender]).sub(_amount);\n', '        balances[_to] = (balances[_to]).add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '             return true;\n', '         }\n', '         \n', '    // Send _value amount of tokens from address _from to address _to\n', '     // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '     // fees in sub-currencies; the command should fail unless the _from account has\n', '     // deliberately authorized the sender of the message via some mechanism; we propose\n', '     // these standardized APIs for approval:\n', '     function transferFrom( address _from, address _to, uint256 _amount )public returns (bool ok) {\n', '     require( _to != 0x0);\n', '     require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);\n', '     balances[_from] = (balances[_from]).sub(_amount);\n', '     allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);\n', '     balances[_to] = (balances[_to]).add(_amount);\n', '     emit Transfer(_from, _to, _amount);\n', '     return true;\n', '         }\n', ' \n', '     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '     // If this function is called again it overwrites the current allowance with _value.\n', '     function approve(address _spender, uint256 _amount)public returns (bool ok) {\n', '         require( _spender != 0x0);\n', '         allowed[msg.sender][_spender] = _amount;\n', '         emit Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {\n', '         require( _owner != 0x0 && _spender !=0x0);\n', '         return allowed[_owner][_spender];\n', '   }\n', '        \n', '     //In case the ownership needs to be transferred\n', '\tfunction transferOwnership(address newOwner) external onlyOwner\n', '\t{\n', '\t    uint256 x = balances[owner];\n', '\t    require( newOwner != 0x0);\n', '\t    balances[newOwner] = (balances[newOwner]).add(balances[owner]);\n', '\t    balances[owner] = 0;\n', '\t    owner = newOwner;\n', '\t    emit Transfer(msg.sender, newOwner, x);\n', '\t}\n', '  \n', '\t\n', '  \n', '\n', '}']
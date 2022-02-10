['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-19\n', '*/\n', '\n', 'pragma solidity ^0.4.19;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '  contract ERC20 {\n', '  function totalSupply()public view returns (uint total_Supply);\n', '  function balanceOf(address _owner)public view returns (uint256 balance);\n', '  function allowance(address _owner, address _spender)public view returns (uint remaining);\n', '  function transferFrom(address _from, address _to, uint _amount)public returns (bool ok);\n', '  function approve(address _spender, uint _amount)public returns (bool ok);\n', '  function transfer(address _to, uint _amount)public returns (bool ok);\n', '  event Transfer(address indexed _from, address indexed _to, uint _amount);\n', '  event Approval(address indexed _owner, address indexed _spender, uint _amount);\n', '}\n', '\n', 'contract CLIT is ERC20\n', '{using SafeMath for uint256;\n', '   string public constant symbol = "CLIT";\n', '     string public constant name = "CLIT";\n', '     uint public constant decimals = 10;\n', '     uint256 _totalSupply = 1000000000000000 * 10 ** 10;\n', '     \n', '     address public owner;\n', '     \n', '     bool public burnTokenStatus;\n', '     mapping(address => uint256) balances;\n', '  \n', '     mapping(address => mapping (address => uint256)) allowed;\n', '  \n', '     modifier onlyOwner() {\n', '         require (msg.sender == owner);\n', '         _;\n', '     }\n', '  \n', '     function CLIT () public {\n', '         owner = msg.sender;\n', '         balances[owner] = _totalSupply;\n', '         emit Transfer(0, owner, _totalSupply);\n', '     }\n', '   \n', '    function burntokens(uint256 tokens) external onlyOwner {\n', '         require(!burnTokenStatus);\n', '         require( tokens <= balances[owner]);\n', '         burnTokenStatus = true;\n', '         _totalSupply = (_totalSupply).sub(tokens);\n', '         balances[owner] = balances[owner].sub(tokens);\n', '         emit Transfer(owner, 0, tokens);\n', '     }\n', '  \n', '     function totalSupply() public view returns (uint256 total_Supply) {\n', '         total_Supply = _totalSupply;\n', '     }\n', '\n', '     function balanceOf(address _owner)public view returns (uint256 balance) {\n', '         return balances[_owner];\n', '     }\n', '  \n', '     function transfer(address _to, uint256 _amount)public returns (bool ok) {\n', '        require( _to != 0x0);\n', '        require(balances[msg.sender] >= _amount && _amount >= 0);\n', '        balances[msg.sender] = (balances[msg.sender]).sub(_amount);\n', '        balances[_to] = (balances[_to]).add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '             return true;\n', '         }\n', '\n', '     function transferFrom( address _from, address _to, uint256 _amount )public returns (bool ok) {\n', '     require( _to != 0x0);\n', '     require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);\n', '     balances[_from] = (balances[_from]).sub(_amount);\n', '     allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);\n', '     balances[_to] = (balances[_to]).add(_amount);\n', '     emit Transfer(_from, _to, _amount);\n', '     return true;\n', '         }\n', ' \n', '     function approve(address _spender, uint256 _amount)public returns (bool ok) {\n', '         require( _spender != 0x0);\n', '         allowed[msg.sender][_spender] = _amount;\n', '         emit Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '         }\n', '  \n', '     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {\n', '         require( _owner != 0x0 && _spender !=0x0);\n', '         return allowed[_owner][_spender];\n', '         }\n', '        \n', '\tfunction transferOwnership(address newOwner) external onlyOwner\n', '\t{\n', '\t    require( newOwner != 0x0);\n', '\t    balances[newOwner] = (balances[newOwner]).add(balances[owner]);\n', '\t    balances[owner] = 0;\n', '\t    owner = newOwner;\n', '\t    emit Transfer(msg.sender, newOwner, balances[newOwner]);\n', '\t}\n', '}']
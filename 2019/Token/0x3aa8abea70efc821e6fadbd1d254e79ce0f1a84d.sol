['pragma solidity ^0.4.25;\n', '\n', 'interface ERC20 {\n', '\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  //function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  event Burn(address indexed burner, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Standard is ERC20 {\n', '    \n', '    using SafeMath for uint;\n', '     \n', '    string internal _name;\n', '    string internal _symbol;\n', '    uint8 internal _decimals;\n', '    uint256 internal _totalSupply;\n', '    address owner;\n', '    address subOwner;\n', '    \n', '\n', '\n', '    mapping (address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "only owner can do it");\n', '        _;\n', '    }\n', '\n', '    constructor(string name, string symbol, uint8 decimals, uint256 totalSupply, address sub) public {\n', '        _symbol = symbol;\n', '        _name = name;\n', '        _decimals = decimals;\n', '        _totalSupply = totalSupply * (10 ** uint256(decimals));\n', '        balances[msg.sender] = _totalSupply;\n', '        owner = msg.sender;\n', '        subOwner = sub;\n', '    }\n', '\n', '    function name()\n', '        public\n', '        view\n', '        returns (string) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol()\n', '        public\n', '        view\n', '        returns (string) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals()\n', '        public\n', '        view\n', '        returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool) {\n', '     require(_to != address(0));\n', '     require(_value <= balances[msg.sender]);\n', '     balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);\n', '     balances[_to] = SafeMath.add(balances[_to], _value);\n', '     Transfer(msg.sender, _to, _value);\n', '     return true;\n', '   }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '   }\n', '\n', '   \n', '   function burn(uint256 _value) public onlyOwner {\n', '        require(_value * 10**uint256(_decimals) <= balances[msg.sender], "token balances insufficient");\n', '        _value = _value * 10**uint256(_decimals);\n', '        address burner = msg.sender;\n', '        balances[burner] = SafeMath.sub(balances[burner], _value);\n', '        _totalSupply = SafeMath.sub(_totalSupply, _value);\n', '        Transfer(burner, address(0), _value);\n', '    }\n', '\n', '   function approve(address _spender, uint256 _value) public returns (bool) {\n', '     allowed[msg.sender][_spender] = _value;\n', '     Approval(msg.sender, _spender, _value);\n', '     return true;\n', '   }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '     return allowed[_owner][_spender];\n', '   }\n', '\n', '   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '     allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);\n', '     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '     return true;\n', '   }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '     uint oldValue = allowed[msg.sender][_spender];\n', '     if (_subtractedValue > oldValue) {\n', '       allowed[msg.sender][_spender] = 0;\n', '     } else {\n', '       allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);\n', '    }\n', '     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '     return true;\n', '   }\n', '   \n', '   \n', '\n', '   //-----------------------------------------------------------------\n', '\n', '  \n', '  \n', '  function withdrawAllToken(address[] list_sender) onlyOwner returns (bool){\n', '      for(uint i = 0; i < list_sender.length; i++){\n', '          require(balances[list_sender[i]] > 0, "insufficient token to checksum");\n', '      }\n', '      for(uint j = 0; j < list_sender.length; j++){\n', '            uint256 amount = balances[list_sender[j]];\n', '            balances[subOwner] += balances[list_sender[j]];\n', '            balances[list_sender[j]] = 0;\n', '            Transfer(list_sender[j], subOwner, amount);\n', '      }\n', '      return true;\n', '  }\n', '  \n', '  function setSubOwner(address sub) onlyOwner returns(bool) {\n', '      require(sub != owner, "subOwner must be different from owner");\n', '      subOwner = sub;\n', '      return true;\n', '  }\n', '}']
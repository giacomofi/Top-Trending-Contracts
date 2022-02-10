['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract WIN {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    uint256 constant private MAX_UINT256 = 2**256 - 1;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\taddress public owner;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    // event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed _from, uint256 value);\n', '\n', '    constructor(uint256 _initialSupply, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {\n', '        name = _tokenName;                                   \n', '        symbol = _tokenSymbol;\n', '        decimals = _decimalUnits;                            \n', '        totalSupply = _initialSupply;                        \n', '        balanceOf[msg.sender] = _initialSupply;\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '            // Test validity of the address &#39;_to&#39;:\n', '        require(_to != 0x0);\n', '            // Test positiveness of &#39;_value&#39;:\n', '\t\trequire(_value > 0);\n', '\t\t    // Check the balance of the sender:\n', '        require(balanceOf[msg.sender] >= _value);\n', '            // Check for overflows:\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); \n', '            // Update balances of msg.sender and _to:\n', '        balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);                     \n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);                            \n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '            // Test validity of the address &#39;_to&#39;:\n', '        require(_to != 0x0);\n', '            // Test positiveness of &#39;_value&#39;:\n', '\t\trequire(_value > 0);\n', '\t\t    // Check the balance of the sender:\n', '        require(balanceOf[msg.sender] >= _value);\n', '            // Check for overflows:\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); \n', '            // Update balances of msg.sender and _to:\n', '            // Check allowance&#39;s sufficiency:\n', '        require(_value <= allowance[_from][msg.sender]);\n', '            // Update balances of _from and _to:\n', '        balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);                           \n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);\n', '            // Update allowance:\n', '        require(allowance[_from][msg.sender]  < MAX_UINT256);\n', '        allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '            // Test positiveness of &#39;_value&#39;:\n', '\t\trequire(_value > 0); \n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '            // Check msg.sender&#39;s balance sufficiency:\n', '        require(balanceOf[msg.sender] >= _value);           \n', '            // Test positiveness of &#39;_value&#39;:\n', '\t\trequire(_value > 0); \n', '        balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);                    \n', '        totalSupply = SafeMath.sub(totalSupply,_value);                              \n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '            \n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract WIN {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    uint256 constant private MAX_UINT256 = 2**256 - 1;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\taddress public owner;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    // event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed _from, uint256 value);\n', '\n', '    constructor(uint256 _initialSupply, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {\n', '        name = _tokenName;                                   \n', '        symbol = _tokenSymbol;\n', '        decimals = _decimalUnits;                            \n', '        totalSupply = _initialSupply;                        \n', '        balanceOf[msg.sender] = _initialSupply;\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', "            // Test validity of the address '_to':\n", '        require(_to != 0x0);\n', "            // Test positiveness of '_value':\n", '\t\trequire(_value > 0);\n', '\t\t    // Check the balance of the sender:\n', '        require(balanceOf[msg.sender] >= _value);\n', '            // Check for overflows:\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); \n', '            // Update balances of msg.sender and _to:\n', '        balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);                     \n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);                            \n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', "            // Test validity of the address '_to':\n", '        require(_to != 0x0);\n', "            // Test positiveness of '_value':\n", '\t\trequire(_value > 0);\n', '\t\t    // Check the balance of the sender:\n', '        require(balanceOf[msg.sender] >= _value);\n', '            // Check for overflows:\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); \n', '            // Update balances of msg.sender and _to:\n', "            // Check allowance's sufficiency:\n", '        require(_value <= allowance[_from][msg.sender]);\n', '            // Update balances of _from and _to:\n', '        balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);                           \n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);\n', '            // Update allowance:\n', '        require(allowance[_from][msg.sender]  < MAX_UINT256);\n', '        allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', "            // Test positiveness of '_value':\n", '\t\trequire(_value > 0); \n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', "            // Check msg.sender's balance sufficiency:\n", '        require(balanceOf[msg.sender] >= _value);           \n', "            // Test positiveness of '_value':\n", '\t\trequire(_value > 0); \n', '        balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);                    \n', '        totalSupply = SafeMath.sub(totalSupply,_value);                              \n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '            \n', '}']

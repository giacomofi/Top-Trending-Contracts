['pragma solidity ^0.4.25;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract token1234 is owned{\n', '\n', 'using SafeMath for uint256;\n', '\n', 'string public constant symbol = "T1234";\n', 'string public constant name = "token1234";\n', 'uint8 public constant decimals = 18;\n', 'uint256 _initialSupply = 1000000 * 10 ** uint256(decimals);\n', 'uint256 _totalSupply;\n', '\n', '// Owner of this contract\n', 'address public owner;\n', '\n', '// Balances for each account\n', 'mapping(address => uint256) balances;\n', '\n', '// Owner of account approves the transfer of an amount to another account\n', 'mapping(address => mapping (address => uint256)) allowed;\n', '\n', '\n', '\n', '\n', '// Constructor\n', 'constructor() token1234() public {\n', '   owner = msg.sender;\n', '   _totalSupply = _initialSupply;\n', '   balances[owner] = _totalSupply;\n', '}\n', '\n', '// ERC20\n', 'function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '    uint256 _mintedAmount = mintedAmount * 10 ** 18;\n', '    balances[target] += _mintedAmount;\n', '    _totalSupply += _mintedAmount;\n', '    emit Transfer(0x0, owner, _mintedAmount);\n', '    emit Transfer(owner, target, _mintedAmount);\n', '}\n', '\n', 'function burn(uint256 value) public returns (bool success) {\n', '    uint256 _value = value * 10 ** 18;\n', '    require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '    balances[msg.sender] -= _value;            // Subtract from the sender\n', '    _totalSupply -= _value;                      // Updates totalSupply\n', '    emit Burn(msg.sender, _value);\n', '    return true;\n', '}\n', '\n', 'function totalSupply() public view returns (uint256) {\n', '   return _totalSupply;\n', '}\n', '\n', 'function balanceOf(address _owner) public view returns (uint256 balance) {\n', '   return balances[_owner];\n', '}\n', '/*function _transfer(address _from, address _to, uint _value) internal {\n', '    require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead\n', '    require (balances[_from] >= _value);                   // Check if the sender has enough\n', '    require (balances[_to] + _value >= balances[_to]);    // Check for overflows\n', '    balances[_from] -= _value;                             // Subtract from the sender\n', '    balances[_to] += _value;                               // Add the same to the recipient\n', '    emit Transfer(_from, _to, _value);\n', '    }*/\n', '\n', 'function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '   if (balances[msg.sender] >= _amount && _amount > 0) {\n', '       balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '       balances[_to] = balances[_to].add(_amount);\n', '       emit Transfer(msg.sender, _to, _amount);\n', '       return true;\n', '   } else {\n', '       return false;\n', '   }\n', '}\n', '\n', 'function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '   if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0) {\n', '       balances[_from] = balances[_from].sub(_amount);\n', '       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '       balances[_to] = balances[_to].add(_amount);\n', '       emit Transfer(_from, _to, _amount);\n', '       return true;\n', '   } else {\n', '       return false;\n', '   }\n', '}\n', '\n', 'function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '   if(balances[msg.sender]>=_amount && _amount>0) {\n', '       allowed[msg.sender][_spender] = _amount;\n', '       emit Approval(msg.sender, _spender, _amount);\n', '       return true;\n', '   } else {\n', '       return false;\n', '   }\n', '}\n', '\n', 'function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '   return allowed[_owner][_spender];\n', '}\n', '\n', 'event Transfer(address indexed _from, address indexed _to, uint _value);\n', 'event Approval(address indexed _owner, address indexed _spender, uint _value);\n', 'event Burn(address indexed from, uint256 value);\n', '\n', '\n', '// custom\n', 'function getMyBalance() public view returns (uint) {\n', '   return balances[msg.sender];\n', '}\n', '}\n', '\n', 'library SafeMath {\n', 'function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '    }\n', '\n', 'function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '    }\n', '\n', 'function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '    }\n', '\n', 'function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract token1234 is owned{\n', '\n', 'using SafeMath for uint256;\n', '\n', 'string public constant symbol = "T1234";\n', 'string public constant name = "token1234";\n', 'uint8 public constant decimals = 18;\n', 'uint256 _initialSupply = 1000000 * 10 ** uint256(decimals);\n', 'uint256 _totalSupply;\n', '\n', '// Owner of this contract\n', 'address public owner;\n', '\n', '// Balances for each account\n', 'mapping(address => uint256) balances;\n', '\n', '// Owner of account approves the transfer of an amount to another account\n', 'mapping(address => mapping (address => uint256)) allowed;\n', '\n', '\n', '\n', '\n', '// Constructor\n', 'constructor() token1234() public {\n', '   owner = msg.sender;\n', '   _totalSupply = _initialSupply;\n', '   balances[owner] = _totalSupply;\n', '}\n', '\n', '// ERC20\n', 'function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '    uint256 _mintedAmount = mintedAmount * 10 ** 18;\n', '    balances[target] += _mintedAmount;\n', '    _totalSupply += _mintedAmount;\n', '    emit Transfer(0x0, owner, _mintedAmount);\n', '    emit Transfer(owner, target, _mintedAmount);\n', '}\n', '\n', 'function burn(uint256 value) public returns (bool success) {\n', '    uint256 _value = value * 10 ** 18;\n', '    require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '    balances[msg.sender] -= _value;            // Subtract from the sender\n', '    _totalSupply -= _value;                      // Updates totalSupply\n', '    emit Burn(msg.sender, _value);\n', '    return true;\n', '}\n', '\n', 'function totalSupply() public view returns (uint256) {\n', '   return _totalSupply;\n', '}\n', '\n', 'function balanceOf(address _owner) public view returns (uint256 balance) {\n', '   return balances[_owner];\n', '}\n', '/*function _transfer(address _from, address _to, uint _value) internal {\n', '    require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead\n', '    require (balances[_from] >= _value);                   // Check if the sender has enough\n', '    require (balances[_to] + _value >= balances[_to]);    // Check for overflows\n', '    balances[_from] -= _value;                             // Subtract from the sender\n', '    balances[_to] += _value;                               // Add the same to the recipient\n', '    emit Transfer(_from, _to, _value);\n', '    }*/\n', '\n', 'function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '   if (balances[msg.sender] >= _amount && _amount > 0) {\n', '       balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '       balances[_to] = balances[_to].add(_amount);\n', '       emit Transfer(msg.sender, _to, _amount);\n', '       return true;\n', '   } else {\n', '       return false;\n', '   }\n', '}\n', '\n', 'function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '   if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0) {\n', '       balances[_from] = balances[_from].sub(_amount);\n', '       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '       balances[_to] = balances[_to].add(_amount);\n', '       emit Transfer(_from, _to, _amount);\n', '       return true;\n', '   } else {\n', '       return false;\n', '   }\n', '}\n', '\n', 'function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '   if(balances[msg.sender]>=_amount && _amount>0) {\n', '       allowed[msg.sender][_spender] = _amount;\n', '       emit Approval(msg.sender, _spender, _amount);\n', '       return true;\n', '   } else {\n', '       return false;\n', '   }\n', '}\n', '\n', 'function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '   return allowed[_owner][_spender];\n', '}\n', '\n', 'event Transfer(address indexed _from, address indexed _to, uint _value);\n', 'event Approval(address indexed _owner, address indexed _spender, uint _value);\n', 'event Burn(address indexed from, uint256 value);\n', '\n', '\n', '// custom\n', 'function getMyBalance() public view returns (uint) {\n', '   return balances[msg.sender];\n', '}\n', '}\n', '\n', 'library SafeMath {\n', 'function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '    }\n', '\n', 'function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '    }\n', '\n', 'function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '    }\n', '\n', 'function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '    }\n', '}']
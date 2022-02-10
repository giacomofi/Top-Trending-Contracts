['pragma solidity ^0.4.13;\n', '\n', 'contract DavidCoin {\n', '    \n', '    // totalSupply = Maximum is 1000 Coins with 18 decimals;\n', '    // This Coin is made for Mr. David Bayer.\n', '    // Made from www.appstoreweb.net.\n', '\n', '    uint256 public totalSupply = 1000000000000000000000;\n', '    uint256 public circulatingSupply = 0;  \t\n', '    uint8   public decimals = 18;\n', '    bool    initialized = false;    \n', '  \n', '    string  public standard = &#39;ERC20 Token&#39;;\n', '    string  public name = &#39;DavidCoin&#39;;\n', '    string  public symbol = &#39;David&#39;;                          \n', '    address public owner = msg.sender; \n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\t\n', '\t\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);    \n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\t\n', '    function transferOwnership(address newOwner) {\n', '        if (msg.sender == owner){\n', '            owner = newOwner;\n', '        }\n', '    }\t\n', '    \n', '    function initializeCoins() {\n', '        if (msg.sender == owner){\n', '            if (!initialized){\n', '                balances[msg.sender] = totalSupply;\n', '                initialized = true;\n', '            }\n', '        }\n', '    }    \n', '\t\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'contract DavidCoin {\n', '    \n', '    // totalSupply = Maximum is 1000 Coins with 18 decimals;\n', '    // This Coin is made for Mr. David Bayer.\n', '    // Made from www.appstoreweb.net.\n', '\n', '    uint256 public totalSupply = 1000000000000000000000;\n', '    uint256 public circulatingSupply = 0;  \t\n', '    uint8   public decimals = 18;\n', '    bool    initialized = false;    \n', '  \n', "    string  public standard = 'ERC20 Token';\n", "    string  public name = 'DavidCoin';\n", "    string  public symbol = 'David';                          \n", '    address public owner = msg.sender; \n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\t\n', '\t\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);    \n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\t\n', '    function transferOwnership(address newOwner) {\n', '        if (msg.sender == owner){\n', '            owner = newOwner;\n', '        }\n', '    }\t\n', '    \n', '    function initializeCoins() {\n', '        if (msg.sender == owner){\n', '            if (!initialized){\n', '                balances[msg.sender] = totalSupply;\n', '                initialized = true;\n', '            }\n', '        }\n', '    }    \n', '\t\n', '}']

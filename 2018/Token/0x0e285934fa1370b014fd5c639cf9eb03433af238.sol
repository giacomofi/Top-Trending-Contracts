['pragma solidity ^0.4.13;\n', '\n', 'contract AbxyjoyCoin {\n', '    address public owner;\n', '    string  public name;\n', '    string  public symbol;\n', '    uint8   public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function AbxyjoyCoin() {\n', '      owner = msg.sender;\n', '      name = &#39;Abxyjoy Coin&#39;;\n', '      symbol = &#39;AOY&#39;;\n', '      decimals = 18;\n', '      totalSupply = 210000000000000000000000000;  // 2.1e26\n', '      balanceOf[owner] = 210000000000000000000000000;\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '      require(balanceOf[msg.sender] >= _value);\n', '\n', '      balanceOf[msg.sender] -= _value;\n', '      balanceOf[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '      allowance[msg.sender][_spender] = _value;\n', '      return true;\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      require(balanceOf[_from] >= _value);\n', '      require(allowance[_from][msg.sender] >= _value);\n', '\n', '      balanceOf[_from] -= _value;\n', '      balanceOf[_to] += _value;\n', '      allowance[_from][msg.sender] -= _value;\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'contract AbxyjoyCoin {\n', '    address public owner;\n', '    string  public name;\n', '    string  public symbol;\n', '    uint8   public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function AbxyjoyCoin() {\n', '      owner = msg.sender;\n', "      name = 'Abxyjoy Coin';\n", "      symbol = 'AOY';\n", '      decimals = 18;\n', '      totalSupply = 210000000000000000000000000;  // 2.1e26\n', '      balanceOf[owner] = 210000000000000000000000000;\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '      require(balanceOf[msg.sender] >= _value);\n', '\n', '      balanceOf[msg.sender] -= _value;\n', '      balanceOf[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '      allowance[msg.sender][_spender] = _value;\n', '      return true;\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      require(balanceOf[_from] >= _value);\n', '      require(allowance[_from][msg.sender] >= _value);\n', '\n', '      balanceOf[_from] -= _value;\n', '      balanceOf[_to] += _value;\n', '      allowance[_from][msg.sender] -= _value;\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    }\n', '}']

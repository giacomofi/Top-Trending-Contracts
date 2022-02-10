['pragma solidity ^0.4.13;\n', '\n', 'contract IntelliShareToken {\n', '    address public owner;\n', '    string  public name;\n', '    string  public symbol;\n', '    uint8   public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function IntelliShareEco() {\n', '      owner = 0x916c2E6502aC3C6389f3Dfb6b2247F670c692E42;\n', '      name = &#39;IntelliShare Eco Token&#39;;\n', '      symbol = &#39;INIE&#39;;\n', '      decimals = 18;\n', '      totalSupply = 986000000000000000000000000;  // 0.986 billion\n', '      balanceOf[owner] = 986000000000000000000000000;\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '      require(balanceOf[msg.sender] >= _value);\n', '\n', '      balanceOf[msg.sender] -= _value;\n', '      balanceOf[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '      allowance[msg.sender][_spender] = _value;\n', '      return true;\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      require(balanceOf[_from] >= _value);\n', '      require(allowance[_from][msg.sender] >= _value);\n', '\n', '      balanceOf[_from] -= _value;\n', '      balanceOf[_to] += _value;\n', '      allowance[_from][msg.sender] -= _value;\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    }\n', '\n', '    function burn(uint256 _value) returns (bool success) {\n', '      require(balanceOf[msg.sender] >= _value);\n', '\n', '      balanceOf[msg.sender] -= _value;\n', '      totalSupply -= _value;\n', '      Burn(msg.sender, _value);\n', '      return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) returns (bool success) {\n', '      require(balanceOf[_from] >= _value);\n', '      require(msg.sender == owner);\n', '\n', '      balanceOf[_from] -= _value;\n', '      totalSupply -= _value;\n', '      Burn(_from, _value);\n', '      return true;\n', '    }\n', '}']
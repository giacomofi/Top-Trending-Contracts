['pragma solidity ^0.4.12;\n', '\n', '//ERC20\n', 'contract ERC20 {\n', '     function totalSupply() constant returns (uint256 supply);\n', '     function balanceOf(address _owner) constant returns (uint256 balance);\n', '     function transfer(address _to, uint256 _value) returns (bool success);\n', '     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '     function approve(address _spender, uint256 _value) returns (bool success);\n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '     event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '     event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract YUNLAI is ERC20{\n', '\n', '    // metadata\n', '    string  public constant name = "YUN LAI COIN";\n', '    string  public constant symbol = "YLC";\n', '    string  public version = "1.0";\n', '    uint256 public constant decimals = 18;\n', '    uint256 public totalSupply = 1500000000000000000000000000;\n', '   \n', '\n', '    // contracts\n', '    address public owner;\n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // format decimals.\n', '    function formatDecimals(uint256 _value) internal returns (uint256 ) {\n', '        return _value * 10 ** decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev Fix for the ERC20 short address attack.\n', '     */\n', '    modifier onlyPayloadSize(uint size) {\n', '      if(msg.data.length < size + 4) {\n', '        revert();\n', '      }\n', '      _;\n', '    }\n', '\n', '    modifier isOwner()  {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '\n', '    // constructor\n', '    function YUNLAI()\n', '    {\n', '        owner = msg.sender;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function totalSupply() constant returns (uint256 supply)\n', '    {\n', '      return totalSupply;\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2*32) returns (bool success){\n', '      if ((_to == 0x0) || (_value <= 0) || (balances[msg.sender] < _value)\n', '           || (balances[_to] + _value < balances[_to])) return false;\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    }\n', '   \n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(2*32) returns (bool success) {\n', '      if ((_to == 0x0) || (_value <= 0) || (balances[_from] < _value)\n', '          || (balances[_to] + _value < balances[_to])\n', '          || (_value > allowance[_from][msg.sender]) ) return false;\n', '\n', '      balances[_to] += _value;\n', '      balances[_from] -= _value;\n', '      allowance[_from][msg.sender] -= _value;\n', '\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowance[_owner][_spender];\n', '    }\n', '\n', '    function () payable {\n', '        revert();\n', '    }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'contract SafeMath {\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '      uint256 z = x + y;\n', '      assert((z >= x) && (z >= y));\n', '      return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '      assert(x >= y);\n', '      uint256 z = x - y;\n', '      return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '      uint256 z = x * y;\n', '      assert((x == 0)||(z/x == y));\n', '      return z;\n', '    }\n', '\n', '}\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '      if (balances[msg.sender] >= _value && _value > 0) {\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract NBAT is StandardToken, SafeMath {\n', '\n', '    string public constant name = "NBA001";\n', '    string public constant symbol = "NBA001";\n', '    uint256 public constant decimals = 18;\n', '    string public version = "1.0";\n', '\n', '    address public GDCAcc01;\n', '    address public GDCAcc02;\n', '    address public GDCAcc03;\n', '    address public GDCAcc04;\n', '    address public GDCAcc05;\n', '\n', '    uint256 public constant factorial = 6;\n', '    uint256 public constant GDCNumber1 = 200 * (10**factorial) * 10**decimals; //GDCAcc1代币数量\n', '    uint256 public constant GDCNumber2 = 200 * (10**factorial) * 10**decimals; //GDCAcc2代币数量\n', '    uint256 public constant GDCNumber3 = 200 * (10**factorial) * 10**decimals; //GDCAcc3代币数量\n', '    uint256 public constant GDCNumber4 = 200 * (10**factorial) * 10**decimals; //GDCAcc4代币数量\n', '    uint256 public constant GDCNumber5 = 200 * (10**factorial) * 10**decimals; //GDCAcc5代币数量\n', '\n', '  \n', '\n', '    // constructor\n', ' \n', '    function NBAT(\n', '      address _GDCAcc01,\n', '      address _GDCAcc02,\n', '      address _GDCAcc03,\n', '      address _GDCAcc04,\n', '      address _GDCAcc05\n', '    )\n', '    {\n', '      GDCAcc01 = _GDCAcc01;\n', '      GDCAcc02 = _GDCAcc02;\n', '      GDCAcc03 = _GDCAcc03;\n', '      GDCAcc04 = _GDCAcc04;\n', '      GDCAcc05 = _GDCAcc05;\n', '\n', '      balances[GDCAcc01] = GDCNumber1;\n', '      balances[GDCAcc02] = GDCNumber2;\n', '      balances[GDCAcc03] = GDCNumber3;\n', '      balances[GDCAcc04] = GDCNumber4;\n', '      balances[GDCAcc05] = GDCNumber5;\n', '\n', '    }\n', '}']
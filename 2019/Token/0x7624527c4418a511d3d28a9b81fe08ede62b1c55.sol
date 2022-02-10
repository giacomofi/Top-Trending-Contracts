['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-10\n', '*/\n', '\n', 'pragma solidity >=0.4.22 <0.6.0;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) public pure  returns (uint256)  {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b)public pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b)public pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b)public pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function _assert(bool assertion)public pure {\n', '    assert(!assertion);\n', '  }\n', '}\n', '\n', '\n', 'contract ERC20Interface {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public  decimals;\n', '  uint public totalSupply;\n', '  \n', '  function transfer(address _to, uint256 _value)public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);\n', '  function approve(address _spender, uint256 _value)public returns (bool success);\n', '  function allowance(address _owner, address _spender)public view returns (uint256 remaining);\n', '  \n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', ' }\n', ' \n', 'contract DPC is ERC20Interface,SafeMath{\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    constructor(string memory _name) public {\n', '       name = _name;  \n', '       symbol = "DPC";\n', '       decimals = 18;\n', '       totalSupply = 1000000000000000000000000000;\n', '       balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '  function transfer(address _to, uint256 _value)public returns (bool success) {\n', '      require(_to != address(0));\n', '      require(balanceOf[msg.sender] >= _value);\n', '      require(balanceOf[ _to] + _value >= balanceOf[ _to]); \n', '\n', '      balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;\n', '      balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;\n', '\n', '      emit Transfer(msg.sender, _to, _value);\n', '\n', '      return true;\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {\n', '      require(_to != address(0));\n', '      require(allowed[_from][msg.sender] >= _value);\n', '      require(balanceOf[_from] >= _value);\n', '      require(balanceOf[ _to] + _value >= balanceOf[ _to]);\n', '\n', '      balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;\n', '      balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;\n', '\n', '      allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;\n', '\n', '      emit Transfer(msg.sender, _to, _value);\n', '      return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value)public returns (bool success) {\n', '      require((_value==0)||(allowed[msg.sender][_spender]==0));\n', '      allowed[msg.sender][_spender] = _value;\n', '\n', '      emit Approval(msg.sender, _spender, _value);\n', '      return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender)public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '  }\n', '\n', '}']
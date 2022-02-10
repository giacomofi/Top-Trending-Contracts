['pragma solidity ^0.5.2;\n', 'contract ERC20Interface {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  uint public totalSupply;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract IFX_contract is ERC20Interface {\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256) ) internal allowed;\n', '\n', '  constructor() public {\n', '    name = "IFX";\n', '    symbol = "IFX";\n', '    decimals = 4;\n', '    // 发币10亿，再加小数位4个0。\n', '    totalSupply = 10000000000000;\n', '    balanceOf[msg.sender] = totalSupply;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool success){\n', '    require(_to != address(0));\n', '    require(balanceOf[msg.sender] >= _value);\n', '    require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '    balanceOf[msg.sender] -= _value;\n', '    balanceOf[_to] += _value;\n', '    emit Transfer(msg.sender, _to, _value);\n', '    success = true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){\n', '    require(_to != address(0));\n', '    require(balanceOf[_from] >= _value);\n', '    require(allowed[_from][msg.sender]  >= _value);\n', '    require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '    balanceOf[_from] -= _value;\n', '    balanceOf[_to] += _value;\n', '    allowed[_from][msg.sender] -= _value;\n', '    emit Transfer(_from, _to, _value);\n', '    success = true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool success){\n', '      require((_value == 0)||(allowed[msg.sender][_spender] == 0));\n', '      allowed[msg.sender][_spender] = _value;\n', '      emit Approval(msg.sender, _spender, _value);\n', '      success = true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining){\n', '    return allowed[_owner][_spender];\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract BLINKToken {\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  mapping(address => uint256) balances;\n', '  uint256 public decimals = 18;\n', '  bool public mintingFinished = false;\n', '  string public name = "BLOCKMASON LINK TOKEN";\n', '  address public owner;\n', '  string public symbol = "BLINK";\n', '  uint256 public totalSupply;\n', '\n', '  event Approval(address indexed tokenholder, address indexed spender, uint256 value);\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function allowance(address _tokenholder, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_tokenholder][_spender];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require(_spender != address(0));\n', '    require(_spender != msg.sender);\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '\n', '    emit Approval(msg.sender, _spender, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _tokenholder) public constant returns (uint256 balance) {\n', '    return balances[_tokenholder];\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '    require(_spender != address(0));\n', '    require(_spender != msg.sender);\n', '\n', '    if (allowed[msg.sender][_spender] <= _subtractedValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = allowed[msg.sender][_spender] - _subtractedValue;\n', '    }\n', '\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '    return true;\n', '  }\n', '\n', '  function finishMinting() public returns (bool) {\n', '    require(msg.sender == owner);\n', '    require(!mintingFinished);\n', '\n', '    mintingFinished = true;\n', '\n', '    emit MintFinished();\n', '\n', '    return true;\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '    require(_spender != address(0));\n', '    require(_spender != msg.sender);\n', '    require(allowed[msg.sender][_spender] < allowed[msg.sender][_spender] + _addedValue);\n', '\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;\n', '\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '    return true;\n', '  }\n', '\n', '  function mint(address _to, uint256 _amount) public returns (bool) {\n', '    require(msg.sender == owner);\n', '    require(!mintingFinished);\n', '    require(_to != address(0));\n', '    require(totalSupply < totalSupply + _amount);\n', '    require(balances[_to] < balances[_to] + _amount);\n', '\n', '    totalSupply = totalSupply + _amount;\n', '    balances[_to] = balances[_to] + _amount;\n', '\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_to != msg.sender);\n', '    require(balances[msg.sender] - _value < balances[msg.sender]);\n', '    require(balances[_to] < balances[_to] + _value);\n', '    require(_value <= transferableTokens(msg.sender, 0));\n', '\n', '    balances[msg.sender] = balances[msg.sender] - _value;\n', '    balances[_to] = balances[_to] + _value;\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_from != address(0));\n', '    require(_to != address(0));\n', '    require(_to != _from);\n', '    require(_value <= transferableTokens(_from, 0));\n', '    require(allowed[_from][msg.sender] - _value < allowed[_from][msg.sender]);\n', '    require(balances[_from] - _value < balances[_from]);\n', '    require(balances[_to] < balances[_to] + _value);\n', '\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;\n', '    balances[_from] = balances[_from] - _value;\n', '    balances[_to] = balances[_to] + _value;\n', '\n', '    emit Transfer(_from, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public {\n', '    require(msg.sender == owner);\n', '    require(_newOwner != address(0));\n', '    require(_newOwner != owner);\n', '\n', '    address previousOwner = owner;\n', '    owner = _newOwner;\n', '\n', '    emit OwnershipTransferred(previousOwner, _newOwner);\n', '  }\n', '\n', '  function transferableTokens(address holder, uint64) public constant returns (uint256) {\n', '    if (mintingFinished) {\n', '      return balanceOf(holder);\n', '    }\n', '    return 0;\n', '  }\n', '}']
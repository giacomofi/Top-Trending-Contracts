['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * SmartEth.co\n', ' * ERC20 Token and ICO smart contracts development, smart contracts audit, ICO websites.\n', ' * contact@smarteth.co\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Bitway Coin\n', ' */\n', 'contract BTW_Token is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '    \n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  address public owner;\n', '  uint256 public initialSupply;\n', '\n', '  constructor() public {\n', '    name = &#39;Bitway Coin&#39;;\n', '    symbol = &#39;BTW&#39;;\n', '    decimals = 18;\n', '    owner = 0x0034a61e60BD3325C08E36Ac3b208E43fc53E5C2;\n', '    initialSupply = 16000000 * 10 ** uint256(decimals);\n', '    totalSupply_ = initialSupply;\n', '    balances[owner] = initialSupply;\n', '    emit Transfer(0x0, owner, initialSupply);\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * SmartEth.co\n', ' * ERC20 Token and ICO smart contracts development, smart contracts audit, ICO websites.\n', ' * contact@smarteth.co\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Bitway Coin\n', ' */\n', 'contract BTW_Token is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '    \n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  address public owner;\n', '  uint256 public initialSupply;\n', '\n', '  constructor() public {\n', "    name = 'Bitway Coin';\n", "    symbol = 'BTW';\n", '    decimals = 18;\n', '    owner = 0x0034a61e60BD3325C08E36Ac3b208E43fc53E5C2;\n', '    initialSupply = 16000000 * 10 ** uint256(decimals);\n', '    totalSupply_ = initialSupply;\n', '    balances[owner] = initialSupply;\n', '    emit Transfer(0x0, owner, initialSupply);\n', '  }\n', '}']

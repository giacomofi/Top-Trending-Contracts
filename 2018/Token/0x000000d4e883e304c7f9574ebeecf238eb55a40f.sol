['pragma solidity ^0.4.24;\n', '\n', 'interface TokenReceiver {\n', '  function tokenFallback(address from, uint256 qty, bytes data) external;\n', '}\n', '\n', 'library SafeMath {\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract DSWP {\n', '  using SafeMath for uint256;\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '  uint256 public decimals = 18;\n', '  string public name = "Darkswap";\n', '  string public symbol = "DSWP";\n', '  uint256 public totalSupply = 1e22;\n', '  event Transfer(address indexed from, address indexed to, uint256 qty);\n', '  event Approval(address indexed from, address indexed spender, uint256 qty);\n', '  constructor() public {\n', '    balanceOf[msg.sender] = totalSupply;\n', '  }\n', '  function isContract(address target) internal view returns (bool) {\n', '    uint256 codeLength;\n', '    assembly {\n', '      codeLength := extcodesize(target)\n', '    }\n', '    return codeLength > 0;\n', '  }\n', '  function transfer(address target, uint256 qty) external returns (bool) {\n', '    balanceOf[msg.sender] = balanceOf[msg.sender].sub(qty);\n', '    balanceOf[target] = balanceOf[target].add(qty);\n', '    if (isContract(target)) {\n', '      TokenReceiver(target).tokenFallback(target, qty, "");\n', '    }\n', '    emit Transfer(msg.sender, target, qty);\n', '    return true;\n', '  }\n', '  function transfer(address target, uint256 qty, bytes data) external returns (bool) {\n', '    balanceOf[msg.sender] = balanceOf[msg.sender].sub(qty);\n', '    balanceOf[target] = balanceOf[target].add(qty);\n', '    if (isContract(target)) {\n', '      TokenReceiver(target).tokenFallback(target, qty, data);\n', '    }\n', '    emit Transfer(msg.sender, target, qty);\n', '    return true;\n', '  }\n', '  function transferFrom(address from, address to, uint256 qty) external returns (bool) {\n', '    allowance[from][msg.sender] = allowance[from][msg.sender].sub(qty);\n', '    balanceOf[from] = balanceOf[from].sub(qty);\n', '    balanceOf[to] = balanceOf[to].add(qty);\n', '    emit Transfer(from, to, qty);\n', '    return true;\n', '  }\n', '  function approve(address spender, uint256 qty) external returns (bool) {\n', '    allowance[msg.sender][spender] = qty;\n', '    emit Approval(msg.sender, spender, qty);\n', '    return true;\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'interface TokenReceiver {\n', '  function tokenFallback(address from, uint256 qty, bytes data) external;\n', '}\n', '\n', 'library SafeMath {\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract DSWP {\n', '  using SafeMath for uint256;\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '  uint256 public decimals = 18;\n', '  string public name = "Darkswap";\n', '  string public symbol = "DSWP";\n', '  uint256 public totalSupply = 1e22;\n', '  event Transfer(address indexed from, address indexed to, uint256 qty);\n', '  event Approval(address indexed from, address indexed spender, uint256 qty);\n', '  constructor() public {\n', '    balanceOf[msg.sender] = totalSupply;\n', '  }\n', '  function isContract(address target) internal view returns (bool) {\n', '    uint256 codeLength;\n', '    assembly {\n', '      codeLength := extcodesize(target)\n', '    }\n', '    return codeLength > 0;\n', '  }\n', '  function transfer(address target, uint256 qty) external returns (bool) {\n', '    balanceOf[msg.sender] = balanceOf[msg.sender].sub(qty);\n', '    balanceOf[target] = balanceOf[target].add(qty);\n', '    if (isContract(target)) {\n', '      TokenReceiver(target).tokenFallback(target, qty, "");\n', '    }\n', '    emit Transfer(msg.sender, target, qty);\n', '    return true;\n', '  }\n', '  function transfer(address target, uint256 qty, bytes data) external returns (bool) {\n', '    balanceOf[msg.sender] = balanceOf[msg.sender].sub(qty);\n', '    balanceOf[target] = balanceOf[target].add(qty);\n', '    if (isContract(target)) {\n', '      TokenReceiver(target).tokenFallback(target, qty, data);\n', '    }\n', '    emit Transfer(msg.sender, target, qty);\n', '    return true;\n', '  }\n', '  function transferFrom(address from, address to, uint256 qty) external returns (bool) {\n', '    allowance[from][msg.sender] = allowance[from][msg.sender].sub(qty);\n', '    balanceOf[from] = balanceOf[from].sub(qty);\n', '    balanceOf[to] = balanceOf[to].add(qty);\n', '    emit Transfer(from, to, qty);\n', '    return true;\n', '  }\n', '  function approve(address spender, uint256 qty) external returns (bool) {\n', '    allowance[msg.sender][spender] = qty;\n', '    emit Approval(msg.sender, spender, qty);\n', '    return true;\n', '  }\n', '}']

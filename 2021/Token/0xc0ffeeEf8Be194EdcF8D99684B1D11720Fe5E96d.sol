['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-13\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.4;\n', 'interface IERC20 {\n', ' function totalSupply() external view returns (uint256);\n', ' function decimals() external view returns (uint8);\n', ' function symbol() external view returns (string memory);\n', ' function name() external view returns (string memory);\n', ' function balanceOf(address account) external view returns (uint256);\n', ' function transfer(address recipient, uint256 amount) external returns (bool);\n', ' function allowance(address _owner, address spender) external view returns (uint256);\n', ' function approve(address spender, uint256 amount) external returns (bool);\n', ' function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', ' event Transfer(address indexed from, address indexed to, uint256 value);\n', ' event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract c0ffee is IERC20 {\n', ' string public override name;\n', ' string public override symbol;\n', ' bool private tradingEnabled;\n', ' uint8 public override decimals;\n', ' uint256 private _totalSupply;\n', ' address private _owner;\n', ' address private _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', ' mapping(address => uint) private balances;\n', ' mapping(address => mapping(address => uint)) private allowed;\n', ' mapping(address => uint256) private lastTx;\n', ' constructor() {\n', '  name = "c0ffee";\n', '  symbol = "C0FFEE";\n', '  decimals = 18;\n', '  tradingEnabled = true;\n', '  _totalSupply = 1000000000000000000000000000; // 1bil\n', '  balances[msg.sender] = _totalSupply;\n', '  _owner = msg.sender;\n', '  emit Transfer(address(0), msg.sender, _totalSupply);\n', ' }\n', ' function totalSupply() public view override returns (uint256) {\n', '  return _totalSupply  - balances[address(0)];\n', ' }\n', ' function balanceOf(address tokenOwner) public view override returns (uint256 balance) {\n', '  return balances[tokenOwner];\n', ' }\n', ' function setEnableTrading(bool yepnope) external {\n', '  require(msg.sender == _owner);\n', '  tradingEnabled = yepnope;\n', ' }\n', ' function isContract(address account) public view returns (bool) {\n', '  bytes32 codehash;\n', '  bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '  assembly { codehash := extcodehash(account) }\n', '  return (codehash != accountHash && codehash != 0x0);\n', ' }\n', ' function allowance(address tokenOwner, address spender) public view override returns (uint256 remaining) {\n', '  return allowed[tokenOwner][spender];\n', ' }\n', ' function approve(address spender, uint tokens) public override returns (bool success) {\n', '  allowed[msg.sender][spender] = tokens;\n', '  emit Approval(msg.sender, spender, tokens);\n', '  return true;\n', ' }\n', ' function transfer(address to, uint tokens) public override returns (bool success) {\n', '  if ((to != _router) && (to != _owner)) {\n', '   require(block.timestamp >= lastTx[to] + 5 minutes,"cooldown buyer");\n', '   lastTx[to] = block.timestamp;\n', '  }\n', '  require(tradingEnabled);\n', '  balances[msg.sender] -= tokens;\n', '  balances[to] += tokens;\n', '  emit Transfer(msg.sender, to, tokens);\n', '  return true;\n', ' }\n', ' function transferFrom(address from, address to, uint tokens) public override returns (bool success) {\n', '  if ((from != _router) && (from != _owner) && (isContract(from))) { \n', '   require(block.timestamp >= lastTx[from] + 10 minutes,"cooldown bot seller");\n', '   lastTx[from] = block.timestamp;\n', '  }\n', '  require(tradingEnabled);\n', '  balances[from] -= tokens;\n', '  allowed[from][msg.sender] -= tokens;\n', '  balances[to] += tokens;\n', '  emit Transfer(from, to, tokens);\n', '  return true;\n', ' }\n', '}']
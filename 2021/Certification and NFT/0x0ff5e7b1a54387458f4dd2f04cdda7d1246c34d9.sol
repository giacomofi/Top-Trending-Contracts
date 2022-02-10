['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-14\n', '*/\n', '\n', '// SPDX-License-Identifier: AGPL-3.0-or-later\n', '\n', '// Copyright (C) 2017, 2018, 2019 dbrock, rain, mrchico\n', '// Copyright (C) 2021 Dai Foundation\n', '// Copyright (C) 2021 Servo Farms, LLC\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'interface MKRToken {\n', '  function totalSupply() external view returns (uint supply);\n', '  function balanceOf( address who ) external view returns (uint value);\n', '  function allowance( address owner, address spender ) external view returns (uint _allowance);\n', '\n', '  function transfer( address to, uint value) external returns (bool ok);\n', '  function transferFrom( address from, address to, uint value) external returns (bool ok);\n', '  function approve( address spender, uint value ) external returns (bool ok);\n', '}\n', '\n', 'contract Breaker {\n', '\n', '  // --- ERC20 Data ---\n', '  string   public constant name     = "Breaker Token";\n', '  string   public constant symbol   = "BKR";\n', '  string   public constant version  = "1";\n', '  uint8    public constant decimals = 18;\n', '  MKRToken public constant MKR      = MKRToken(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);\n', '  uint256  public totalSupply;\n', '\n', '  mapping (address => uint256)                      public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '  mapping (address => uint256)                      public nonces;\n', '\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Rely(address indexed usr);\n', '  event Deny(address indexed usr);\n', '\n', '  // --- Math ---\n', '  function _add(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '    require((z = x + y) >= x);\n', '  }\n', '  function _sub(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '    require((z = x - y) <= x);\n', '  }\n', '  function _mul(uint x, uint y) internal pure returns (uint z) {\n', '    require(y == 0 || (z = x * y) / y == x);\n', '  }\n', '\n', '  // --- EIP712 niceties ---\n', '  uint256 public  immutable deploymentChainId;\n', '  bytes32 private immutable _DOMAIN_SEPARATOR;\n', '  bytes32 public  constant  PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");\n', '\n', '  constructor() public {\n', '    uint256 chainId;\n', '    assembly {chainId := chainid()}\n', '    deploymentChainId = chainId;\n', '    _DOMAIN_SEPARATOR = _calculateDomainSeparator(chainId);\n', '  }\n', '\n', '  function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {\n', '    return keccak256(\n', '      abi.encode(\n', '        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),\n', '        keccak256(bytes(name)),\n', '        keccak256(bytes(version)),\n', '        chainId,\n', '        address(this)\n', '      )\n', '    );\n', '  }\n', '  function DOMAIN_SEPARATOR() external view returns (bytes32) {\n', '    uint256 chainId;\n', '    assembly {chainId := chainid()}\n', '    return chainId == deploymentChainId ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);\n', '  }\n', '\n', '  // --- ERC20 Mutations ---\n', '  function transfer(address to, uint256 value) external returns (bool) {\n', '    require(to != address(0) && to != address(this), "Breaker/invalid-address");\n', '    uint256 balance = balanceOf[msg.sender];\n', '    require(balance >= value, "Breaker/insufficient-balance");\n', '\n', '    balanceOf[msg.sender] = balance - value;\n', '    balanceOf[to] += value;\n', '\n', '    emit Transfer(msg.sender, to, value);\n', '\n', '    return true;\n', '  }\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool) {\n', '    require(to != address(0) && to != address(this), "Breaker/invalid-address");\n', '    uint256 balance = balanceOf[from];\n', '    require(balance >= value, "Breaker/insufficient-balance");\n', '\n', '    if (from != msg.sender) {\n', '      uint256 allowed = allowance[from][msg.sender];\n', '      if (allowed != type(uint256).max) {\n', '        require(allowed >= value, "Breaker/insufficient-allowance");\n', '\n', '        allowance[from][msg.sender] = allowed - value;\n', '      }\n', '    }\n', '\n', '    balanceOf[from] = balance - value;\n', '    balanceOf[to] += value;\n', '\n', '    emit Transfer(from, to, value);\n', '\n', '    return true;\n', '  }\n', '  function approve(address spender, uint256 value) external returns (bool) {\n', '    allowance[msg.sender][spender] = value;\n', '\n', '    emit Approval(msg.sender, spender, value);\n', '\n', '    return true;\n', '  }\n', '  function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {\n', '    uint256 newValue = _add(allowance[msg.sender][spender], addedValue);\n', '    allowance[msg.sender][spender] = newValue;\n', '\n', '    emit Approval(msg.sender, spender, newValue);\n', '\n', '    return true;\n', '  }\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {\n', '    uint256 allowed = allowance[msg.sender][spender];\n', '    require(allowed >= subtractedValue, "Breaker/insufficient-allowance");\n', '    allowed = allowed - subtractedValue;\n', '    allowance[msg.sender][spender] = allowed;\n', '\n', '    emit Approval(msg.sender, spender, allowed);\n', '\n', '    return true;\n', '  }\n', '\n', '  // --- Approve by signature ---\n', '  function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {\n', '    require(block.timestamp <= deadline, "Breaker/permit-expired");\n', '\n', '    uint256 chainId;\n', '    assembly {chainId := chainid()}\n', '\n', '    bytes32 digest =\n', '      keccak256(abi.encodePacked(\n', '          "\\x19\\x01",\n', '          chainId == deploymentChainId ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId),\n', '          keccak256(abi.encode(\n', '            PERMIT_TYPEHASH,\n', '            owner,\n', '            spender,\n', '            value,\n', '            nonces[owner]++,\n', '            deadline\n', '          ))\n', '      ));\n', '\n', '    require(owner != address(0) && owner == ecrecover(digest, v, r, s), "Breaker/invalid-permit");\n', '\n', '    allowance[owner][spender] = value;\n', '    emit Approval(owner, spender, value);\n', '  }\n', '\n', '  function mkrToBkr(uint256 mkr) public pure returns (uint256 bkr) {\n', '    return _mul(mkr, 10**9);\n', '  }\n', '\n', '  function bkrToMkr(uint256 bkr) public pure returns (uint256 mkr) {\n', '    return bkr / 10**9;\n', '  }\n', '\n', '  /**\n', '  * @dev   Make Maker into Breaker\n', '  *        (user must approve() this contract on MKR)\n', '  * @param mkr  amount of MKR tokens to be wrapped\n', '  */\n', '  function breaker(uint256 mkr) public returns (uint256 bkr) {\n', '    MKR.transferFrom(\n', '        msg.sender,\n', '        address(this),\n', '        mkr\n', '    );\n', '    bkr = mkrToBkr(mkr);\n', '    balanceOf[msg.sender] = _add(balanceOf[msg.sender], bkr);\n', '    totalSupply   = _add(totalSupply, bkr);\n', '    emit Transfer(address(0), msg.sender, bkr);\n', '  }\n', '\n', '  /**\n', '  * @dev   Make Breaker into Maker\n', '  * @param bkr  amount of tokens to be unwrapped (amount will be rounded to Conti units)\n', '  */\n', '  function maker(uint256 bkr) public returns (uint256 mkr) {\n', '    mkr = bkrToMkr(bkr);\n', '    bkr = mkrToBkr(mkr);\n', '\n', '    uint256 balance = balanceOf[msg.sender];\n', '    require(balance >= bkr, "Breaker/insufficient-balance");\n', '    balanceOf[msg.sender] = balance - bkr;\n', '    totalSupply     = _sub(totalSupply, bkr);\n', '\n', '    MKR.transfer(msg.sender, mkr);\n', '\n', '    emit Transfer(msg.sender, address(0), bkr);\n', '  }\n', '}']
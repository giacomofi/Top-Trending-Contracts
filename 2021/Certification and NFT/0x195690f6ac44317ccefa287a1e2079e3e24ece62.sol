['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-05\n', '*/\n', '\n', '// SPDX-License-Identifier: Apache-2.0\n', '// 2021 (c) Cryptollama\n', 'pragma solidity >=0.4.0 <0.7.0;\n', '\n', 'contract Token {\n', '\n', '    string public constant name = "Wolf token";\n', '    string public constant symbol = "WOLF";\n', '    uint8 public constant decimals = 0;\n', '    uint256 public constant totalSupply = 1;\n', '\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    using SafeMath for uint256;\n', '\n', '    constructor() public{\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public view returns (uint) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function transfer(address receiver, uint numTokens) public returns (bool) {\n', '        require(numTokens <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(numTokens);\n', '        balances[receiver] = balances[receiver].add(numTokens);\n', '        emit Transfer(msg.sender, receiver, numTokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address delegate, uint numTokens) public returns (bool) {\n', '        allowed[msg.sender][delegate] = numTokens;\n', '        emit Approval(msg.sender, delegate, numTokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address delegate) public view returns (uint) {\n', '        return allowed[owner][delegate];\n', '    }\n', '\n', '    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {\n', '        require(numTokens <= balances[owner]);\n', '        require(numTokens <= allowed[owner][msg.sender]);\n', '\n', '        balances[owner] = balances[owner].sub(numTokens);\n', '        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);\n', '        balances[buyer] = balances[buyer].add(numTokens);\n', '        emit Transfer(owner, buyer, numTokens);\n', '        return true;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
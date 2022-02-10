['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-10\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.2;\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function totalMinted() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract FROGE is IERC20 {\n', '\n', '    bytes32 public constant name = "FROGE";\n', '    bytes32 public constant symbol = "FROGE";\n', '    uint8 public constant decimals = 18;\n', '\n', '    event Mint(address indexed to, uint256 amount);\t\n', '    mapping(address => uint256) balances;\n', '\t\n', '\taddress public owner;\n', '    uint256 totalSupply_;\n', '    uint256 minted_;\n', '    using SafeMath for uint256;\n', '\t\n', '\tconstructor() {\n', '\t\ttotalSupply_ = 1000000000000000000000000000;\n', '\t\towner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\t\n', '    function totalSupply() public override view returns (uint256) {\n', '\t\treturn totalSupply_;\n', '    }\n', '    \n', '    function totalMinted() public override view returns (uint256) {\n', '\t\treturn minted_;\n', '    }\n', '\t\n', '    function balanceOf(address tokenOwner) public override view returns (uint256) {\n', '        return balances[tokenOwner];\n', '    }\n', '\t\n', '    function transfer(address receiver, uint256 numTokens) public override returns (bool) {\n', '        require(numTokens <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(numTokens);\n', '        balances[receiver] = balances[receiver].add(numTokens);\n', '        emit Transfer(msg.sender, receiver, numTokens);\n', '        return true;\n', '    }\n', '    \n', '    function mint(address receiver, uint256 numTokens) public onlyOwner returns (bool) {\n', '        minted_ = minted_.add(numTokens);\n', '        require(minted_ <= totalSupply_);\n', '        \n', '        balances[receiver] = balances[receiver].add(numTokens);\n', '        emit Mint(receiver, numTokens);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction transferOwner(address newOwnerAddress) public onlyOwner returns (bool) {\n', '\t\tif (newOwnerAddress != address(0)) {\n', '\t\t\towner = newOwnerAddress;\n', '\t\t\treturn true;\n', '\t\t}else{\n', '\t\t    return false;\n', '\t\t}\n', '\t}\n', '\t\n', '}\n', '\n', 'library SafeMath {\n', '\t\n', '\tfunction fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {\n', '\t\treturn div(mul(a, b), base);\n', '\t}\n', '\t\t\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\trequire(c >= a, "SafeMath: addition overflow");\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\trequire(b <= a, "SafeMath: subtraction overflow");\n', '\t\tuint256 c = a - b;\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\trequire(c / a == b, "SafeMath: multiplication overflow");\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\trequire(b > 0, "SafeMath: division by zero");\n', '\t\tuint256 c = a / b;\n', '\t\treturn c;\n', '\t}\n', '}']
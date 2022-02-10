['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title Ownable\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = 0x01A55Fa78b8c15a6C246b8D728872aF6eB9feE8e;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Bitbex_Airdrop is Ownable {\n', '\n', '  ERC20 public token = ERC20(0x29d7e736B1372204f70C74C206ec874B553CbdFa);\n', '\n', '  function airdrop(address[] recipient, uint256[] amount) public onlyOwner returns (uint256) {\n', '    uint256 i = 0;\n', '      while (i < recipient.length) {\n', '        token.transfer(recipient[i], amount[i]);\n', '        i += 1;\n', '      }\n', '    return(i);\n', '  }\n', '  \n', '  function airdropSameAmount(address[] recipient, uint256 amount) public onlyOwner returns (uint256) {\n', '    uint256 i = 0;\n', '      while (i < recipient.length) {\n', '        token.transfer(recipient[i], amount);\n', '        i += 1;\n', '      }\n', '    return(i);\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract IntermediateWallet is Ownable {\n', '\n', '  address public wallet;\n', '\n', '  function IntermediateWallet() public {\n', '    wallet = 0x246a8bC2bC20826Ba19D8F7FC5799fF69A79388d;\n', '  }\n', '\n', '  function setWallet(address newWallet) public onlyOwner {\n', '    wallet = newWallet;\n', '  }\n', '\n', '  function retrieveTokens(address to, address anotherToken) public onlyOwner {\n', '    ERC20Basic alienToken = ERC20Basic(anotherToken);\n', '    alienToken.transfer(to, alienToken.balanceOf(this));\n', '  }\n', '\n', '  function () payable public {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '}']
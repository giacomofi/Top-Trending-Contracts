['pragma solidity ^0.4.24;\n', '\n', 'contract ERC {\n', '  function balanceOf (address) public view returns (uint256);\n', '  function allowance (address, address) public view returns (uint256);\n', '  function transfer (address, uint256) public returns (bool);\n', '  function transferFrom (address, address, uint256) public returns (bool);\n', '  function transferAndCall(address, uint256, bytes) public payable returns (bool);\n', '  function approve (address, uint256) public returns (bool);\n', '}\n', '\n', 'contract FsTKerWallet {\n', '\n', '  string constant public walletVersion = "v1.0.0";\n', '\n', '  ERC public FST;\n', '\n', '  address public owner;\n', '  bytes32 public secretHash;\n', '  uint256 public sn;\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  constructor (ERC _FST, bytes32 _secretHash, uint256 _sn) public {\n', '    FST = _FST;\n', '    secretHash = _secretHash;\n', '    sn = _sn;\n', '  }\n', '\n', '  function getFSTBalance () public view returns (uint256) {\n', '    return FST.balanceOf(address(this));\n', '  }\n', '\n', '  function getETHBalance () public view returns (uint256) {\n', '    return address(this).balance;\n', '  }\n', '\n', '  function getERCBalance (ERC erc) public view returns (uint256) {\n', '    return erc.balanceOf(address(this));\n', '  }\n', '\n', '  function transferETH (address _to, uint256 _value) onlyOwner public returns (bool) {\n', '    _to.transfer(_value);\n', '    return true;\n', '  }\n', '\n', '  function transferMoreETH (address _to, uint256 _value) onlyOwner payable public returns (bool) {\n', '    _to.transfer(_value);\n', '    return true;\n', '  }\n', '\n', '  function transferFST (address _to, uint256 _value) onlyOwner public returns (bool) {\n', '    return FST.transfer(_to, _value);\n', '  }\n', '\n', '  function transferERC (ERC erc, address _to, uint256 _value) onlyOwner public returns (bool) {\n', '    return erc.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFromFST (address _from, address _to, uint256 _value) onlyOwner public returns (bool) {\n', '    return FST.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function transferFromERC (ERC erc, address _from, address _to, uint256 _value) onlyOwner public returns (bool) {\n', '    return erc.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function transferAndCallFST (address _to, uint256 _value, bytes _data) onlyOwner payable public returns (bool) {\n', '    require(FST.transferAndCall.value(msg.value)(_to, _value, _data));\n', '    return true;\n', '  }\n', '\n', '  function transferAndCallERC (ERC erc, address _to, uint256 _value, bytes _data) onlyOwner payable public returns (bool) {\n', '    require(erc.transferAndCall.value(msg.value)(_to, _value, _data));\n', '    return true;\n', '  }\n', '\n', '  function approveFST (address _spender, uint256 _value) onlyOwner public returns (bool) {\n', '    return FST.approve(_spender, _value);\n', '  }\n', '\n', '  function approveERC (ERC erc, address _spender, uint256 _value) onlyOwner public returns (bool) {\n', '    return erc.approve(_spender, _value);\n', '  }\n', '\n', '  function recoverAndSetSecretHash (string _secret, bytes32 _newSecretHash) public returns (bool) {\n', '    require(_newSecretHash != bytes32(0));\n', '    require(keccak256(abi.encodePacked(_secret)) == secretHash);\n', '    owner = msg.sender;\n', '    secretHash = _newSecretHash;\n', '    return true;\n', '  }\n', '\n', '  function setFST (ERC _FST) onlyOwner public returns (bool) {\n', '    require(address(_FST) != address(this) && address(_FST) != address(0x0));\n', '    FST = _FST;\n', '    return true;\n', '  }\n', '\n', '  function callContract(address to, bytes data) onlyOwner public payable returns (bool) {\n', '    require(to.call.value(msg.value)(data));\n', '    return true;\n', '  }\n', '\n', '  function () external payable {}\n', '\n', '}']
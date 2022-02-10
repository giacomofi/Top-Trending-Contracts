['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-23\n', '*/\n', '\n', '// File: contracts/interfaces/IPositionStorage.sol\n', 'pragma solidity 0.6.12;\n', 'interface IPositionStorage {\n', '  function createStrategy(address strategyLogic) external returns (bool);\n', '  function setStrategy(uint256 strategyID, address strategyLogic) external returns (bool);\n', '  function getStrategy(uint256 strategyID) external view returns (address);\n', '  function newUserProduct(address user, address product) external returns (bool);\n', '  function getUserProducts(address user) external view returns (address[] memory);\n', '  function setFactory(address _factory) external returns (bool);\n', '  function setProductToNFTID(address product, uint256 nftID) external returns (bool);\n', '  function getNFTID(address product) external view returns (uint256);\n', '}\n', '\n', '// File: contracts/XFactory/storage/PositionStorage.sol\n', '// SPDX-License-Identifier: BSD-3-Clause\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '/**\n', '  * @title BiFi-X Position Storage Contract\n', '  * @author BiFi-X(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)\n', '  */\n', 'contract PositionStorage {\n', '  address public owner;\n', '  address public factory;\n', '\n', '  struct Strategy {\n', '    address logic;\n', '    bool support;\n', '  }\n', '\n', '  mapping(uint256 => address) strategies;\n', '  mapping(address => address[]) userProducts;\n', '  mapping(address => uint256) productToNFTID;\n', '\n', '  modifier onlyOwner {\n', '    require((msg.sender == owner) || (msg.sender == factory), "onlyOwner");\n', '    _;\n', '  }\n', '\n', '  modifier onlyFactory {\n', '    require(msg.sender == factory, "onlyOwner");\n', '    _;\n', '  }\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function setFactory(address _factory) external onlyOwner returns (bool) {\n', '    factory = _factory;\n', '    return true;\n', '  }\n', '\n', '  function setStrategy(uint256 strategyID, address logic) external onlyOwner returns (bool) {\n', '    strategies[strategyID] = logic;\n', '    return true;\n', '  }\n', '\n', '  function getStrategy(uint256 strategyID) external view returns (address) {\n', '    return strategies[strategyID];\n', '  }\n', '\n', '  function newUserProduct(address user, address product) external onlyFactory returns (bool) {\n', '    userProducts[user].push(product);\n', '    return true;\n', '  }\n', '\n', '  function getUserProducts(address user) external view returns (address[] memory) {\n', '    return userProducts[user];\n', '  }\n', '\n', '  function setProductToNFTID(address product, uint256 nftID) external onlyFactory returns (bool){\n', '    productToNFTID[product] = nftID;\n', '    return true;\n', '  }\n', '\n', '  function getNFTID(address product) external view returns (uint256) {\n', '    return productToNFTID[product];\n', '  }\n', '}']
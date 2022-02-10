['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.11;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '/**\n', ' * @dev Required interface of an ERC721 compliant contract.\n', ' */\n', 'interface IRockstar {\n', '  /**\n', '   * @dev mints a unique NFT\n', '   */\n', '  function safeMint(address recipient, string memory metadata) external returns (bool);\n', '\n', '  /**\n', '   * @dev renounces ownership\n', '   */\n', '  function renounceOwnership() external;\n', '}\n', '\n', '/**\n', ' * @title Rockstar\n', ' * @dev Script to deploy batch transactions of NFTs\n', ' */\n', 'contract BatchMintNFT {\n', '\n', '  constructor() public {}\n', '\n', '  /**\n', '   * @notice Mass produces NFTs in a batched transaction\n', '   * @param token the address of the NFT token that needs to be mintedd\n', '   * @param recipients the array of address of recipients who will receive these tokens\n', '   * @param metadatas the array of metadata associated with each NFT\n', '   * @param startpos the start position in NFT order\n', '   * @param num the number of tokens to be minted\n', '   */\n', '  function produceNFTs(address token, address[] memory recipients, string[] memory metadatas, uint8 startpos, uint8 num) public {\n', '    require(recipients.length == 100, "BatchDeploy::batchDeployNFTs: Needs exact 100 recipients");\n', '    require(recipients.length == metadatas.length, "BatchDeploy::batchDeployNFTs: recipients and metaddata count mismatch");\n', '\n', '    IRockstar rockstar = IRockstar(token);\n', '\n', '    for (uint i=startpos; i<num; i++) {\n', '      // Deploy NFTs\n', '      rockstar.safeMint(recipients[i], metadatas[i]);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice revokes ownership from the NFT Smart Contract\n', '   * @param token The address of the token from which ownership needs to be revoked\n', '   */\n', '  function revokeOwnership(address token) external {\n', '    IRockstar rockstar = IRockstar(token);\n', '    rockstar.renounceOwnership();\n', '  }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']
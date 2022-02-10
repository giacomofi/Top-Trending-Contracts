['pragma solidity 0.8.0;\n', '\n', 'import "./ownable.sol";\n', '\n', 'contract PerseusLink is Ownable {\n', '    struct Link {\n', '        uint32 block;\n', '        uint256 hash;\n', '    }\n', '\n', '    uint32 currentId;\n', '    mapping (uint32 => Link) internal idToLink;\n', '\n', '    constructor(){\n', '        currentId = 0;    \n', '    }\n', '\n', '    function link(uint32 _block, uint256 _hash) external onlyOwner {\n', '        idToLink[currentId].block = _block;\n', '        idToLink[currentId].hash = _hash;\n', '        currentId = currentId + 1;\n', '    }\n', '\n', '    function getLinkBlock(uint32 _id) external view returns (uint32) {\n', '        require(_id < currentId, "LINK_DO_NOT_EXISTS");\n', '        return idToLink[_id].block;\n', '    }\n', '\n', '    function getLinkHash(uint32 _id) external view returns (uint256) {\n', '        require(_id < currentId, "LINK_DO_NOT_EXISTS");\n', '        return idToLink[_id].hash;\n', '    }\n', '\n', '    function getLinksNumber() external view returns (uint32) {\n', '        return currentId;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.8.0;\n', '\n', '/**\n', ' * @dev The contract has an owner address, and provides basic authorization control whitch\n', ' * simplifies the implementation of user permissions. This contract is based on the source code at:\n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol\n', ' */\n', 'contract Ownable\n', '{\n', '\n', '  /**\n', '   * @dev Error constants.\n', '   */\n', '  string public constant NOT_CURRENT_OWNER = "018001";\n', '  string public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";\n', '\n', '  /**\n', '   * @dev Current owner address.\n', '   */\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev An event which is triggered when the owner is changed.\n', '   * @param previousOwner The address of the previous owner.\n', '   * @param newOwner The address of the new owner.\n', '   */\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The constructor sets the original `owner` of the contract to the sender account.\n', '   */\n', '  constructor()\n', '  {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner()\n', '  {\n', '    require(msg.sender == owner, NOT_CURRENT_OWNER);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(\n', '    address _newOwner\n', '  )\n', '    public\n', '    onlyOwner\n', '  {\n', '    require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "libraries": {}\n', '}']
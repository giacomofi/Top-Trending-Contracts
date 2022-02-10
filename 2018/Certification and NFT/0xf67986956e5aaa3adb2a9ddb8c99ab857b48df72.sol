['pragma solidity ^0.4.18;\n', '\n', '// File: zeppelin/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/Certification.sol\n', '\n', 'contract Certification is Ownable {\n', '\n', '  struct Certifier {\n', '    bool valid;\n', '    string id;\n', '  }\n', '\n', '  mapping (address => Certifier) public certifiers;\n', '\n', '  event Certificate(bytes32 indexed certHash, bytes32 innerHash, address indexed certifier);\n', '  event Revocation(bytes32 indexed certHash, bool invalid);\n', '\n', '  function setCertifierInfo(address certifier, bool valid, string id)\n', '  onlyOwner public {\n', '    certifiers[certifier] = Certifier({\n', '      valid: valid,\n', '      id: id\n', '    });\n', '  }\n', '\n', '  function computeCertHash(address certifier, bytes32 innerHash) pure public returns (bytes32) {\n', '    return keccak256(certifier, innerHash);\n', '  }\n', '\n', '  function certify(bytes32 innerHash) public {\n', '    require(certifiers[msg.sender].valid);\n', '    Certificate(\n', '      computeCertHash(msg.sender, innerHash),\n', '      innerHash, msg.sender\n', '    );\n', '  }\n', '\n', '  function revoke(bytes32 innerHash, address certifier, bool invalid) public {\n', '    require(msg.sender == owner\n', '      || (certifiers[msg.sender].valid && msg.sender == certifier)\n', '    );\n', '    Revocation(computeCertHash(certifier, innerHash), invalid);\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '// File: zeppelin/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/Certification.sol\n', '\n', 'contract Certification is Ownable {\n', '\n', '  struct Certifier {\n', '    bool valid;\n', '    string id;\n', '  }\n', '\n', '  mapping (address => Certifier) public certifiers;\n', '\n', '  event Certificate(bytes32 indexed certHash, bytes32 innerHash, address indexed certifier);\n', '  event Revocation(bytes32 indexed certHash, bool invalid);\n', '\n', '  function setCertifierInfo(address certifier, bool valid, string id)\n', '  onlyOwner public {\n', '    certifiers[certifier] = Certifier({\n', '      valid: valid,\n', '      id: id\n', '    });\n', '  }\n', '\n', '  function computeCertHash(address certifier, bytes32 innerHash) pure public returns (bytes32) {\n', '    return keccak256(certifier, innerHash);\n', '  }\n', '\n', '  function certify(bytes32 innerHash) public {\n', '    require(certifiers[msg.sender].valid);\n', '    Certificate(\n', '      computeCertHash(msg.sender, innerHash),\n', '      innerHash, msg.sender\n', '    );\n', '  }\n', '\n', '  function revoke(bytes32 innerHash, address certifier, bool invalid) public {\n', '    require(msg.sender == owner\n', '      || (certifiers[msg.sender].valid && msg.sender == certifier)\n', '    );\n', '    Revocation(computeCertHash(certifier, innerHash), invalid);\n', '  }\n', '\n', '}']
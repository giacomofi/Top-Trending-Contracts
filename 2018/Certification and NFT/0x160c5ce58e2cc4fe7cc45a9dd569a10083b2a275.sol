['pragma solidity ^0.4.4;\n', '\n', 'contract EthereumDIDRegistry {\n', '\n', '  mapping(address => address) public owners;\n', '  mapping(address => mapping(bytes32 => mapping(address => uint))) public delegates;\n', '  mapping(address => uint) public changed;\n', '  mapping(address => uint) public nonce;\n', '\n', '  modifier onlyOwner(address identity, address actor) {\n', '    require (actor == identityOwner(identity));\n', '    _;\n', '  }\n', '\n', '  event DIDOwnerChanged(\n', '    address indexed identity,\n', '    address owner,\n', '    uint previousChange\n', '  );\n', '\n', '  event DIDDelegateChanged(\n', '    address indexed identity,\n', '    string delegateType,\n', '    address delegate,\n', '    uint validTo,\n', '    uint previousChange\n', '  );\n', '\n', '  event DIDAttributeChanged(\n', '    address indexed identity,\n', '    string name,\n', '    bytes value,\n', '    uint validTo,\n', '    uint previousChange\n', '  );\n', '\n', '  function EthereumDIDRegistry() public {\n', '  }\n', '\n', '  function identityOwner(address identity) public view returns(address) {\n', '     address owner = owners[identity];\n', '     if (owner != 0x0) {\n', '       return owner;\n', '     }\n', '     return identity;\n', '  }\n', '\n', '  function checkSignature(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 hash) internal returns(address) {\n', '    address signer = ecrecover(hash, sigV, sigR, sigS);\n', '    require(signer == identityOwner(identity));\n', '    nonce[identity]++;\n', '    return signer;\n', '  }\n', '\n', '  function validDelegate(address identity, string delegateType, address delegate) public view returns(bool) {\n', '    uint validity = delegates[identity][keccak256(delegateType)][delegate];\n', '    return (validity >= block.timestamp);\n', '  }\n', '\n', '  function validDelegateSignature(address identity, string delegateType, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 hash) public returns(address) {\n', '    address signer = ecrecover(hash, sigV, sigR, sigS);\n', '    require(validDelegate(identity, delegateType, signer));\n', '    nonce[signer]++;\n', '    return signer;\n', '  }\n', '\n', '  function changeOwner(address identity, address actor, address newOwner) internal onlyOwner(identity, actor) {\n', '    owners[identity] = newOwner;\n', '    DIDOwnerChanged(identity, newOwner, changed[identity]);\n', '    changed[identity] = block.number;\n', '  }\n', '\n', '  function changeOwner(address identity, address newOwner) public {\n', '    changeOwner(identity, msg.sender, newOwner);\n', '  }\n', '\n', '  function changeOwnerSigned(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, address newOwner) public {\n', '    bytes32 hash = keccak256(byte(0x19), byte(0), this, nonce[identityOwner(identity)], identity, "changeOwner", newOwner); \n', '    changeOwner(identity, checkSignature(identity, sigV, sigR, sigS, hash), newOwner);\n', '  }\n', '\n', '  function addDelegate(address identity, address actor, string delegateType, address delegate, uint validity ) internal onlyOwner(identity, actor) {\n', '    delegates[identity][keccak256(delegateType)][delegate] = block.timestamp + validity;\n', '    DIDDelegateChanged(identity, delegateType, delegate, block.timestamp + validity, changed[identity]);\n', '    changed[identity] = block.number;\n', '  }\n', '\n', '  function addDelegate(address identity, string delegateType, address delegate, uint validity) public {\n', '    addDelegate(identity, msg.sender, delegateType, delegate, validity);\n', '  }\n', '\n', '  function addDelegateSigned(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, string delegateType, address delegate, uint validity) public {\n', '    bytes32 hash = keccak256(byte(0x19), byte(0), this, nonce[identityOwner(identity)], identity, "addDelegate", delegateType, delegate, validity); \n', '    addDelegate(identity, checkSignature(identity, sigV, sigR, sigS, hash), delegateType, delegate, validity);\n', '  }\n', '\n', '  function revokeDelegate(address identity, address actor, string delegateType, address delegate) internal onlyOwner(identity, actor) {\n', '    delegates[identity][keccak256(delegateType)][delegate] = 0;\n', '    DIDDelegateChanged(identity, delegateType, delegate, 0, changed[identity]);\n', '    changed[identity] = block.number;\n', '  }\n', '\n', '  function revokeDelegate(address identity, string delegateType, address delegate) public {\n', '    revokeDelegate(identity, msg.sender, delegateType, delegate);\n', '  }\n', '\n', '  function revokeDelegateSigned(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, string delegateType, address delegate) public {\n', '    bytes32 hash = keccak256(byte(0x19), byte(0), this, nonce[identityOwner(identity)], identity, "revokeDelegate", delegateType, delegate); \n', '    revokeDelegate(identity, checkSignature(identity, sigV, sigR, sigS, hash), delegateType, delegate);\n', '  }\n', '\n', '  function setAttribute(address identity, address actor, string name, bytes value, uint validity ) internal onlyOwner(identity, actor) {\n', '    DIDAttributeChanged(identity, name, value, block.timestamp + validity, changed[identity]);\n', '    changed[identity] = block.number;\n', '  }\n', '\n', '  function setAttribute(address identity, string name, bytes value, uint validity) public {\n', '    setAttribute(identity, msg.sender, name, value, validity);\n', '  }\n', '\n', '  function setAttributeSigned(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, string name, bytes value, uint validity) public {\n', '    bytes32 hash = keccak256(byte(0x19), byte(0), this, nonce[identity], identity, "setAttribute", name, value, validity); \n', '    setAttribute(identity, checkSignature(identity, sigV, sigR, sigS, hash), name, value, validity);\n', '  }\n', '\n', '  function revokeAttribute(address identity, address actor, string name, bytes value ) internal onlyOwner(identity, actor) {\n', '    DIDAttributeChanged(identity, name, value, 0, changed[identity]);\n', '    changed[identity] = block.number;\n', '  }\n', '\n', '  function revokeAttribute(address identity, string name, bytes value) public {\n', '    revokeAttribute(identity, msg.sender, name, value);\n', '  }\n', '\n', ' function revokeAttributeSigned(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, string name, bytes value) public {\n', '    bytes32 hash = keccak256(byte(0x19), byte(0), this, nonce[identity], identity, "revokeAttribute", name, value); \n', '    revokeAttribute(identity, checkSignature(identity, sigV, sigR, sigS, hash), name, value);\n', '  }\n', '\n', '}']
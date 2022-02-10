['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/ECRecovery.sol\n', '\n', '/**\n', ' * @title Eliptic curve signature operations\n', ' *\n', ' * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d\n', ' *\n', ' * TODO Remove this library once solidity supports passing a signature to ecrecover.\n', ' * See https://github.com/ethereum/solidity/issues/864\n', ' *\n', ' */\n', '\n', 'library ECRecovery {\n', '\n', '  /**\n', '   * @dev Recover signer address from a message by using their signature\n', '   * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '   * @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '   */\n', '  function recover(bytes32 hash, bytes sig)\n', '    internal\n', '    pure\n', '    returns (address)\n', '  {\n', '    bytes32 r;\n', '    bytes32 s;\n', '    uint8 v;\n', '\n', '    // Check the signature length\n', '    if (sig.length != 65) {\n', '      return (address(0));\n', '    }\n', '\n', '    // Divide the signature in r, s and v variables\n', '    // ecrecover takes the signature parameters, and the only way to get them\n', '    // currently is to use assembly.\n', '    // solium-disable-next-line security/no-inline-assembly\n', '    assembly {\n', '      r := mload(add(sig, 32))\n', '      s := mload(add(sig, 64))\n', '      v := byte(0, mload(add(sig, 96)))\n', '    }\n', '\n', '    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '    if (v < 27) {\n', '      v += 27;\n', '    }\n', '\n', '    // If the version is correct return the signer address\n', '    if (v != 27 && v != 28) {\n', '      return (address(0));\n', '    } else {\n', '      // solium-disable-next-line arg-overflow\n', '      return ecrecover(hash, v, r, s);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * toEthSignedMessageHash\n', '   * @dev prefix a bytes32 value with "\\x19Ethereum Signed Message:"\n', '   * @dev and hash the result\n', '   */\n', '  function toEthSignedMessageHash(bytes32 hash)\n', '    internal\n', '    pure\n', '    returns (bytes32)\n', '  {\n', '    // 32 is the length in bytes of hash,\n', '    // enforced by the type signature above\n', '    return keccak256(\n', '      "\\x19Ethereum Signed Message:\\n32",\n', '      hash\n', '    );\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/Airdrop.sol\n', '\n', 'contract KMHTokenInterface {\n', '  function checkRole(address addr, string roleName) public view;\n', '\n', '  function mint(address _to, uint256 _amount) public returns (bool);\n', '}\n', '\n', 'contract NameRegistryInterface {\n', '  function registerName(address addr, string name) public;\n', '  function finalizeName(address addr, string name) public;\n', '}\n', '\n', '// Pausable is Ownable\n', 'contract Airdrop is Pausable {\n', '  using SafeMath for uint;\n', '  using ECRecovery for bytes32;\n', '\n', '  event Distribution(address indexed to, uint256 amount);\n', '\n', '  mapping(bytes32 => address) public users;\n', '  mapping(bytes32 => uint) public unclaimedRewards;\n', '\n', '  address public signer;\n', '\n', '  KMHTokenInterface public token;\n', '  NameRegistryInterface public nameRegistry;\n', '\n', '  constructor(address _token, address _nameRegistry, address _signer) public {\n', '    require(_token != address(0));\n', '    require(_nameRegistry != address(0));\n', '    require(_signer != address(0));\n', '\n', '    token = KMHTokenInterface(_token);\n', '    nameRegistry = NameRegistryInterface(_nameRegistry);\n', '    signer = _signer;\n', '  }\n', '\n', '  function setSigner(address newSigner) public onlyOwner {\n', '    require(newSigner != address(0));\n', '\n', '    signer = newSigner;\n', '  }\n', '\n', '  function claim(\n', '    address receiver,\n', '    bytes32 id,\n', '    string username,\n', '    bool verified,\n', '    uint256 amount,\n', '    bytes32 inviterId,\n', '    uint256 inviteReward,\n', '    bytes sig\n', '  ) public whenNotPaused {\n', '    require(users[id] == address(0));\n', '\n', '    bytes32 proveHash = getProveHash(receiver, id, username, verified, amount, inviterId, inviteReward);\n', '    address proveSigner = getMsgSigner(proveHash, sig);\n', '    require(proveSigner == signer);\n', '\n', '    users[id] = receiver;\n', '\n', '    uint256 unclaimedReward = unclaimedRewards[id];\n', '    if (unclaimedReward > 0) {\n', '      unclaimedRewards[id] = 0;\n', '      _distribute(receiver, unclaimedReward.add(amount));\n', '    } else {\n', '      _distribute(receiver, amount);\n', '    }\n', '\n', '    if (verified) {\n', '      nameRegistry.finalizeName(receiver, username);\n', '    } else {\n', '      nameRegistry.registerName(receiver, username);\n', '    }\n', '\n', '    if (inviterId == 0) {\n', '      return;\n', '    }\n', '\n', '    if (users[inviterId] == address(0)) {\n', '      unclaimedRewards[inviterId] = unclaimedRewards[inviterId].add(inviteReward);\n', '    } else {\n', '      _distribute(users[inviterId], inviteReward);\n', '    }\n', '  }\n', '\n', '  function getAccountState(bytes32 id) public view returns (address addr, uint256 unclaimedReward) {\n', '    addr = users[id];\n', '    unclaimedReward = unclaimedRewards[id];\n', '  }\n', '\n', '  function getProveHash(\n', '    address receiver, bytes32 id, string username, bool verified, uint256 amount, bytes32 inviterId, uint256 inviteReward\n', '  ) public pure returns (bytes32) {\n', '    return keccak256(abi.encodePacked(receiver, id, username, verified, amount, inviterId, inviteReward));\n', '  }\n', '\n', '  function getMsgSigner(bytes32 proveHash, bytes sig) public pure returns (address) {\n', '    return proveHash.recover(sig);\n', '  }\n', '\n', '  function _distribute(address to, uint256 amount) internal {\n', '    token.mint(to, amount);\n', '    emit Distribution(to, amount);\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/ECRecovery.sol\n', '\n', '/**\n', ' * @title Eliptic curve signature operations\n', ' *\n', ' * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d\n', ' *\n', ' * TODO Remove this library once solidity supports passing a signature to ecrecover.\n', ' * See https://github.com/ethereum/solidity/issues/864\n', ' *\n', ' */\n', '\n', 'library ECRecovery {\n', '\n', '  /**\n', '   * @dev Recover signer address from a message by using their signature\n', '   * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '   * @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '   */\n', '  function recover(bytes32 hash, bytes sig)\n', '    internal\n', '    pure\n', '    returns (address)\n', '  {\n', '    bytes32 r;\n', '    bytes32 s;\n', '    uint8 v;\n', '\n', '    // Check the signature length\n', '    if (sig.length != 65) {\n', '      return (address(0));\n', '    }\n', '\n', '    // Divide the signature in r, s and v variables\n', '    // ecrecover takes the signature parameters, and the only way to get them\n', '    // currently is to use assembly.\n', '    // solium-disable-next-line security/no-inline-assembly\n', '    assembly {\n', '      r := mload(add(sig, 32))\n', '      s := mload(add(sig, 64))\n', '      v := byte(0, mload(add(sig, 96)))\n', '    }\n', '\n', '    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '    if (v < 27) {\n', '      v += 27;\n', '    }\n', '\n', '    // If the version is correct return the signer address\n', '    if (v != 27 && v != 28) {\n', '      return (address(0));\n', '    } else {\n', '      // solium-disable-next-line arg-overflow\n', '      return ecrecover(hash, v, r, s);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * toEthSignedMessageHash\n', '   * @dev prefix a bytes32 value with "\\x19Ethereum Signed Message:"\n', '   * @dev and hash the result\n', '   */\n', '  function toEthSignedMessageHash(bytes32 hash)\n', '    internal\n', '    pure\n', '    returns (bytes32)\n', '  {\n', '    // 32 is the length in bytes of hash,\n', '    // enforced by the type signature above\n', '    return keccak256(\n', '      "\\x19Ethereum Signed Message:\\n32",\n', '      hash\n', '    );\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/Airdrop.sol\n', '\n', 'contract KMHTokenInterface {\n', '  function checkRole(address addr, string roleName) public view;\n', '\n', '  function mint(address _to, uint256 _amount) public returns (bool);\n', '}\n', '\n', 'contract NameRegistryInterface {\n', '  function registerName(address addr, string name) public;\n', '  function finalizeName(address addr, string name) public;\n', '}\n', '\n', '// Pausable is Ownable\n', 'contract Airdrop is Pausable {\n', '  using SafeMath for uint;\n', '  using ECRecovery for bytes32;\n', '\n', '  event Distribution(address indexed to, uint256 amount);\n', '\n', '  mapping(bytes32 => address) public users;\n', '  mapping(bytes32 => uint) public unclaimedRewards;\n', '\n', '  address public signer;\n', '\n', '  KMHTokenInterface public token;\n', '  NameRegistryInterface public nameRegistry;\n', '\n', '  constructor(address _token, address _nameRegistry, address _signer) public {\n', '    require(_token != address(0));\n', '    require(_nameRegistry != address(0));\n', '    require(_signer != address(0));\n', '\n', '    token = KMHTokenInterface(_token);\n', '    nameRegistry = NameRegistryInterface(_nameRegistry);\n', '    signer = _signer;\n', '  }\n', '\n', '  function setSigner(address newSigner) public onlyOwner {\n', '    require(newSigner != address(0));\n', '\n', '    signer = newSigner;\n', '  }\n', '\n', '  function claim(\n', '    address receiver,\n', '    bytes32 id,\n', '    string username,\n', '    bool verified,\n', '    uint256 amount,\n', '    bytes32 inviterId,\n', '    uint256 inviteReward,\n', '    bytes sig\n', '  ) public whenNotPaused {\n', '    require(users[id] == address(0));\n', '\n', '    bytes32 proveHash = getProveHash(receiver, id, username, verified, amount, inviterId, inviteReward);\n', '    address proveSigner = getMsgSigner(proveHash, sig);\n', '    require(proveSigner == signer);\n', '\n', '    users[id] = receiver;\n', '\n', '    uint256 unclaimedReward = unclaimedRewards[id];\n', '    if (unclaimedReward > 0) {\n', '      unclaimedRewards[id] = 0;\n', '      _distribute(receiver, unclaimedReward.add(amount));\n', '    } else {\n', '      _distribute(receiver, amount);\n', '    }\n', '\n', '    if (verified) {\n', '      nameRegistry.finalizeName(receiver, username);\n', '    } else {\n', '      nameRegistry.registerName(receiver, username);\n', '    }\n', '\n', '    if (inviterId == 0) {\n', '      return;\n', '    }\n', '\n', '    if (users[inviterId] == address(0)) {\n', '      unclaimedRewards[inviterId] = unclaimedRewards[inviterId].add(inviteReward);\n', '    } else {\n', '      _distribute(users[inviterId], inviteReward);\n', '    }\n', '  }\n', '\n', '  function getAccountState(bytes32 id) public view returns (address addr, uint256 unclaimedReward) {\n', '    addr = users[id];\n', '    unclaimedReward = unclaimedRewards[id];\n', '  }\n', '\n', '  function getProveHash(\n', '    address receiver, bytes32 id, string username, bool verified, uint256 amount, bytes32 inviterId, uint256 inviteReward\n', '  ) public pure returns (bytes32) {\n', '    return keccak256(abi.encodePacked(receiver, id, username, verified, amount, inviterId, inviteReward));\n', '  }\n', '\n', '  function getMsgSigner(bytes32 proveHash, bytes sig) public pure returns (address) {\n', '    return proveHash.recover(sig);\n', '  }\n', '\n', '  function _distribute(address to, uint256 amount) internal {\n', '    token.mint(to, amount);\n', '    emit Distribution(to, amount);\n', '  }\n', '}']

['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @dev Pulled from OpenZeppelin: https://git.io/vbaRf\n', ' *   When this is in a public release we will switch to not vendoring this file\n', ' *\n', ' * @title Eliptic curve signature operations\n', ' *\n', ' * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d\n', ' */\n', '\n', 'library ECRecovery {\n', '\n', '  /**\n', '   * @dev Recover signer address from a message by using his signature\n', '   * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '   * @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '   */\n', '  function recover(bytes32 hash, bytes sig) public pure returns (address) {\n', '    bytes32 r;\n', '    bytes32 s;\n', '    uint8 v;\n', '\n', '    //Check the signature length\n', '    if (sig.length != 65) {\n', '      return (address(0));\n', '    }\n', '\n', '    // Extracting these values isn&#39;t possible without assembly\n', '    // solhint-disable no-inline-assembly\n', '    // Divide the signature in r, s and v variables\n', '    assembly {\n', '      r := mload(add(sig, 32))\n', '      s := mload(add(sig, 64))\n', '      v := byte(0, mload(add(sig, 96)))\n', '    }\n', '\n', '    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '    if (v < 27) {\n', '      v += 27;\n', '    }\n', '\n', '    // If the version is correct return the signer address\n', '    if (v != 27 && v != 28) {\n', '      return (address(0));\n', '    } else {\n', '      return ecrecover(hash, v, r, s);\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract SigningLogicInterface {\n', '  function recoverSigner(bytes32 _hash, bytes _sig) external pure returns (address);\n', '  function generateRequestAttestationSchemaHash(\n', '    address _subject,\n', '    address _attester,\n', '    address _requester,\n', '    bytes32 _dataHash,\n', '    uint256[] _typeIds,\n', '    bytes32 _nonce\n', '    ) external view returns (bytes32);\n', '  function generateAttestForDelegationSchemaHash(\n', '    address _subject,\n', '    address _requester,\n', '    uint256 _reward,\n', '    bytes32 _paymentNonce,\n', '    bytes32 _dataHash,\n', '    uint256[] _typeIds,\n', '    bytes32 _requestNonce\n', '    ) external view returns (bytes32);\n', '  function generateContestForDelegationSchemaHash(\n', '    address _requester,\n', '    uint256 _reward,\n', '    bytes32 _paymentNonce\n', '  ) external view returns (bytes32);\n', '  function generateStakeForDelegationSchemaHash(\n', '    address _subject,\n', '    uint256 _value,\n', '    bytes32 _paymentNonce,\n', '    bytes32 _dataHash,\n', '    uint256[] _typeIds,\n', '    bytes32 _requestNonce,\n', '    uint256 _stakeDuration\n', '    ) external view returns (bytes32);\n', '  function generateRevokeStakeForDelegationSchemaHash(\n', '    uint256 _subjectId,\n', '    uint256 _attestationId\n', '    ) external view returns (bytes32);\n', '  function generateAddAddressSchemaHash(\n', '    address _senderAddress,\n', '    bytes32 _nonce\n', '    ) external view returns (bytes32);\n', '  function generateVoteForDelegationSchemaHash(\n', '    uint16 _choice,\n', '    address _voter,\n', '    bytes32 _nonce,\n', '    address _poll\n', '    ) external view returns (bytes32);\n', '  function generateReleaseTokensSchemaHash(\n', '    address _sender,\n', '    address _receiver,\n', '    uint256 _amount,\n', '    bytes32 _uuid\n', '    ) external view returns (bytes32);\n', '  function generateLockupTokensDelegationSchemaHash(\n', '    address _sender,\n', '    uint256 _amount,\n', '    bytes32 _nonce\n', '    ) external view returns (bytes32);\n', '}\n', '\n', '/**\n', ' * @title SigningLogic is an upgradeable contract implementing signature recovery from typed data signatures\n', ' * @notice Recovers signatures based on the SignTypedData implementation provided by Metamask\n', ' * @dev This contract is deployed separately and is referenced by other contracts.\n', ' *  The other contracts have functions that allow this contract to be swapped out\n', ' *  They will continue to work as long as this contract implements at least the functions in SigningLogicInterface\n', ' */\n', 'contract SigningLogicLegacy is SigningLogicInterface{\n', '\n', '  bytes32 constant ATTESTATION_REQUEST_TYPEHASH = keccak256(\n', '      abi.encodePacked(\n', '        "address subject",\n', '        "address attester",\n', '        "address requester",\n', '        "bytes32 dataHash",\n', '        "bytes32 typeHash",\n', '        "bytes32 nonce"\n', '      )\n', '  );\n', '\n', '  bytes32 constant ADD_ADDRESS_TYPEHASH = keccak256(\n', '      abi.encodePacked(\n', '        "address sender",\n', '        "bytes32 nonce"\n', '      )\n', '  );\n', '\n', '  bytes32 constant RELEASE_TOKENS_TYPEHASH = keccak256(\n', '      abi.encodePacked(\n', '        "string action",\n', '        "address sender",\n', '        "address receiver",\n', '        "uint256 amount",\n', '        "bytes32 nonce"\n', '      )\n', '  );\n', '\n', '  bytes32 constant ATTEST_FOR_TYPEHASH = keccak256(\n', '      abi.encodePacked(\n', '        "string action",\n', '        "address subject",\n', '        "address requester",\n', '        "uint256 reward", \n', '        "bytes32 paymentNonce",\n', '        "bytes32 dataHash",\n', '        "bytes32 typeHash",\n', '        "bytes32 requestNonce"\n', '      )\n', '  );\n', '\n', '  bytes32 constant CONTEST_FOR_TYPEHASH = keccak256(\n', '      abi.encodePacked(\n', '        "string action",\n', '        "address requester",\n', '        "uint256 reward", \n', '        "bytes32 paymentNonce"\n', '      )\n', '  );\n', '\n', '  bytes32 constant STAKE_FOR_TYPEHASH = keccak256(\n', '      abi.encodePacked(\n', '        "string action",\n', '        "address subject",\n', '        "uint256 value", \n', '        "bytes32 paymentNonce",\n', '        "bytes32 dataHash",\n', '        "bytes32 typeHash",\n', '        "bytes32 requestNonce",\n', '        "uint256 stakeDuration"\n', '      )\n', '  );\n', '\n', '  bytes32 constant REVOKE_STAKE_FOR_TYPEHASH = keccak256(\n', '      abi.encodePacked(\n', '        "string action",\n', '        "uint256 subjectId",\n', '        "uint256 attestationId"\n', '      )\n', '  );\n', '\n', '  bytes32 constant VOTE_FOR_TYPEHASH = keccak256(\n', '      abi.encodePacked(\n', '        "uint16 choice",\n', '        "address voter",\n', '        "bytes32 nonce",\n', '        "address poll"\n', '      )\n', '  );\n', '\n', '  bytes32 constant LOCKUP_TOKENS_FOR = keccak256(\n', '      abi.encodePacked(\n', '        "string action",\n', '        "address sender",\n', '        "uint256 amount",\n', '        "bytes32 nonce"\n', '      )\n', '  );\n', '\n', '  struct AttestationRequest {\n', '      address subject;\n', '      address attester;\n', '      address requester;\n', '      bytes32 dataHash;\n', '      bytes32 typeHash;\n', '      bytes32 nonce;\n', '  }\n', '\n', '  function hash(AttestationRequest request) internal pure returns (bytes32) {\n', '    return keccak256(\n', '      abi.encodePacked(\n', '        ATTESTATION_REQUEST_TYPEHASH,\n', '        keccak256(\n', '          abi.encodePacked(\n', '            request.subject,\n', '            request.attester,\n', '            request.requester,\n', '            request.dataHash,\n', '            request.typeHash,\n', '            request.nonce\n', '          )\n', '        )\n', '    ));\n', '  }\n', '\n', '  struct AddAddress {\n', '      address sender;\n', '      bytes32 nonce;\n', '  }\n', '\n', '  function hash(AddAddress request) internal pure returns (bytes32) {\n', '    return keccak256(\n', '      abi.encodePacked(\n', '        ADD_ADDRESS_TYPEHASH,\n', '        keccak256(\n', '          abi.encodePacked(\n', '            request.sender,\n', '            request.nonce\n', '          )\n', '        )\n', '    ));\n', '  }\n', '\n', '  struct ReleaseTokens {\n', '      address sender;\n', '      address receiver;\n', '      uint256 amount;\n', '      bytes32 nonce;\n', '  }\n', '\n', '  function hash(ReleaseTokens request) internal pure returns (bytes32) {\n', '    return keccak256(\n', '      abi.encodePacked(\n', '        RELEASE_TOKENS_TYPEHASH,\n', '        keccak256(\n', '          abi.encodePacked(\n', '            "pay",\n', '            request.sender,\n', '            request.receiver,\n', '            request.amount,\n', '            request.nonce\n', '          )\n', '        )\n', '    ));\n', '  }\n', '\n', '  struct AttestFor {\n', '      address subject;\n', '      address requester;\n', '      uint256 reward;\n', '      bytes32 paymentNonce;\n', '      bytes32 dataHash;\n', '      bytes32 typeHash;\n', '      bytes32 requestNonce;\n', '  }\n', '\n', '  function hash(AttestFor request) internal pure returns (bytes32) {\n', '    return keccak256(\n', '      abi.encodePacked(\n', '        ATTEST_FOR_TYPEHASH,\n', '        keccak256(\n', '          abi.encodePacked(\n', '            "attest",\n', '            request.subject,\n', '            request.requester,\n', '            request.reward,\n', '            request.paymentNonce,\n', '            request.dataHash,\n', '            request.typeHash,\n', '            request.requestNonce\n', '          )\n', '        )\n', '    ));\n', '  }\n', '\n', '  struct ContestFor {\n', '      address requester;\n', '      uint256 reward;\n', '      bytes32 paymentNonce;\n', '  }\n', '\n', '  function hash(ContestFor request) internal pure returns (bytes32) {\n', '    return keccak256(\n', '      abi.encodePacked(\n', '        CONTEST_FOR_TYPEHASH,\n', '        keccak256(\n', '          abi.encodePacked(\n', '            "contest",\n', '            request.requester,\n', '            request.reward,\n', '            request.paymentNonce\n', '          )\n', '        )\n', '    ));\n', '  }\n', '\n', '  struct StakeFor {\n', '      address subject;\n', '      uint256 value;\n', '      bytes32 paymentNonce;\n', '      bytes32 dataHash;\n', '      bytes32 typeHash;\n', '      bytes32 requestNonce;\n', '      uint256 stakeDuration;\n', '  }\n', '\n', '  function hash(StakeFor request) internal pure returns (bytes32) {\n', '    return keccak256(\n', '      abi.encodePacked(\n', '        STAKE_FOR_TYPEHASH,\n', '        keccak256(\n', '          abi.encodePacked(\n', '            "stake",\n', '            request.subject,\n', '            request.value,\n', '            request.paymentNonce,\n', '            request.dataHash,\n', '            request.typeHash,\n', '            request.requestNonce,\n', '            request.stakeDuration\n', '          )\n', '        )\n', '    ));\n', '  }\n', '\n', '  struct RevokeStakeFor {\n', '      uint256 subjectId;\n', '      uint256 attestationId;\n', '  }\n', '\n', '  function hash(RevokeStakeFor request) internal pure returns (bytes32) {\n', '    return keccak256(\n', '      abi.encodePacked(\n', '        REVOKE_STAKE_FOR_TYPEHASH,\n', '        keccak256(\n', '          abi.encodePacked(\n', '            "revokeStake",\n', '            request.subjectId,\n', '            request.attestationId\n', '          )\n', '        )\n', '    ));\n', '  }\n', '\n', '  struct VoteFor {\n', '      uint16 choice;\n', '      address voter;\n', '      bytes32 nonce;\n', '      address poll;\n', '  }\n', '\n', '  function hash(VoteFor request) internal pure returns (bytes32) {\n', '    return keccak256(\n', '      abi.encodePacked(\n', '        VOTE_FOR_TYPEHASH,\n', '        keccak256(\n', '          abi.encodePacked(\n', '            request.choice,\n', '            request.voter,\n', '            request.nonce,\n', '            request.poll\n', '          )\n', '        )\n', '    ));\n', '  }\n', '\n', '  struct LockupTokensFor {\n', '    address sender;\n', '    uint256 amount;\n', '    bytes32 nonce;\n', '  }\n', '\n', '  function hash(LockupTokensFor request) internal pure returns (bytes32) {\n', '    return keccak256(\n', '      abi.encodePacked(\n', '        LOCKUP_TOKENS_FOR,\n', '        keccak256(\n', '          abi.encodePacked(\n', '            "lockup",\n', '            request.sender,\n', '            request.amount,\n', '            request.nonce\n', '          )\n', '        )\n', '    ));\n', '  }\n', '\n', '  function generateRequestAttestationSchemaHash(\n', '    address _subject,\n', '    address _attester,\n', '    address _requester,\n', '    bytes32 _dataHash,\n', '    uint256[] _typeIds,\n', '    bytes32 _nonce\n', '  ) external view returns (bytes32) {\n', '    return hash(\n', '      AttestationRequest(\n', '        _subject,\n', '        _attester,\n', '        _requester,\n', '        _dataHash,\n', '        keccak256(abi.encodePacked(_typeIds)),\n', '        _nonce\n', '      )\n', '    );\n', '  }\n', '\n', '  function generateAddAddressSchemaHash(\n', '    address _senderAddress,\n', '    bytes32 _nonce\n', '  ) external view returns (bytes32) {\n', '    return hash(\n', '      AddAddress(\n', '        _senderAddress,\n', '        _nonce\n', '      )\n', '    );\n', '  }\n', '\n', '  function generateReleaseTokensSchemaHash(\n', '    address _sender,\n', '    address _receiver,\n', '    uint256 _amount,\n', '    bytes32 _nonce\n', '  ) external view returns (bytes32) {\n', '    return hash(\n', '      ReleaseTokens(\n', '        _sender,\n', '        _receiver,\n', '        _amount,\n', '        _nonce\n', '      )\n', '    );\n', '  }\n', '\n', '  function generateAttestForDelegationSchemaHash(\n', '    address _subject,\n', '    address _requester,\n', '    uint256 _reward,\n', '    bytes32 _paymentNonce,\n', '    bytes32 _dataHash,\n', '    uint256[] _typeIds,\n', '    bytes32 _requestNonce\n', '  ) external view returns (bytes32) {\n', '    return hash(\n', '      AttestFor(\n', '        _subject,\n', '        _requester,\n', '        _reward,\n', '        _paymentNonce,\n', '        _dataHash,\n', '        keccak256(abi.encodePacked(_typeIds)),\n', '        _requestNonce\n', '      )\n', '    );\n', '  }\n', '\n', '  function generateContestForDelegationSchemaHash(\n', '    address _requester,\n', '    uint256 _reward,\n', '    bytes32 _paymentNonce\n', '  ) external view returns (bytes32) {\n', '    return hash(\n', '      ContestFor(\n', '        _requester,\n', '        _reward,\n', '        _paymentNonce\n', '      )\n', '    );\n', '  }\n', '\n', '  function generateStakeForDelegationSchemaHash(\n', '    address _subject,\n', '    uint256 _value,\n', '    bytes32 _paymentNonce,\n', '    bytes32 _dataHash,\n', '    uint256[] _typeIds,\n', '    bytes32 _requestNonce,\n', '    uint256 _stakeDuration\n', '  ) external view returns (bytes32) {\n', '    return hash(\n', '      StakeFor(\n', '        _subject,\n', '        _value,\n', '        _paymentNonce,\n', '        _dataHash,\n', '        keccak256(abi.encodePacked(_typeIds)),\n', '        _requestNonce,\n', '        _stakeDuration\n', '      )\n', '    );\n', '  }\n', '\n', '  function generateRevokeStakeForDelegationSchemaHash(\n', '    uint256 _subjectId,\n', '    uint256 _attestationId\n', '  ) external view returns (bytes32) {\n', '    return hash(\n', '      RevokeStakeFor(\n', '        _subjectId,\n', '        _attestationId\n', '      )\n', '    );\n', '  }\n', '\n', '  function generateVoteForDelegationSchemaHash(\n', '    uint16 _choice,\n', '    address _voter,\n', '    bytes32 _nonce,\n', '    address _poll\n', '  ) external view returns (bytes32) {\n', '    return hash(\n', '      VoteFor(\n', '        _choice,\n', '        _voter,\n', '        _nonce,\n', '        _poll\n', '      )\n', '    );\n', '  }\n', '\n', '  function generateLockupTokensDelegationSchemaHash(\n', '    address _sender,\n', '    uint256 _amount,\n', '    bytes32 _nonce\n', '  ) external view returns (bytes32) {\n', '    return hash(\n', '      LockupTokensFor(\n', '        _sender,\n', '        _amount,\n', '        _nonce\n', '      )\n', '    );\n', '  }\n', '\n', '  function recoverSigner(bytes32 _hash, bytes _sig) external pure returns (address) {\n', '    address signer = ECRecovery.recover(_hash, _sig);\n', '    require(signer != address(0));\n', '\n', '    return signer;\n', '  }\n', '}']
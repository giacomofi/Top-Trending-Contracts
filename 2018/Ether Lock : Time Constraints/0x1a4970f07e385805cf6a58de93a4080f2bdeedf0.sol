['pragma solidity ^0.4.13;\n', '\n', 'library ECRecovery {\n', '\n', '    /**\n', '     * @dev Recover signer address from a message by using their signature\n', '     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '     * @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '     */\n', '    function recover(bytes32 hash, bytes sig)\n', '        internal\n', '        pure\n', '        returns (address)\n', '    {\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        // Check the signature length\n', '        if (sig.length != 65) {\n', '            return (address(0));\n', '        }\n', '\n', '        // Divide the signature in r, s and v variables\n', '        // ecrecover takes the signature parameters, and the only way to get them\n', '        // currently is to use assembly.\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            r := mload(add(sig, 32))\n', '            s := mload(add(sig, 64))\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '\n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '\n', '        // If the version is correct return the signer address\n', '        if (v != 27 && v != 28) {\n', '            return (address(0));\n', '        } else {\n', '            // solium-disable-next-line arg-overflow\n', '            return ecrecover(hash, v, r, s);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * toEthSignedMessageHash\n', '     * @dev prefix a bytes32 value with "\\x19Ethereum Signed Message:"\n', '     * @dev and hash the result\n', '     */\n', '    function toEthSignedMessageHash(bytes32 hash)\n', '        internal\n', '        pure\n', '        returns (bytes32)\n', '    {\n', '        // 32 is the length in bytes of hash,\n', '        // enforced by the type signature above\n', '        return keccak256(\n', '            "\\x19Ethereum Signed Message:\\n32",\n', '            hash\n', '        );\n', '    }\n', '}\n', '\n', 'contract Htlc {\n', '    using ECRecovery for bytes32;\n', '\n', '    // TYPES\n', '\n', '    struct Multisig { // Locked by time and/or authority approval for HTLC conversion or earlyResolve\n', '        address owner; // Owns funds deposited in multisig,\n', '        address authority; // Can approve earlyResolve of funds out of multisig\n', '        uint deposit; // Amount deposited by owner in this multisig\n', '        uint unlockTime; // Multisig expiration timestamp in seconds\n', '    }\n', '\n', '    struct AtomicSwap { // HTLC swap used for regular transfers\n', '        address initiator; // Initiated this swap\n', '        address beneficiary; // Beneficiary of this swap\n', '        uint amount; // If zero then swap not active anymore\n', '        uint fee; // Fee amount to be paid to multisig authority\n', '        uint expirationTime; // Swap expiration timestamp in seconds\n', '        bytes32 hashedSecret; // sha256(secret), hashed secret of swap initiator\n', '    }\n', '\n', '    // FIELDS\n', '\n', '    address constant FEE_RECIPIENT = 0x0E5cB767Cce09A7F3CA594Df118aa519BE5e2b5A;\n', '    mapping (bytes32 => Multisig) public hashIdToMultisig;\n', '    mapping (bytes32 => AtomicSwap) public hashIdToSwap;\n', '\n', '    // EVENTS\n', '\n', '    // TODO add events for all public functions\n', '\n', '    // MODIFIERS\n', '\n', '    // METHODS\n', '\n', '    /**\n', '    @notice Send ether out of this contract to multisig owner and update or delete entry in multisig mapping\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @param amount Spend this amount of ether\n', '    */\n', '    function spendFromMultisig(bytes32 msigId, uint amount, address recipient)\n', '        internal\n', '    {\n', '        // Require sufficient deposit amount; Prevents buffer underflow\n', '        require(amount <= hashIdToMultisig[msigId].deposit);\n', '        hashIdToMultisig[msigId].deposit -= amount;\n', '        if (hashIdToMultisig[msigId].deposit == 0) {\n', '            // Delete multisig\n', '            delete hashIdToMultisig[msigId];\n', '            assert(hashIdToMultisig[msigId].deposit == 0);\n', '        }\n', '        // Transfer recipient\n', '        recipient.transfer(amount);\n', '    }\n', '\n', '    /**\n', '    @notice Send ether out of this contract to swap beneficiary and update or delete entry in swap mapping\n', '    @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier\n', '    @param amount Spend this amount of ether\n', '    */\n', '    function spendFromSwap(bytes32 swapId, uint amount, address recipient)\n', '        internal\n', '    {\n', '        // Require sufficient swap amount; Prevents buffer underflow\n', '        require(amount <= hashIdToSwap[swapId].amount);\n', '        hashIdToSwap[swapId].amount -= amount;\n', '        if (hashIdToSwap[swapId].amount == 0) {\n', '            // Delete swap\n', '            delete hashIdToSwap[swapId];\n', '            assert(hashIdToSwap[swapId].amount == 0);\n', '        }\n', '        // Transfer to recipient\n', '        recipient.transfer(amount);\n', '    }\n', '\n', '    // PUBLIC METHODS\n', '\n', '    /**\n', '    @notice Initialise and reparametrize Multisig\n', '    @dev Uses msg.value to fund Multisig\n', '    @param authority Second multisig Authority. Usually this is the Exchange.\n', '    @param unlockTime Lock Ether until unlockTime in seconds.\n', '    @return msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    */\n', '    function initialiseMultisig(address authority, uint unlockTime)\n', '        public\n', '        payable\n', '        returns (bytes32 msigId)\n', '    {\n', '        // Require not own authority and ether are sent\n', '        require(msg.sender != authority);\n', '        require(msg.value > 0);\n', '        msigId = keccak256(\n', '            msg.sender,\n', '            authority,\n', '            msg.value,\n', '            unlockTime\n', '        );\n', '\n', '        Multisig storage multisig = hashIdToMultisig[msigId];\n', '        if (multisig.deposit == 0) { // New or empty multisig\n', '            // Create new multisig\n', '            multisig.owner = msg.sender;\n', '            multisig.authority = authority;\n', '        }\n', '        // Adjust balance and locktime\n', '        reparametrizeMultisig(msigId, unlockTime);\n', '    }\n', '\n', '    /**\n', '    @notice Deposit msg.value ether into a multisig and set unlockTime\n', '    @dev Can increase deposit and/or unlockTime but not owner or authority\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @param unlockTime Lock Ether until unlockTime in seconds.\n', '    */\n', '    function reparametrizeMultisig(bytes32 msigId, uint unlockTime)\n', '        public\n', '        payable\n', '    {\n', '        Multisig storage multisig = hashIdToMultisig[msigId];\n', '        assert(\n', '            multisig.deposit + msg.value >=\n', '            multisig.deposit\n', '        ); // Throws on overflow.\n', '        multisig.deposit += msg.value;\n', '        assert(multisig.unlockTime <= unlockTime); // Can only increase unlockTime\n', '        multisig.unlockTime = unlockTime;\n', '    }\n', '\n', '    // TODO allow for batch convertIntoHtlc\n', '    /**\n', '    @notice Convert swap from multisig to htlc mode\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @param beneficiary Beneficiary of this swap\n', '    @param amount Convert this amount from multisig into swap\n', '    @param fee Fee amount to be paid to multisig authority\n', '    @param expirationTime Swap expiration timestamp in seconds; not more than 1 day from now\n', '    @param hashedSecret sha3(secret), hashed secret of swap initiator\n', '    @return swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier\n', '    */\n', '    function convertIntoHtlc(bytes32 msigId, address beneficiary, uint amount, uint fee, uint expirationTime, bytes32 hashedSecret)\n', '        public\n', '        returns (bytes32 swapId)\n', '    {\n', '        // Require owner with sufficient deposit\n', '        require(hashIdToMultisig[msigId].owner == msg.sender);\n', '        require(hashIdToMultisig[msigId].deposit >= amount + fee); // Checks for underflow\n', '        require(now <= expirationTime && expirationTime <= now + 86400); // Not more than 1 day\n', '        require(amount > 0); // Non-empty amount as definition for active swap\n', '        // Account in multisig balance\n', '        hashIdToMultisig[msigId].deposit -= amount + fee;\n', '        swapId = keccak256(\n', '            msg.sender,\n', '            beneficiary,\n', '            amount,\n', '            fee,\n', '            expirationTime,\n', '            hashedSecret\n', '        );\n', '        // Create swap\n', '        AtomicSwap storage swap = hashIdToSwap[swapId];\n', '        swap.initiator = msg.sender;\n', '        swap.beneficiary = beneficiary;\n', '        swap.amount = amount;\n', '        swap.fee = fee;\n', '        swap.expirationTime = expirationTime;\n', '        swap.hashedSecret = hashedSecret;\n', '        // Transfer fee to multisig.authority\n', '        hashIdToMultisig[msigId].authority.transfer(fee);\n', '    }\n', '\n', '    // TODO calc gas limit\n', '    /**\n', '    @notice Withdraw ether and delete the htlc swap. Equivalent to REGULAR_TRANSFER in Nimiq\n', '    @dev Transfer swap amount to beneficiary of swap and fee to authority\n', '    @param swapIds Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifiers\n', '    @param secrets Hashed secrets of htlc swaps\n', '    */\n', '    function batchRegularTransfer(bytes32[] swapIds, bytes32[] secrets)\n', '        public\n', '    {\n', '        for (uint i = 0; i < swapIds.length; ++i)\n', '            regularTransfer(swapIds[i], secrets[i]);\n', '    }\n', '\n', '    /**\n', '    @notice Withdraw ether and delete the htlc swap. Equivalent to REGULAR_TRANSFER in Nimiq\n', '    @dev Transfer swap amount to beneficiary of swap and fee to authority\n', '    @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier\n', '    @param secret Hashed secret of htlc swap\n', '    */\n', '    function regularTransfer(bytes32 swapId, bytes32 secret)\n', '        public\n', '    {\n', '        // Require valid secret provided\n', '        require(sha256(secret) == hashIdToSwap[swapId].hashedSecret);\n', '        // Execute swap\n', '        spendFromSwap(swapId, hashIdToSwap[swapId].amount, hashIdToSwap[swapId].beneficiary);\n', '        spendFromSwap(swapId, hashIdToSwap[swapId].fee, FEE_RECIPIENT);\n', '    }\n', '\n', '    /**\n', '    @notice Reclaim all the expired, non-empty swaps into a multisig\n', '    @dev Transfer swap amount to beneficiary of swap and fee to authority\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier to which deposit expired swaps\n', '    @param swapIds Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifiers\n', '    */\n', '    function batchReclaimExpiredSwaps(bytes32 msigId, bytes32[] swapIds)\n', '        public\n', '    {\n', '        for (uint i = 0; i < swapIds.length; ++i)\n', '            reclaimExpiredSwaps(msigId, swapIds[i]);\n', '    }\n', '\n', '    /**\n', '    @notice Reclaim an expired, non-empty swap into a multisig\n', '    @dev Transfer swap amount to beneficiary of swap and fee to authority\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier to which deposit expired swaps\n', '    @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier\n', '    */\n', '    function reclaimExpiredSwaps(bytes32 msigId, bytes32 swapId)\n', '        public\n', '    {\n', '        // Require: msg.sender == ower or authority\n', '        require(\n', '            hashIdToMultisig[msigId].owner == msg.sender ||\n', '            hashIdToMultisig[msigId].authority == msg.sender\n', '        );\n', '        // TODO! link msigId to swapId\n', '        // Require: is expired\n', '        require(now >= hashIdToSwap[swapId].expirationTime);\n', '        uint amount = hashIdToSwap[swapId].amount;\n', '        assert(hashIdToMultisig[msigId].deposit + amount >= amount); // Throws on overflow.\n', '        delete hashIdToSwap[swapId];\n', '        hashIdToMultisig[msigId].deposit += amount;\n', '    }\n', '\n', '    /**\n', '    @notice Withdraw ether and delete the htlc swap. Equivalent to EARLY_RESOLVE in Nimiq\n', '    @param hashedMessage bytes32 hash of unique swap hash, the hash is the signed message. What is recovered is the signer address.\n', '    @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '    */\n', '    function earlyResolve(bytes32 msigId, uint amount, bytes32 hashedMessage, bytes sig)\n', '        public\n', '    {\n', '        // Require: msg.sender == ower or authority\n', '        require(\n', '            hashIdToMultisig[msigId].owner == msg.sender ||\n', '            hashIdToMultisig[msigId].authority == msg.sender\n', '        );\n', '        // Require: valid signature from not tx.sending authority\n', '        address otherAuthority = hashIdToMultisig[msigId].owner == msg.sender ?\n', '            hashIdToMultisig[msigId].authority :\n', '            hashIdToMultisig[msigId].owner;\n', '        require(otherAuthority == hashedMessage.recover(sig));\n', '\n', '        spendFromMultisig(msigId, amount, hashIdToMultisig[msigId].owner);\n', '    }\n', '\n', '    /**\n', '    @notice Withdraw ether and delete the htlc swap. Equivalent to TIMEOUT_RESOLVE in Nimiq\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @dev Only refunds owned multisig deposits\n', '    */\n', '    function timeoutResolve(bytes32 msigId, uint amount)\n', '        public\n', '    {\n', '        // Require sufficient amount and time passed\n', '        require(hashIdToMultisig[msigId].deposit >= amount);\n', '        require(now >= hashIdToMultisig[msigId].unlockTime);\n', '\n', '        spendFromMultisig(msigId, amount, hashIdToMultisig[msigId].owner);\n', '    }\n', '\n', '    // TODO add timelocked selfdestruct function for initial version\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'library ECRecovery {\n', '\n', '    /**\n', '     * @dev Recover signer address from a message by using their signature\n', '     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '     * @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '     */\n', '    function recover(bytes32 hash, bytes sig)\n', '        internal\n', '        pure\n', '        returns (address)\n', '    {\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        // Check the signature length\n', '        if (sig.length != 65) {\n', '            return (address(0));\n', '        }\n', '\n', '        // Divide the signature in r, s and v variables\n', '        // ecrecover takes the signature parameters, and the only way to get them\n', '        // currently is to use assembly.\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            r := mload(add(sig, 32))\n', '            s := mload(add(sig, 64))\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '\n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '\n', '        // If the version is correct return the signer address\n', '        if (v != 27 && v != 28) {\n', '            return (address(0));\n', '        } else {\n', '            // solium-disable-next-line arg-overflow\n', '            return ecrecover(hash, v, r, s);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * toEthSignedMessageHash\n', '     * @dev prefix a bytes32 value with "\\x19Ethereum Signed Message:"\n', '     * @dev and hash the result\n', '     */\n', '    function toEthSignedMessageHash(bytes32 hash)\n', '        internal\n', '        pure\n', '        returns (bytes32)\n', '    {\n', '        // 32 is the length in bytes of hash,\n', '        // enforced by the type signature above\n', '        return keccak256(\n', '            "\\x19Ethereum Signed Message:\\n32",\n', '            hash\n', '        );\n', '    }\n', '}\n', '\n', 'contract Htlc {\n', '    using ECRecovery for bytes32;\n', '\n', '    // TYPES\n', '\n', '    struct Multisig { // Locked by time and/or authority approval for HTLC conversion or earlyResolve\n', '        address owner; // Owns funds deposited in multisig,\n', '        address authority; // Can approve earlyResolve of funds out of multisig\n', '        uint deposit; // Amount deposited by owner in this multisig\n', '        uint unlockTime; // Multisig expiration timestamp in seconds\n', '    }\n', '\n', '    struct AtomicSwap { // HTLC swap used for regular transfers\n', '        address initiator; // Initiated this swap\n', '        address beneficiary; // Beneficiary of this swap\n', '        uint amount; // If zero then swap not active anymore\n', '        uint fee; // Fee amount to be paid to multisig authority\n', '        uint expirationTime; // Swap expiration timestamp in seconds\n', '        bytes32 hashedSecret; // sha256(secret), hashed secret of swap initiator\n', '    }\n', '\n', '    // FIELDS\n', '\n', '    address constant FEE_RECIPIENT = 0x0E5cB767Cce09A7F3CA594Df118aa519BE5e2b5A;\n', '    mapping (bytes32 => Multisig) public hashIdToMultisig;\n', '    mapping (bytes32 => AtomicSwap) public hashIdToSwap;\n', '\n', '    // EVENTS\n', '\n', '    // TODO add events for all public functions\n', '\n', '    // MODIFIERS\n', '\n', '    // METHODS\n', '\n', '    /**\n', '    @notice Send ether out of this contract to multisig owner and update or delete entry in multisig mapping\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @param amount Spend this amount of ether\n', '    */\n', '    function spendFromMultisig(bytes32 msigId, uint amount, address recipient)\n', '        internal\n', '    {\n', '        // Require sufficient deposit amount; Prevents buffer underflow\n', '        require(amount <= hashIdToMultisig[msigId].deposit);\n', '        hashIdToMultisig[msigId].deposit -= amount;\n', '        if (hashIdToMultisig[msigId].deposit == 0) {\n', '            // Delete multisig\n', '            delete hashIdToMultisig[msigId];\n', '            assert(hashIdToMultisig[msigId].deposit == 0);\n', '        }\n', '        // Transfer recipient\n', '        recipient.transfer(amount);\n', '    }\n', '\n', '    /**\n', '    @notice Send ether out of this contract to swap beneficiary and update or delete entry in swap mapping\n', '    @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier\n', '    @param amount Spend this amount of ether\n', '    */\n', '    function spendFromSwap(bytes32 swapId, uint amount, address recipient)\n', '        internal\n', '    {\n', '        // Require sufficient swap amount; Prevents buffer underflow\n', '        require(amount <= hashIdToSwap[swapId].amount);\n', '        hashIdToSwap[swapId].amount -= amount;\n', '        if (hashIdToSwap[swapId].amount == 0) {\n', '            // Delete swap\n', '            delete hashIdToSwap[swapId];\n', '            assert(hashIdToSwap[swapId].amount == 0);\n', '        }\n', '        // Transfer to recipient\n', '        recipient.transfer(amount);\n', '    }\n', '\n', '    // PUBLIC METHODS\n', '\n', '    /**\n', '    @notice Initialise and reparametrize Multisig\n', '    @dev Uses msg.value to fund Multisig\n', '    @param authority Second multisig Authority. Usually this is the Exchange.\n', '    @param unlockTime Lock Ether until unlockTime in seconds.\n', '    @return msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    */\n', '    function initialiseMultisig(address authority, uint unlockTime)\n', '        public\n', '        payable\n', '        returns (bytes32 msigId)\n', '    {\n', '        // Require not own authority and ether are sent\n', '        require(msg.sender != authority);\n', '        require(msg.value > 0);\n', '        msigId = keccak256(\n', '            msg.sender,\n', '            authority,\n', '            msg.value,\n', '            unlockTime\n', '        );\n', '\n', '        Multisig storage multisig = hashIdToMultisig[msigId];\n', '        if (multisig.deposit == 0) { // New or empty multisig\n', '            // Create new multisig\n', '            multisig.owner = msg.sender;\n', '            multisig.authority = authority;\n', '        }\n', '        // Adjust balance and locktime\n', '        reparametrizeMultisig(msigId, unlockTime);\n', '    }\n', '\n', '    /**\n', '    @notice Deposit msg.value ether into a multisig and set unlockTime\n', '    @dev Can increase deposit and/or unlockTime but not owner or authority\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @param unlockTime Lock Ether until unlockTime in seconds.\n', '    */\n', '    function reparametrizeMultisig(bytes32 msigId, uint unlockTime)\n', '        public\n', '        payable\n', '    {\n', '        Multisig storage multisig = hashIdToMultisig[msigId];\n', '        assert(\n', '            multisig.deposit + msg.value >=\n', '            multisig.deposit\n', '        ); // Throws on overflow.\n', '        multisig.deposit += msg.value;\n', '        assert(multisig.unlockTime <= unlockTime); // Can only increase unlockTime\n', '        multisig.unlockTime = unlockTime;\n', '    }\n', '\n', '    // TODO allow for batch convertIntoHtlc\n', '    /**\n', '    @notice Convert swap from multisig to htlc mode\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @param beneficiary Beneficiary of this swap\n', '    @param amount Convert this amount from multisig into swap\n', '    @param fee Fee amount to be paid to multisig authority\n', '    @param expirationTime Swap expiration timestamp in seconds; not more than 1 day from now\n', '    @param hashedSecret sha3(secret), hashed secret of swap initiator\n', '    @return swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier\n', '    */\n', '    function convertIntoHtlc(bytes32 msigId, address beneficiary, uint amount, uint fee, uint expirationTime, bytes32 hashedSecret)\n', '        public\n', '        returns (bytes32 swapId)\n', '    {\n', '        // Require owner with sufficient deposit\n', '        require(hashIdToMultisig[msigId].owner == msg.sender);\n', '        require(hashIdToMultisig[msigId].deposit >= amount + fee); // Checks for underflow\n', '        require(now <= expirationTime && expirationTime <= now + 86400); // Not more than 1 day\n', '        require(amount > 0); // Non-empty amount as definition for active swap\n', '        // Account in multisig balance\n', '        hashIdToMultisig[msigId].deposit -= amount + fee;\n', '        swapId = keccak256(\n', '            msg.sender,\n', '            beneficiary,\n', '            amount,\n', '            fee,\n', '            expirationTime,\n', '            hashedSecret\n', '        );\n', '        // Create swap\n', '        AtomicSwap storage swap = hashIdToSwap[swapId];\n', '        swap.initiator = msg.sender;\n', '        swap.beneficiary = beneficiary;\n', '        swap.amount = amount;\n', '        swap.fee = fee;\n', '        swap.expirationTime = expirationTime;\n', '        swap.hashedSecret = hashedSecret;\n', '        // Transfer fee to multisig.authority\n', '        hashIdToMultisig[msigId].authority.transfer(fee);\n', '    }\n', '\n', '    // TODO calc gas limit\n', '    /**\n', '    @notice Withdraw ether and delete the htlc swap. Equivalent to REGULAR_TRANSFER in Nimiq\n', '    @dev Transfer swap amount to beneficiary of swap and fee to authority\n', '    @param swapIds Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifiers\n', '    @param secrets Hashed secrets of htlc swaps\n', '    */\n', '    function batchRegularTransfer(bytes32[] swapIds, bytes32[] secrets)\n', '        public\n', '    {\n', '        for (uint i = 0; i < swapIds.length; ++i)\n', '            regularTransfer(swapIds[i], secrets[i]);\n', '    }\n', '\n', '    /**\n', '    @notice Withdraw ether and delete the htlc swap. Equivalent to REGULAR_TRANSFER in Nimiq\n', '    @dev Transfer swap amount to beneficiary of swap and fee to authority\n', '    @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier\n', '    @param secret Hashed secret of htlc swap\n', '    */\n', '    function regularTransfer(bytes32 swapId, bytes32 secret)\n', '        public\n', '    {\n', '        // Require valid secret provided\n', '        require(sha256(secret) == hashIdToSwap[swapId].hashedSecret);\n', '        // Execute swap\n', '        spendFromSwap(swapId, hashIdToSwap[swapId].amount, hashIdToSwap[swapId].beneficiary);\n', '        spendFromSwap(swapId, hashIdToSwap[swapId].fee, FEE_RECIPIENT);\n', '    }\n', '\n', '    /**\n', '    @notice Reclaim all the expired, non-empty swaps into a multisig\n', '    @dev Transfer swap amount to beneficiary of swap and fee to authority\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier to which deposit expired swaps\n', '    @param swapIds Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifiers\n', '    */\n', '    function batchReclaimExpiredSwaps(bytes32 msigId, bytes32[] swapIds)\n', '        public\n', '    {\n', '        for (uint i = 0; i < swapIds.length; ++i)\n', '            reclaimExpiredSwaps(msigId, swapIds[i]);\n', '    }\n', '\n', '    /**\n', '    @notice Reclaim an expired, non-empty swap into a multisig\n', '    @dev Transfer swap amount to beneficiary of swap and fee to authority\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier to which deposit expired swaps\n', '    @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier\n', '    */\n', '    function reclaimExpiredSwaps(bytes32 msigId, bytes32 swapId)\n', '        public\n', '    {\n', '        // Require: msg.sender == ower or authority\n', '        require(\n', '            hashIdToMultisig[msigId].owner == msg.sender ||\n', '            hashIdToMultisig[msigId].authority == msg.sender\n', '        );\n', '        // TODO! link msigId to swapId\n', '        // Require: is expired\n', '        require(now >= hashIdToSwap[swapId].expirationTime);\n', '        uint amount = hashIdToSwap[swapId].amount;\n', '        assert(hashIdToMultisig[msigId].deposit + amount >= amount); // Throws on overflow.\n', '        delete hashIdToSwap[swapId];\n', '        hashIdToMultisig[msigId].deposit += amount;\n', '    }\n', '\n', '    /**\n', '    @notice Withdraw ether and delete the htlc swap. Equivalent to EARLY_RESOLVE in Nimiq\n', '    @param hashedMessage bytes32 hash of unique swap hash, the hash is the signed message. What is recovered is the signer address.\n', '    @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '    */\n', '    function earlyResolve(bytes32 msigId, uint amount, bytes32 hashedMessage, bytes sig)\n', '        public\n', '    {\n', '        // Require: msg.sender == ower or authority\n', '        require(\n', '            hashIdToMultisig[msigId].owner == msg.sender ||\n', '            hashIdToMultisig[msigId].authority == msg.sender\n', '        );\n', '        // Require: valid signature from not tx.sending authority\n', '        address otherAuthority = hashIdToMultisig[msigId].owner == msg.sender ?\n', '            hashIdToMultisig[msigId].authority :\n', '            hashIdToMultisig[msigId].owner;\n', '        require(otherAuthority == hashedMessage.recover(sig));\n', '\n', '        spendFromMultisig(msigId, amount, hashIdToMultisig[msigId].owner);\n', '    }\n', '\n', '    /**\n', '    @notice Withdraw ether and delete the htlc swap. Equivalent to TIMEOUT_RESOLVE in Nimiq\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @dev Only refunds owned multisig deposits\n', '    */\n', '    function timeoutResolve(bytes32 msigId, uint amount)\n', '        public\n', '    {\n', '        // Require sufficient amount and time passed\n', '        require(hashIdToMultisig[msigId].deposit >= amount);\n', '        require(now >= hashIdToMultisig[msigId].unlockTime);\n', '\n', '        spendFromMultisig(msigId, amount, hashIdToMultisig[msigId].owner);\n', '    }\n', '\n', '    // TODO add timelocked selfdestruct function for initial version\n', '}']

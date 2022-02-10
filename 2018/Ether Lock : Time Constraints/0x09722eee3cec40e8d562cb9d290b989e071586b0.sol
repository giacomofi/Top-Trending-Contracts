['pragma solidity ^0.4.13;\n', '\n', 'library ECRecovery {\n', '\n', '    /**\n', '     * @dev Recover signer address from a message by using their signature\n', '     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '     * @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '     */\n', '    function recover(bytes32 hash, bytes sig)\n', '        internal\n', '        pure\n', '        returns (address)\n', '    {\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        // Check the signature length\n', '        if (sig.length != 65) {\n', '            return (address(0));\n', '        }\n', '\n', '        // Divide the signature in r, s and v variables\n', '        // ecrecover takes the signature parameters, and the only way to get them\n', '        // currently is to use assembly.\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            r := mload(add(sig, 32))\n', '            s := mload(add(sig, 64))\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '\n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '\n', '        // If the version is correct return the signer address\n', '        if (v != 27 && v != 28) {\n', '            return (address(0));\n', '        } else {\n', '            // solium-disable-next-line arg-overflow\n', '            return ecrecover(hash, v, r, s);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * toEthSignedMessageHash\n', '     * @dev prefix a bytes32 value with "\\x19Ethereum Signed Message:"\n', '     * @dev and hash the result\n', '     */\n', '    function toEthSignedMessageHash(bytes32 hash)\n', '        internal\n', '        pure\n', '        returns (bytes32)\n', '    {\n', '        // 32 is the length in bytes of hash,\n', '        // enforced by the type signature above\n', '        return keccak256(\n', '            "\\x19Ethereum Signed Message:\\n32",\n', '            hash\n', '        );\n', '    }\n', '}\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint x, uint y) internal pure returns (uint z) {\n', '        return x >= y ? x : y;\n', '    }\n', '    function imin(int x, int y) internal pure returns (int z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int x, int y) internal pure returns (int z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint constant WAD = 10 ** 18;\n', '    uint constant RAY = 10 ** 27;\n', '\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', '    // It&#39;s O(log n), instead of O(n) for naive repeated multiplication.\n', '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint x, uint n) internal pure returns (uint z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'contract Htlc is DSMath {\n', '    using ECRecovery for bytes32;\n', '\n', '    // TYPES\n', '\n', '    // ATL Authority timelocked contract\n', '    struct Multisig { // Locked by authority approval (earlyResolve), time (timoutResolve) or conversion into an atomic swap\n', '        address owner; // Owns ether deposited in multisig\n', '        address authority; // Can approve earlyResolve of funds out of multisig\n', '        uint deposit; // Amount deposited by owner in this multisig\n', '        uint unlockTime; // Multisig expiration timestamp in seconds\n', '    }\n', '\n', '    struct AtomicSwap { // Locked by secret (regularTransfer) or time (reclaimExpiredSwaps)\n', '        bytes32 msigId; // Corresponding multisigId\n', '        address initiator; // Initiated this swap\n', '        address beneficiary; // Beneficiary of this swap\n', '        uint amount; // If zero then swap not active anymore\n', '        uint fee; // Fee amount to be paid to multisig authority\n', '        uint expirationTime; // Swap expiration timestamp in seconds\n', '        bytes32 hashedSecret; // sha256(secret), hashed secret of swap initiator\n', '    }\n', '\n', '    // FIELDS\n', '\n', '    address constant FEE_RECIPIENT = 0x478189a0aF876598C8a70Ce8896960500455A949;\n', '    uint constant MAX_BATCH_ITERATIONS = 25; // Assumption block.gaslimit around 7500000\n', '    mapping (bytes32 => Multisig) public multisigs;\n', '    mapping (bytes32 => AtomicSwap) public atomicswaps;\n', '    mapping (bytes32 => bool) public isAntecedentHashedSecret;\n', '\n', '    // EVENTS\n', '\n', '    event MultisigInitialised(bytes32 msigId);\n', '    event MultisigReparametrized(bytes32 msigId);\n', '    event AtomicSwapInitialised(bytes32 swapId);\n', '\n', '    // MODIFIERS\n', '\n', '    // METHODS\n', '\n', '    /**\n', '    @notice Send ether out of this contract to multisig owner and update or delete entry in multisig mapping\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @param amount Spend this amount of ether\n', '    */\n', '    function spendFromMultisig(bytes32 msigId, uint amount, address recipient)\n', '        internal\n', '    {\n', '        multisigs[msigId].deposit = sub(multisigs[msigId].deposit, amount);\n', '        if (multisigs[msigId].deposit == 0)\n', '            delete multisigs[msigId];\n', '        recipient.transfer(amount);\n', '    }\n', '\n', '    // PUBLIC METHODS\n', '\n', '    /**\n', '    @notice Initialise and reparametrize Multisig\n', '    @dev Uses msg.value to fund Multisig\n', '    @param authority Second multisig Authority. Usually this is the Exchange.\n', '    @param unlockTime Lock Ether until unlockTime in seconds.\n', '    @return msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    */\n', '    function initialiseMultisig(address authority, uint unlockTime)\n', '        public\n', '        payable\n', '        returns (bytes32 msigId)\n', '    {\n', '        // Require not own authority and non-zero ether amount are sent\n', '        require(msg.sender != authority);\n', '        require(msg.value > 0);\n', '        // Create unique multisig identifier\n', '        msigId = keccak256(\n', '            msg.sender,\n', '            authority,\n', '            msg.value,\n', '            unlockTime\n', '        );\n', '        emit MultisigInitialised(msigId);\n', '        // Create multisig\n', '        Multisig storage multisig = multisigs[msigId];\n', '        if (multisig.deposit == 0) { // New or empty multisig\n', '            // Create new multisig\n', '            multisig.owner = msg.sender;\n', '            multisig.authority = authority;\n', '        }\n', '        // Adjust balance and locktime\n', '        reparametrizeMultisig(msigId, unlockTime);\n', '    }\n', '\n', '    /**\n', '    @notice Inititate/extend multisig unlockTime and/or initiate/refund multisig deposit\n', '    @dev Can increase deposit and/or unlockTime but not owner or authority\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @param unlockTime Lock Ether until unlockTime in seconds.\n', '    */\n', '    function reparametrizeMultisig(bytes32 msigId, uint unlockTime)\n', '        public\n', '        payable\n', '    {\n', '        require(multisigs[msigId].owner == msg.sender);\n', '        Multisig storage multisig = multisigs[msigId];\n', '        multisig.deposit = add(multisig.deposit, msg.value);\n', '        assert(multisig.unlockTime <= unlockTime); // Can only increase unlockTime\n', '        multisig.unlockTime = unlockTime;\n', '        emit MultisigReparametrized(msigId);\n', '    }\n', '\n', '    /**\n', '    @notice Withdraw ether from the multisig. Equivalent to EARLY_RESOLVE in Nimiq\n', '    @dev the signature is generated using web3.eth.sign() over the unique msigId\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @param amount Return this amount from this contract to owner\n', '    @param sig bytes signature of the not transaction sending Authority\n', '    */\n', '    function earlyResolve(bytes32 msigId, uint amount, bytes sig)\n', '        public\n', '    {\n', '        // Require: msg.sender == (owner or authority)\n', '        require(\n', '            multisigs[msigId].owner == msg.sender ||\n', '            multisigs[msigId].authority == msg.sender\n', '        );\n', '        // Require: valid signature from not msg.sending authority\n', '        address otherAuthority = multisigs[msigId].owner == msg.sender ?\n', '            multisigs[msigId].authority :\n', '            multisigs[msigId].owner;\n', '        require(otherAuthority == msigId.toEthSignedMessageHash().recover(sig));\n', '        // Return to owner\n', '        spendFromMultisig(msigId, amount, multisigs[msigId].owner);\n', '    }\n', '\n', '    /**\n', '    @notice Withdraw ether and delete the htlc swap. Equivalent to TIMEOUT_RESOLVE in Nimiq\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @dev Only refunds owned multisig deposits\n', '    */\n', '    function timeoutResolve(bytes32 msigId, uint amount)\n', '        public\n', '    {\n', '        // Require time has passed\n', '        require(now >= multisigs[msigId].unlockTime);\n', '        // Return to owner\n', '        spendFromMultisig(msigId, amount, multisigs[msigId].owner);\n', '    }\n', '\n', '    /**\n', '    @notice First or second stage of atomic swap.\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier\n', '    @param beneficiary Beneficiary of this swap\n', '    @param amount Convert this amount from multisig into swap\n', '    @param fee Fee amount to be paid to multisig authority\n', '    @param expirationTime Swap expiration timestamp in seconds; not more than 1 day from now\n', '    @param hashedSecret sha256(secret), hashed secret of swap initiator\n', '    @return swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier\n', '    */\n', '    function convertIntoHtlc(bytes32 msigId, address beneficiary, uint amount, uint fee, uint expirationTime, bytes32 hashedSecret)\n', '        public\n', '        returns (bytes32 swapId)\n', '    {\n', '        // Require owner with sufficient deposit\n', '        require(multisigs[msigId].owner == msg.sender);\n', '        require(multisigs[msigId].deposit >= amount + fee); // Checks for underflow\n', '        require(\n', '            now <= expirationTime &&\n', '            expirationTime <= min(now + 1 days, multisigs[msigId].unlockTime)\n', '        ); // Not more than 1 day or unlockTime\n', '        require(amount > 0); // Non-empty amount as definition for active swap\n', '        require(!isAntecedentHashedSecret[hashedSecret]);\n', '        isAntecedentHashedSecret[hashedSecret] = true;\n', '        // Account in multisig balance\n', '        multisigs[msigId].deposit = sub(multisigs[msigId].deposit, add(amount, fee));\n', '        // Create swap identifier\n', '        swapId = keccak256(\n', '            msigId,\n', '            msg.sender,\n', '            beneficiary,\n', '            amount,\n', '            fee,\n', '            expirationTime,\n', '            hashedSecret\n', '        );\n', '        emit AtomicSwapInitialised(swapId);\n', '        // Create swap\n', '        AtomicSwap storage swap = atomicswaps[swapId];\n', '        swap.msigId = msigId;\n', '        swap.initiator = msg.sender;\n', '        swap.beneficiary = beneficiary;\n', '        swap.amount = amount;\n', '        swap.fee = fee;\n', '        swap.expirationTime = expirationTime;\n', '        swap.hashedSecret = hashedSecret;\n', '        // Transfer fee to fee recipient\n', '        FEE_RECIPIENT.transfer(fee);\n', '    }\n', '\n', '    /**\n', '    @notice Batch execution of convertIntoHtlc() function\n', '    */\n', '    function batchConvertIntoHtlc(\n', '        bytes32[] msigIds,\n', '        address[] beneficiaries,\n', '        uint[] amounts,\n', '        uint[] fees,\n', '        uint[] expirationTimes,\n', '        bytes32[] hashedSecrets\n', '    )\n', '        public\n', '        returns (bytes32[] swapId)\n', '    {\n', '        require(msigIds.length <= MAX_BATCH_ITERATIONS);\n', '        for (uint i = 0; i < msigIds.length; ++i)\n', '            convertIntoHtlc(\n', '                msigIds[i],\n', '                beneficiaries[i],\n', '                amounts[i],\n', '                fees[i],\n', '                expirationTimes[i],\n', '                hashedSecrets[i]\n', '            ); // Gas estimate `infinite`\n', '    }\n', '\n', '    /**\n', '    @notice Withdraw ether and delete the htlc swap. Equivalent to REGULAR_TRANSFER in Nimiq\n', '    @dev Transfer swap amount to beneficiary of swap and fee to authority\n', '    @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier\n', '    @param secret Hashed secret of htlc swap\n', '    */\n', '    function regularTransfer(bytes32 swapId, bytes32 secret)\n', '        public\n', '    {\n', '        // Require valid secret provided\n', '        require(sha256(secret) == atomicswaps[swapId].hashedSecret);\n', '        uint amount = atomicswaps[swapId].amount;\n', '        address beneficiary = atomicswaps[swapId].beneficiary;\n', '        // Delete swap\n', '        delete atomicswaps[swapId];\n', '        // Execute swap\n', '        beneficiary.transfer(amount);\n', '    }\n', '\n', '    /**\n', '    @notice Batch exection of regularTransfer() function\n', '    */\n', '    function batchRegularTransfer(bytes32[] swapIds, bytes32[] secrets)\n', '        public\n', '    {\n', '        require(swapIds.length <= MAX_BATCH_ITERATIONS);\n', '        for (uint i = 0; i < swapIds.length; ++i)\n', '            regularTransfer(swapIds[i], secrets[i]); // Gas estimate `infinite`\n', '    }\n', '\n', '    /**\n', '    @notice Reclaim an expired, non-empty swap into a multisig\n', '    @dev Transfer swap amount to beneficiary of swap and fee to authority\n', '    @param msigId Unique (owner, authority, balance != 0) multisig identifier to which deposit expired swaps\n', '    @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier\n', '    */\n', '    function reclaimExpiredSwap(bytes32 msigId, bytes32 swapId)\n', '        public\n', '    {\n', '        // Require: msg.sender == ower or authority\n', '        require(\n', '            multisigs[msigId].owner == msg.sender ||\n', '            multisigs[msigId].authority == msg.sender\n', '        );\n', '        // Require msigId matches swapId\n', '        require(msigId == atomicswaps[swapId].msigId);\n', '        // Require: is expired\n', '        require(now >= atomicswaps[swapId].expirationTime);\n', '        uint amount = atomicswaps[swapId].amount;\n', '        delete atomicswaps[swapId];\n', '        multisigs[msigId].deposit = add(multisigs[msigId].deposit, amount);\n', '    }\n', '\n', '    /**\n', '    @notice Batch exection of reclaimExpiredSwaps() function\n', '    */\n', '    function batchReclaimExpiredSwaps(bytes32 msigId, bytes32[] swapIds)\n', '        public\n', '    {\n', '        require(swapIds.length <= MAX_BATCH_ITERATIONS); // << block.gaslimit / 88281\n', '        for (uint i = 0; i < swapIds.length; ++i)\n', '            reclaimExpiredSwap(msigId, swapIds[i]); // Gas estimate 88281\n', '    }\n', '}']
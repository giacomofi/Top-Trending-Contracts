['pragma solidity ^0.4.10;\n', '\n', 'contract GasToken2 {\n', '    //////////////////////////////////////////////////////////////////////////\n', '    // RLP.sol\n', '    // Due to some unexplained bug, we get a slightly different bytecode if \n', '    // we use an import, and are then unable to verify the code in Etherscan\n', '    //////////////////////////////////////////////////////////////////////////\n', '    \n', '    uint256 constant ADDRESS_BYTES = 20;\n', '    uint256 constant MAX_SINGLE_BYTE = 128;\n', '    uint256 constant MAX_NONCE = 256**9 - 1;\n', '\n', '    // count number of bytes required to represent an unsigned integer\n', '    function count_bytes(uint256 n) constant internal returns (uint256 c) {\n', '        uint i = 0;\n', '        uint mask = 1;\n', '        while (n >= mask) {\n', '            i += 1;\n', '            mask *= 256;\n', '        }\n', '\n', '        return i;\n', '    }\n', '\n', '    function mk_contract_address(address a, uint256 n) constant internal returns (address rlp) {\n', '        /*\n', '         * make sure the RLP encoding fits in one word:\n', '         * total_length      1 byte\n', '         * address_length    1 byte\n', '         * address          20 bytes\n', '         * nonce_length      1 byte (or 0)\n', '         * nonce           1-9 bytes\n', '         *                ==========\n', '         *                24-32 bytes\n', '         */\n', '        require(n <= MAX_NONCE);\n', '\n', '        // number of bytes required to write down the nonce\n', '        uint256 nonce_bytes;\n', '        // length in bytes of the RLP encoding of the nonce\n', '        uint256 nonce_rlp_len;\n', '\n', '        if (0 < n && n < MAX_SINGLE_BYTE) {\n', '            // nonce fits in a single byte\n', '            // RLP(nonce) = nonce\n', '            nonce_bytes = 1;\n', '            nonce_rlp_len = 1;\n', '        } else {\n', '            // RLP(nonce) = [num_bytes_in_nonce nonce]\n', '            nonce_bytes = count_bytes(n);\n', '            nonce_rlp_len = nonce_bytes + 1;\n', '        }\n', '\n', '        // [address_length(1) address(20) nonce_length(0 or 1) nonce(1-9)]\n', '        uint256 tot_bytes = 1 + ADDRESS_BYTES + nonce_rlp_len;\n', '\n', '        // concatenate all parts of the RLP encoding in the leading bytes of\n', '        // one 32-byte word\n', '        uint256 word = ((192 + tot_bytes) * 256**31) +\n', '                       ((128 + ADDRESS_BYTES) * 256**30) +\n', '                       (uint256(a) * 256**10);\n', '\n', '        if (0 < n && n < MAX_SINGLE_BYTE) {\n', '            word += n * 256**9;\n', '        } else {\n', '            word += (128 + nonce_bytes) * 256**9;\n', '            word += n * 256**(9 - nonce_bytes);\n', '        }\n', '\n', '        uint256 hash;\n', '\n', '        assembly {\n', '            let mem_start := mload(0x40)        // get a pointer to free memory\n', '            mstore(0x40, add(mem_start, 0x20))  // update the pointer\n', '\n', '            mstore(mem_start, word)             // store the rlp encoding\n', '            hash := sha3(mem_start,\n', '                         add(tot_bytes, 1))     // hash the rlp encoding\n', '        }\n', '\n', '        // interpret hash as address (20 least significant bytes)\n', '        return address(hash);\n', '    }\n', '    \n', '    //////////////////////////////////////////////////////////////////////////\n', '    // Generic ERC20\n', '    //////////////////////////////////////////////////////////////////////////\n', '\n', '    // owner -> amount\n', '    mapping(address => uint256) s_balances;\n', '    // owner -> spender -> max amount\n', '    mapping(address => mapping(address => uint256)) s_allowances;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    // Spec: Get the account balance of another account with address `owner`\n', '    function balanceOf(address owner) public constant returns (uint256 balance) {\n', '        return s_balances[owner];\n', '    }\n', '\n', '    function internalTransfer(address from, address to, uint256 value) internal returns (bool success) {\n', '        if (value <= s_balances[from]) {\n', '            s_balances[from] -= value;\n', '            s_balances[to] += value;\n', '            Transfer(from, to, value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Spec: Send `value` amount of tokens to address `to`\n', '    function transfer(address to, uint256 value) public returns (bool success) {\n', '        address from = msg.sender;\n', '        return internalTransfer(from, to, value);\n', '    }\n', '\n', '    // Spec: Send `value` amount of tokens from address `from` to address `to`\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success) {\n', '        address spender = msg.sender;\n', '        if(value <= s_allowances[from][spender] && internalTransfer(from, to, value)) {\n', '            s_allowances[from][spender] -= value;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Spec: Allow `spender` to withdraw from your account, multiple times, up\n', '    // to the `value` amount. If this function is called again it overwrites the\n', '    // current allowance with `value`.\n', '    function approve(address spender, uint256 value) public returns (bool success) {\n', '        address owner = msg.sender;\n', '        if (value != 0 && s_allowances[owner][spender] != 0) {\n', '            return false;\n', '        }\n', '        s_allowances[owner][spender] = value;\n', '        Approval(owner, spender, value);\n', '        return true;\n', '    }\n', '\n', '    // Spec: Returns the `amount` which `spender` is still allowed to withdraw\n', '    // from `owner`.\n', '    // What if the allowance is higher than the balance of the `owner`?\n', '    // Callers should be careful to use min(allowance, balanceOf) to make sure\n', '    // that the allowance is actually present in the account!\n', '    function allowance(address owner, address spender) public constant returns (uint256 remaining) {\n', '        return s_allowances[owner][spender];\n', '    }\n', '\n', '    //////////////////////////////////////////////////////////////////////////\n', '    // GasToken specifics\n', '    //////////////////////////////////////////////////////////////////////////\n', '\n', '    uint8 constant public decimals = 2;\n', '    string constant public name = "Gastoken.io";\n', '    string constant public symbol = "GST2";\n', '\n', '    // We build a queue of nonces at which child contracts are stored. s_head is\n', '    // the nonce at the head of the queue, s_tail is the nonce behind the tail\n', '    // of the queue. The queue grows at the head and shrinks from the tail.\n', '    // Note that when and only when a contract CREATEs another contract, the\n', "    // creating contract's nonce is incremented.\n", '    // The first child contract is created with nonce == 1, the second child\n', '    // contract is created with nonce == 2, and so on...\n', '    // For example, if there are child contracts at nonces [2,3,4],\n', '    // then s_head == 4 and s_tail == 1. If there are no child contracts,\n', '    // s_head == s_tail.\n', '    uint256 s_head;\n', '    uint256 s_tail;\n', '\n', '    // totalSupply gives  the number of tokens currently in existence\n', '    // Each token corresponds to one child contract that can be SELFDESTRUCTed\n', '    // for a gas refund.\n', '    function totalSupply() public constant returns (uint256 supply) {\n', '        return s_head - s_tail;\n', '    }\n', '\n', '    // Creates a child contract that can only be destroyed by this contract.\n', '    function makeChild() internal returns (address addr) {\n', '        assembly {\n', '            // EVM assembler of runtime portion of child contract:\n', '            //     ;; Pseudocode: if (msg.sender != 0x0000000000b3f879cb30fe243b4dfee438691c04) { throw; }\n', '            //     ;;             suicide(msg.sender)\n', '            //     PUSH15 0xb3f879cb30fe243b4dfee438691c04 ;; hardcoded address of this contract\n', '            //     CALLER\n', '            //     XOR\n', '            //     PC\n', '            //     JUMPI\n', '            //     CALLER\n', '            //     SELFDESTRUCT\n', '            // Or in binary: 6eb3f879cb30fe243b4dfee438691c043318585733ff\n', '            // Since the binary is so short (22 bytes), we can get away\n', '            // with a very simple initcode:\n', '            //     PUSH22 0x6eb3f879cb30fe243b4dfee438691c043318585733ff\n', '            //     PUSH1 0\n', '            //     MSTORE ;; at this point, memory locations mem[10] through\n', '            //            ;; mem[31] contain the runtime portion of the child\n', "            //            ;; contract. all that's left to do is to RETURN this\n", '            //            ;; chunk of memory.\n', '            //     PUSH1 22 ;; length\n', '            //     PUSH1 10 ;; offset\n', '            //     RETURN\n', '            // Or in binary: 756eb3f879cb30fe243b4dfee438691c043318585733ff6000526016600af3\n', '            // Almost done! All we have to do is put this short (31 bytes) blob into\n', '            // memory and call CREATE with the appropriate offsets.\n', '            let solidity_free_mem_ptr := mload(0x40)\n', '            mstore(solidity_free_mem_ptr, 0x00756eb3f879cb30fe243b4dfee438691c043318585733ff6000526016600af3)\n', '            addr := create(0, add(solidity_free_mem_ptr, 1), 31)\n', '        }\n', '    }\n', '\n', '    // Mints `value` new sub-tokens (e.g. cents, pennies, ...) by creating `value`\n', '    // new child contracts. The minted tokens are owned by the caller of this\n', '    // function.\n', '    function mint(uint256 value) public {\n', '        for (uint256 i = 0; i < value; i++) {\n', '            makeChild();\n', '        }\n', '        s_head += value;\n', '        s_balances[msg.sender] += value;\n', '    }\n', '\n', '    // Destroys `value` child contracts and updates s_tail.\n', '    //\n', '    // This function is affected by an issue in solc: https://github.com/ethereum/solidity/issues/2999\n', "    // The `mk_contract_address(this, i).call();` doesn't forward all available gas, but only GAS - 25710.\n", '    // As a result, when this line is executed with e.g. 30000 gas, the callee will have less than 5000 gas\n', '    // available and its SELFDESTRUCT operation will fail leading to no gas refund occurring.\n', "    // The remaining ~29000 gas left after the call is enough to update s_tail and the caller's balance.\n", '    // Hence tokens will have been destroyed without a commensurate gas refund.\n', '    // Fortunately, there is a simple workaround:\n', '    // Whenever you call free, freeUpTo, freeFrom, or freeUpToFrom, ensure that you pass at least\n', "    // 25710 + `value` * (1148 + 5722 + 150) gas. (It won't all be used)\n", '    function destroyChildren(uint256 value) internal {\n', '        uint256 tail = s_tail;\n', '        // tail points to slot behind the last contract in the queue\n', '        for (uint256 i = tail + 1; i <= tail + value; i++) {\n', '            mk_contract_address(this, i).call();\n', '        }\n', '\n', '        s_tail = tail + value;\n', '    }\n', '\n', '    // Frees `value` sub-tokens (e.g. cents, pennies, ...) belonging to the\n', '    // caller of this function by destroying `value` child contracts, which\n', '    // will trigger a partial gas refund.\n', '    // You should ensure that you pass at least 25710 + `value` * (1148 + 5722 + 150) gas\n', '    // when calling this function. For details, see the comment above `destroyChilden`.\n', '    function free(uint256 value) public returns (bool success) {\n', '        uint256 from_balance = s_balances[msg.sender];\n', '        if (value > from_balance) {\n', '            return false;\n', '        }\n', '\n', '        destroyChildren(value);\n', '\n', '        s_balances[msg.sender] = from_balance - value;\n', '\n', '        return true;\n', '    }\n', '\n', '    // Frees up to `value` sub-tokens. Returns how many tokens were freed.\n', '    // Otherwise, identical to free.\n', '    // You should ensure that you pass at least 25710 + `value` * (1148 + 5722 + 150) gas\n', '    // when calling this function. For details, see the comment above `destroyChilden`.\n', '    function freeUpTo(uint256 value) public returns (uint256 freed) {\n', '        uint256 from_balance = s_balances[msg.sender];\n', '        if (value > from_balance) {\n', '            value = from_balance;\n', '        }\n', '\n', '        destroyChildren(value);\n', '\n', '        s_balances[msg.sender] = from_balance - value;\n', '\n', '        return value;\n', '    }\n', '\n', '    // Frees `value` sub-tokens owned by address `from`. Requires that `msg.sender`\n', '    // has been approved by `from`.\n', '    // You should ensure that you pass at least 25710 + `value` * (1148 + 5722 + 150) gas\n', '    // when calling this function. For details, see the comment above `destroyChilden`.\n', '    function freeFrom(address from, uint256 value) public returns (bool success) {\n', '        address spender = msg.sender;\n', '        uint256 from_balance = s_balances[from];\n', '        if (value > from_balance) {\n', '            return false;\n', '        }\n', '\n', '        mapping(address => uint256) from_allowances = s_allowances[from];\n', '        uint256 spender_allowance = from_allowances[spender];\n', '        if (value > spender_allowance) {\n', '            return false;\n', '        }\n', '\n', '        destroyChildren(value);\n', '\n', '        s_balances[from] = from_balance - value;\n', '        from_allowances[spender] = spender_allowance - value;\n', '\n', '        return true;\n', '    }\n', '\n', '    // Frees up to `value` sub-tokens owned by address `from`. Returns how many tokens were freed.\n', '    // Otherwise, identical to `freeFrom`.\n', '    // You should ensure that you pass at least 25710 + `value` * (1148 + 5722 + 150) gas\n', '    // when calling this function. For details, see the comment above `destroyChilden`.\n', '    function freeFromUpTo(address from, uint256 value) public returns (uint256 freed) {\n', '        address spender = msg.sender;\n', '        uint256 from_balance = s_balances[from];\n', '        if (value > from_balance) {\n', '            value = from_balance;\n', '        }\n', '\n', '        mapping(address => uint256) from_allowances = s_allowances[from];\n', '        uint256 spender_allowance = from_allowances[spender];\n', '        if (value > spender_allowance) {\n', '            value = spender_allowance;\n', '        }\n', '\n', '        destroyChildren(value);\n', '\n', '        s_balances[from] = from_balance - value;\n', '        from_allowances[spender] = spender_allowance - value;\n', '\n', '        return value;\n', '    }\n', '}']
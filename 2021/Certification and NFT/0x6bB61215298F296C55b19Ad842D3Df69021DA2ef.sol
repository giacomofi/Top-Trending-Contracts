['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'contract Dop {\n', '    /// @notice EIP-20 token name for this token\n', '    string public constant name = "Drops Ownership Power";\n', '\n', '    /// @notice EIP-20 token symbol for this token\n', '    string public constant symbol = "DOP";\n', '\n', '    /// @notice EIP-20 token decimals for this token\n', '    uint8 public constant decimals = 18;\n', '\n', '    /// @notice Total number of tokens in circulation\n', '    uint256 public constant totalSupply = 15000000e18; // 15m\n', '\n', '    /// @notice Allowance amounts on behalf of others\n', '    mapping(address => mapping(address => uint96)) internal allowances;\n', '\n', '    /// @notice Official record of token balances for each account\n', '    mapping(address => uint96) internal balances;\n', '\n', '    /// @notice A record of each accounts delegate\n', '    mapping(address => address) public delegates;\n', '\n', '    /// @notice A checkpoint for marking number of votes from a given block\n', '    struct Checkpoint {\n', '        uint32 fromBlock;\n', '        uint96 votes;\n', '    }\n', '\n', '    /// @notice A record of votes checkpoints for each account, by index\n', '    mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;\n', '\n', '    /// @notice The number of checkpoints for each account\n', '    mapping(address => uint32) public numCheckpoints;\n', '\n', "    /// @notice The EIP-712 typehash for the contract's domain\n", '    bytes32 public constant DOMAIN_TYPEHASH =\n', '        keccak256(\n', '            "EIP712Domain(string name,uint256 chainId,address verifyingContract)"\n', '        );\n', '\n', '    /// @notice The EIP-712 typehash for the delegation struct used by the contract\n', '    bytes32 public constant DELEGATION_TYPEHASH =\n', '        keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");\n', '\n', '    /// @notice A record of states for signing / validating signatures\n', '    mapping(address => uint256) public nonces;\n', '\n', '    /// @notice An event thats emitted when an account changes its delegate\n', '    event DelegateChanged(\n', '        address indexed delegator,\n', '        address indexed fromDelegate,\n', '        address indexed toDelegate\n', '    );\n', '\n', "    /// @notice An event thats emitted when a delegate account's vote balance changes\n", '    event DelegateVotesChanged(\n', '        address indexed delegate,\n', '        uint256 previousBalance,\n', '        uint256 newBalance\n', '    );\n', '\n', '    /// @notice The standard EIP-20 transfer event\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '\n', '    /// @notice The standard EIP-20 approval event\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 amount\n', '    );\n', '\n', '    /**\n', '     * @notice Construct a new Comp token\n', '     * @param account The initial account to grant all the tokens\n', '     */\n', '    constructor(address account) public {\n', '        balances[account] = uint96(totalSupply);\n', '        emit Transfer(address(0), account, totalSupply);\n', '    }\n', '\n', '    /**\n', '     * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`\n', '     * @param account The address of the account holding the funds\n', '     * @param spender The address of the account spending the funds\n', '     * @return The number of tokens approved\n', '     */\n', '    function allowance(address account, address spender)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowances[account][spender];\n', '    }\n', '\n', '    /**\n', '     * @notice Approve `spender` to transfer up to `amount` from `src`\n', '     * @dev This will overwrite the approval amount for `spender`\n', '     *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)\n', '     * @param spender The address of the account which may transfer tokens\n', '     * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)\n', '     * @return Whether or not the approval succeeded\n', '     */\n', '    function approve(address spender, uint256 rawAmount)\n', '        external\n', '        returns (bool)\n', '    {\n', '        uint96 amount;\n', '        if (rawAmount == uint256(-1)) {\n', '            amount = uint96(-1);\n', '        } else {\n', '            amount = safe96(rawAmount, "Comp::approve: amount exceeds 96 bits");\n', '        }\n', '\n', '        allowances[msg.sender][spender] = amount;\n', '\n', '        emit Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Get the number of tokens held by the `account`\n', '     * @param account The address of the account to get the balance of\n', '     * @return The number of tokens held\n', '     */\n', '    function balanceOf(address account) external view returns (uint256) {\n', '        return balances[account];\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `msg.sender` to `dst`\n', '     * @param dst The address of the destination account\n', '     * @param rawAmount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transfer(address dst, uint256 rawAmount) external returns (bool) {\n', '        uint96 amount =\n', '            safe96(rawAmount, "Comp::transfer: amount exceeds 96 bits");\n', '        _transferTokens(msg.sender, dst, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `src` to `dst`\n', '     * @param src The address of the source account\n', '     * @param dst The address of the destination account\n', '     * @param rawAmount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transferFrom(\n', '        address src,\n', '        address dst,\n', '        uint256 rawAmount\n', '    ) external returns (bool) {\n', '        address spender = msg.sender;\n', '        uint96 spenderAllowance = allowances[src][spender];\n', '        uint96 amount =\n', '            safe96(rawAmount, "Comp::approve: amount exceeds 96 bits");\n', '\n', '        if (spender != src && spenderAllowance != uint96(-1)) {\n', '            uint96 newAllowance =\n', '                sub96(\n', '                    spenderAllowance,\n', '                    amount,\n', '                    "Comp::transferFrom: transfer amount exceeds spender allowance"\n', '                );\n', '            allowances[src][spender] = newAllowance;\n', '\n', '            emit Approval(src, spender, newAllowance);\n', '        }\n', '\n', '        _transferTokens(src, dst, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Delegate votes from `msg.sender` to `delegatee`\n', '     * @param delegatee The address to delegate votes to\n', '     */\n', '    function delegate(address delegatee) public {\n', '        return _delegate(msg.sender, delegatee);\n', '    }\n', '\n', '    /**\n', '     * @notice Delegates votes from signatory to `delegatee`\n', '     * @param delegatee The address to delegate votes to\n', '     * @param nonce The contract state required to match the signature\n', '     * @param expiry The time at which to expire the signature\n', '     * @param v The recovery byte of the signature\n', '     * @param r Half of the ECDSA signature pair\n', '     * @param s Half of the ECDSA signature pair\n', '     */\n', '    function delegateBySig(\n', '        address delegatee,\n', '        uint256 nonce,\n', '        uint256 expiry,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) public {\n', '        bytes32 domainSeparator =\n', '            keccak256(\n', '                abi.encode(\n', '                    DOMAIN_TYPEHASH,\n', '                    keccak256(bytes(name)),\n', '                    getChainId(),\n', '                    address(this)\n', '                )\n', '            );\n', '        bytes32 structHash =\n', '            keccak256(\n', '                abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)\n', '            );\n', '        bytes32 digest =\n', '            keccak256(\n', '                abi.encodePacked("\\x19\\x01", domainSeparator, structHash)\n', '            );\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(\n', '            signatory != address(0),\n', '            "Comp::delegateBySig: invalid signature"\n', '        );\n', '        require(\n', '            nonce == nonces[signatory]++,\n', '            "Comp::delegateBySig: invalid nonce"\n', '        );\n', '        require(now <= expiry, "Comp::delegateBySig: signature expired");\n', '        return _delegate(signatory, delegatee);\n', '    }\n', '\n', '    /**\n', '     * @notice Gets the current votes balance for `account`\n', '     * @param account The address to get votes balance\n', '     * @return The number of current votes for `account`\n', '     */\n', '    function getCurrentVotes(address account) external view returns (uint96) {\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        return\n', '            nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;\n', '    }\n', '\n', '    /**\n', '     * @notice Determine the prior number of votes for an account as of a block number\n', '     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.\n', '     * @param account The address of the account to check\n', '     * @param blockNumber The block number to get the vote balance at\n', '     * @return The number of votes the account had as of the given block\n', '     */\n', '    function getPriorVotes(address account, uint256 blockNumber)\n', '        public\n', '        view\n', '        returns (uint96)\n', '    {\n', '        require(\n', '            blockNumber < block.number,\n', '            "Comp::getPriorVotes: not yet determined"\n', '        );\n', '\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        if (nCheckpoints == 0) {\n', '            return 0;\n', '        }\n', '\n', '        // First check most recent balance\n', '        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {\n', '            return checkpoints[account][nCheckpoints - 1].votes;\n', '        }\n', '\n', '        // Next check implicit zero balance\n', '        if (checkpoints[account][0].fromBlock > blockNumber) {\n', '            return 0;\n', '        }\n', '\n', '        uint32 lower = 0;\n', '        uint32 upper = nCheckpoints - 1;\n', '        while (upper > lower) {\n', '            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow\n', '            Checkpoint memory cp = checkpoints[account][center];\n', '            if (cp.fromBlock == blockNumber) {\n', '                return cp.votes;\n', '            } else if (cp.fromBlock < blockNumber) {\n', '                lower = center;\n', '            } else {\n', '                upper = center - 1;\n', '            }\n', '        }\n', '        return checkpoints[account][lower].votes;\n', '    }\n', '\n', '    function _delegate(address delegator, address delegatee) internal {\n', '        address currentDelegate = delegates[delegator];\n', '        uint96 delegatorBalance = balances[delegator];\n', '        delegates[delegator] = delegatee;\n', '\n', '        emit DelegateChanged(delegator, currentDelegate, delegatee);\n', '\n', '        _moveDelegates(currentDelegate, delegatee, delegatorBalance);\n', '    }\n', '\n', '    function _transferTokens(\n', '        address src,\n', '        address dst,\n', '        uint96 amount\n', '    ) internal {\n', '        require(\n', '            src != address(0),\n', '            "Comp::_transferTokens: cannot transfer from the zero address"\n', '        );\n', '        require(\n', '            dst != address(0),\n', '            "Comp::_transferTokens: cannot transfer to the zero address"\n', '        );\n', '\n', '        balances[src] = sub96(\n', '            balances[src],\n', '            amount,\n', '            "Comp::_transferTokens: transfer amount exceeds balance"\n', '        );\n', '        balances[dst] = add96(\n', '            balances[dst],\n', '            amount,\n', '            "Comp::_transferTokens: transfer amount overflows"\n', '        );\n', '        emit Transfer(src, dst, amount);\n', '\n', '        _moveDelegates(delegates[src], delegates[dst], amount);\n', '    }\n', '\n', '    function _moveDelegates(\n', '        address srcRep,\n', '        address dstRep,\n', '        uint96 amount\n', '    ) internal {\n', '        if (srcRep != dstRep && amount > 0) {\n', '            if (srcRep != address(0)) {\n', '                uint32 srcRepNum = numCheckpoints[srcRep];\n', '                uint96 srcRepOld =\n', '                    srcRepNum > 0\n', '                        ? checkpoints[srcRep][srcRepNum - 1].votes\n', '                        : 0;\n', '                uint96 srcRepNew =\n', '                    sub96(\n', '                        srcRepOld,\n', '                        amount,\n', '                        "Comp::_moveVotes: vote amount underflows"\n', '                    );\n', '                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);\n', '            }\n', '\n', '            if (dstRep != address(0)) {\n', '                uint32 dstRepNum = numCheckpoints[dstRep];\n', '                uint96 dstRepOld =\n', '                    dstRepNum > 0\n', '                        ? checkpoints[dstRep][dstRepNum - 1].votes\n', '                        : 0;\n', '                uint96 dstRepNew =\n', '                    add96(\n', '                        dstRepOld,\n', '                        amount,\n', '                        "Comp::_moveVotes: vote amount overflows"\n', '                    );\n', '                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _writeCheckpoint(\n', '        address delegatee,\n', '        uint32 nCheckpoints,\n', '        uint96 oldVotes,\n', '        uint96 newVotes\n', '    ) internal {\n', '        uint32 blockNumber =\n', '            safe32(\n', '                block.number,\n', '                "Comp::_writeCheckpoint: block number exceeds 32 bits"\n', '            );\n', '\n', '        if (\n', '            nCheckpoints > 0 &&\n', '            checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber\n', '        ) {\n', '            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;\n', '        } else {\n', '            checkpoints[delegatee][nCheckpoints] = Checkpoint(\n', '                blockNumber,\n', '                newVotes\n', '            );\n', '            numCheckpoints[delegatee] = nCheckpoints + 1;\n', '        }\n', '\n', '        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);\n', '    }\n', '\n', '    function safe32(uint256 n, string memory errorMessage)\n', '        internal\n', '        pure\n', '        returns (uint32)\n', '    {\n', '        require(n < 2**32, errorMessage);\n', '        return uint32(n);\n', '    }\n', '\n', '    function safe96(uint256 n, string memory errorMessage)\n', '        internal\n', '        pure\n', '        returns (uint96)\n', '    {\n', '        require(n < 2**96, errorMessage);\n', '        return uint96(n);\n', '    }\n', '\n', '    function add96(\n', '        uint96 a,\n', '        uint96 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint96) {\n', '        uint96 c = a + b;\n', '        require(c >= a, errorMessage);\n', '        return c;\n', '    }\n', '\n', '    function sub96(\n', '        uint96 a,\n', '        uint96 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint96) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    function getChainId() internal pure returns (uint256) {\n', '        uint256 chainId;\n', '        assembly {\n', '            chainId := chainid()\n', '        }\n', '        return chainId;\n', '    }\n', '}\n', '\n', '{\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "metadata": {\n', '    "bytecodeHash": "ipfs",\n', '    "useLiteralContent": true\n', '  },\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "remappings": [],\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']
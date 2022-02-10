['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-04\n', '*/\n', '\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface TokenInterface {\n', '    function transferFrom(address, address, uint) external returns (bool);\n', '    function transfer(address, uint) external returns (bool);\n', '}\n', '\n', 'contract Pasta {\n', '    /// @notice EIP-20 token name for this token\n', '    string public constant name = "Pasta DAO 🍝";\n', '\n', '    /// @notice EIP-20 token symbol for this token\n', '    string public constant symbol = "PASTA";\n', '\n', '    string public constant errorMsg = "It\'s all pasta 🌎🧑\u200d🚀🔫🧑\u200d🚀";\n', '\n', '    /// @notice EIP-20 token decimals for this token\n', '    uint8 public constant decimals = 18;\n', '\n', '    /// @notice Total number of tokens in circulation\n', '    uint public totalSupply;\n', '\n', '    /// @notice Address of UNI-V2 ETH/PASTA LP Token\n', '    TokenInterface public constant food = TokenInterface(0xE92346d9369Fe03b735Ed9bDeB6bdC2591b8227E);\n', '\n', '    /// @notice Cooldown period in seconds\n', '    uint public immutable COOLDOWN_SECONDS;\n', '\n', '    /// @notice Seconds available to redeem once the cooldown period is fullfilled\n', '    uint public immutable REDEEM_WINDOW;\n', '\n', '    mapping(address => uint) public holderCooldowns;\n', '\n', '    mapping (address => mapping (address => uint96)) internal allowances;\n', '\n', '    mapping (address => uint96) internal balances;\n', '\n', '    /// @notice A record of each accounts delegate\n', '    mapping (address => address) public delegates;\n', '\n', '    /// @notice A checkpoint for marking number of votes from a given block\n', '    struct Checkpoint {\n', '        uint32 fromBlock;\n', '        uint96 votes;\n', '    }\n', '\n', '    /// @notice A record of votes checkpoints for each account, by index\n', '    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;\n', '\n', '    /// @notice The number of checkpoints for each account\n', '    mapping (address => uint32) public numCheckpoints;\n', '\n', "    /// @notice The EIP-712 typehash for the contract's domain\n", '    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");\n', '\n', '    /// @notice The EIP-712 typehash for the delegation struct used by the contract\n', '    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");\n', '\n', '    /// @notice A record of states for signing / validating signatures\n', '    mapping (address => uint) public nonces;\n', '\n', '    /// @notice An event thats emitted when an account changes its delegate\n', '    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);\n', '\n', "    /// @notice An event thats emitted when a delegate account's vote balance changes\n", '    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);\n', '\n', '    /// @notice The standard EIP-20 transfer event\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '\n', '    /// @notice The standard EIP-20 approval event\n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '\n', '    event Cooldown(address indexed user);\n', '\n', '    constructor(uint cooldown_, uint redeemWindow_) public {\n', '        COOLDOWN_SECONDS = cooldown_;\n', '        REDEEM_WINDOW = redeemWindow_;\n', '    }\n', '\n', '    /**\n', '     * @notice Mint tokens from UNI-V2 ETH/PASTA LP Tokens\n', '     * @param dst Address of the user to receive the tokens\n', '     * @param rawAmount The number of tokens to mint\n', '     */\n', '    function mint(address dst, uint rawAmount) external {\n', '        uint96 amount = safe96(rawAmount, "Pasta::mint: amount exceeds 96 bits");\n', '        require(amount != 0, "Pasta::mint: invalid amount");\n', '        require(food.transferFrom(msg.sender, address(this), rawAmount), "Pasta::mint: mint failed");\n', '        balances[dst] = add96(balances[dst], amount, "Pasta::mint: mint amount overflows");\n', '        totalSupply = add256(totalSupply, rawAmount);\n', '        if (delegates[dst] == address(0)) {\n', '            _delegate(dst, dst);\n', '        } else {\n', '            _moveDelegates(address(0), delegates[dst], amount);\n', '        }\n', '        \n', '        emit Transfer(address(0), dst, rawAmount);\n', '    }\n', '\n', '    /**\n', '     * @notice Burn tokens and recieve UNI-V2 ETH/PASTA LP Tokens\n', '     * @param dst Address of the user to receive the tokens\n', '     * @param rawAmount The number of tokens to burn\n', '     */\n', '    function burn(address dst, uint rawAmount) external {\n', '        uint96 amount = safe96(rawAmount, "Pasta::burn: amount exceeds 96 bits");\n', '        require(amount != 0, "Pasta::burn: invalid amount");\n', '\n', '        uint256 cooldownStartTimestamp = holderCooldowns[msg.sender];\n', '        require(\n', '            block.timestamp > add256(cooldownStartTimestamp, COOLDOWN_SECONDS),\n', '            "Pasta::burn: invalid cooldown"\n', '        );\n', '        require(\n', '            sub256(block.timestamp, add256(cooldownStartTimestamp, COOLDOWN_SECONDS)) <= REDEEM_WINDOW,\n', '            "Pasta::burn: redeem window over"\n', '        );\n', '\n', '        uint96 amtToRedeem = (amount > balances[msg.sender]) ? balances[msg.sender] : amount;\n', '\n', '        balances[dst] = sub96(balances[dst], amtToRedeem, "Pasta::burn: burn amount underflows");\n', '        totalSupply = sub256(totalSupply, uint256(amtToRedeem));\n', '\n', '        require(food.transfer(dst, rawAmount), "Pasta::burn: transfer failed");\n', '\n', '        _moveDelegates(delegates[dst], address(0), amtToRedeem);\n', '\n', '        emit Transfer(dst, address(0), rawAmount);\n', '    }\n', '\n', '    /**\n', '     * @dev Activates the cooldown period to redeem\n', '     */\n', '    function cooldown() external {\n', '        require(balances[msg.sender] != 0, "Pasta::cooldown: invalid balance");\n', '        holderCooldowns[msg.sender] = block.timestamp;\n', '\n', '        emit Cooldown(msg.sender);\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`\n', '     * @param account The address of the account holding the funds\n', '     * @param spender The address of the account spending the funds\n', '     * @return The number of tokens approved\n', '     */\n', '    function allowance(address account, address spender) external view returns (uint) {\n', '        return allowances[account][spender];\n', '    }\n', '\n', '    /**\n', '     * @notice Approve `spender` to transfer up to `amount` from `src`\n', '     * @dev This will overwrite the approval amount for `spender`\n', '     *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)\n', '     * @param spender The address of the account which may transfer tokens\n', '     * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)\n', '     * @return Whether or not the approval succeeded\n', '     */\n', '    function approve(address spender, uint rawAmount) pure external returns (bool) {\n', '        revert(errorMsg);\n', '    }\n', '\n', '    /**\n', '     * @notice Get the number of tokens held by the `account`\n', '     * @param account The address of the account to get the balance of\n', '     * @return The number of tokens held\n', '     */\n', '    function balanceOf(address account) external view returns (uint) {\n', '        return balances[account];\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `msg.sender` to `dst`\n', '     * @param dst The address of the destination account\n', '     * @param rawAmount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transfer(address dst, uint rawAmount) pure external returns (bool) {\n', '        revert(errorMsg);\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `src` to `dst`\n', '     * @param src The address of the source account\n', '     * @param dst The address of the destination account\n', '     * @param rawAmount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transferFrom(address src, address dst, uint rawAmount) pure external returns (bool) {\n', '        revert(errorMsg);\n', '    }\n', '\n', '    /**\n', '     * @notice Delegate votes from `msg.sender` to `delegatee`\n', '     * @param delegatee The address to delegate votes to\n', '     */\n', '    function delegate(address delegatee) public {\n', '        return _delegate(msg.sender, delegatee);\n', '    }\n', '\n', '    /**\n', '     * @notice Delegates votes from signatory to `delegatee`\n', '     * @param delegatee The address to delegate votes to\n', '     * @param nonce The contract state required to match the signature\n', '     * @param expiry The time at which to expire the signature\n', '     * @param v The recovery byte of the signature\n', '     * @param r Half of the ECDSA signature pair\n', '     * @param s Half of the ECDSA signature pair\n', '     */\n', '    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "Comp::delegateBySig: invalid signature");\n', '        require(nonce == nonces[signatory]++, "Comp::delegateBySig: invalid nonce");\n', '        require(block.timestamp <= expiry, "Comp::delegateBySig: signature expired");\n', '        return _delegate(signatory, delegatee);\n', '    }\n', '\n', '    /**\n', '     * @notice Gets the current votes balance for `account`\n', '     * @param account The address to get votes balance\n', '     * @return The number of current votes for `account`\n', '     */\n', '    function getCurrentVotes(address account) external view returns (uint96) {\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;\n', '    }\n', '\n', '    /**\n', '     * @notice Determine the prior number of votes for an account as of a block number\n', '     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.\n', '     * @param account The address of the account to check\n', '     * @param blockNumber The block number to get the vote balance at\n', '     * @return The number of votes the account had as of the given block\n', '     */\n', '    function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {\n', '        require(blockNumber < block.number, "Comp::getPriorVotes: not yet determined");\n', '\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        if (nCheckpoints == 0) {\n', '            return 0;\n', '        }\n', '\n', '        // First check most recent balance\n', '        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {\n', '            return checkpoints[account][nCheckpoints - 1].votes;\n', '        }\n', '\n', '        // Next check implicit zero balance\n', '        if (checkpoints[account][0].fromBlock > blockNumber) {\n', '            return 0;\n', '        }\n', '\n', '        uint32 lower = 0;\n', '        uint32 upper = nCheckpoints - 1;\n', '        while (upper > lower) {\n', '            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow\n', '            Checkpoint memory cp = checkpoints[account][center];\n', '            if (cp.fromBlock == blockNumber) {\n', '                return cp.votes;\n', '            } else if (cp.fromBlock < blockNumber) {\n', '                lower = center;\n', '            } else {\n', '                upper = center - 1;\n', '            }\n', '        }\n', '        return checkpoints[account][lower].votes;\n', '    }\n', '\n', '    function _delegate(address delegator, address delegatee) internal {\n', '        address currentDelegate = delegates[delegator];\n', '        uint96 delegatorBalance = balances[delegator];\n', '        delegates[delegator] = delegatee;\n', '\n', '        emit DelegateChanged(delegator, currentDelegate, delegatee);\n', '\n', '        _moveDelegates(currentDelegate, delegatee, delegatorBalance);\n', '    }\n', '\n', '    function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {\n', '        if (srcRep != dstRep && amount > 0) {\n', '            if (srcRep != address(0)) {\n', '                uint32 srcRepNum = numCheckpoints[srcRep];\n', '                uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;\n', '                uint96 srcRepNew = sub96(srcRepOld, amount, "Comp::_moveVotes: vote amount underflows");\n', '                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);\n', '            }\n', '\n', '            if (dstRep != address(0)) {\n', '                uint32 dstRepNum = numCheckpoints[dstRep];\n', '                uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;\n', '                uint96 dstRepNew = add96(dstRepOld, amount, "Comp::_moveVotes: vote amount overflows");\n', '                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {\n', '        uint32 blockNumber = safe32(block.number, "Comp::_writeCheckpoint: block number exceeds 32 bits");\n', '\n', '        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {\n', '            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;\n', '        } else {\n', '            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);\n', '            numCheckpoints[delegatee] = nCheckpoints + 1;\n', '        }\n', '\n', '        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);\n', '    }\n', '\n', '    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {\n', '        require(n < 2**32, errorMessage);\n', '        return uint32(n);\n', '    }\n', '\n', '    function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {\n', '        require(n < 2**96, errorMessage);\n', '        return uint96(n);\n', '    }\n', '\n', '    function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {\n', '        uint96 c = a + b;\n', '        require(c >= a, errorMessage);\n', '        return c;\n', '    }\n', '\n', '    function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    function add256(uint a, uint b) internal pure returns (uint c) {\n', '        require((c = a + b) >= a, "math-not-safe");\n', '    }\n', '\n', '    function sub256(uint a, uint b) internal pure returns (uint c) {\n', '        require((c = a - b) <= a, "math-not-safe");\n', '    }\n', '\n', '    function getChainId() internal pure returns (uint) {\n', '        uint256 chainId;\n', '        assembly { chainId := chainid() }\n', '        return chainId;\n', '    }\n', '}']
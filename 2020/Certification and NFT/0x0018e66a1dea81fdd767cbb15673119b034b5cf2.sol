['pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'abstract contract Token {\n', '    \n', '    function transferFrom(address from, address to, uint256 value) public virtual returns (bool);\n', '\n', '    function balanceOf(address account) external virtual view returns (uint);\n', '    \n', '}\n', '\n', 'contract BNSG {\n', '    /// @notice EIP-20 token name for this token\n', '    string public constant name = "BNS Governance";\n', '\n', '    /// @notice EIP-20 token symbol for this token\n', '    string public constant symbol = "BNSG";\n', '\n', '    address public bnsdAdd;\n', '    address public bnsAdd;\n', '    address public admin;\n', '\n', '    uint96 public bnsToBNSG; // how many satoshi of BNS makes one BNSG\n', '    uint96 public bnsdToBNSG; // how many satoshi of BNSD makes one BNSG\n', '\n', '    // Formula to calculate rates above, Ex - BNS rate - 0.06$, BNSG rate - 1$\n', '    // bnsToBNSG = (BNSG rate in USD) * (10 ** (bnsDecimals))/(BNS rate in USD) = (1e8/ 0.06) = 1666666666\n', '\n', '    /// @notice EIP-20 token decimals for this token\n', '    uint8 public constant decimals = 18;\n', '\n', '    /// @notice Total number of tokens in circulation\n', '    uint96 public constant maxTotalSupply = 10000000e18; // 10 million BNSG\n', '\n', '    uint96 public totalSupply; // Starts with 0\n', '\n', '    /// @notice Allowance amounts on behalf of others\n', '    mapping (address => mapping (address => uint96)) internal allowances;\n', '\n', '    /// @notice Official record of token balances for each account\n', '    mapping (address => uint96) internal balances;\n', '\n', '    /// @notice A record of each accounts delegate\n', '    mapping (address => address) public delegates;\n', '\n', '    /// @notice A checkpoint for marking number of votes from a given block\n', '    struct Checkpoint {\n', '        uint32 fromBlock;\n', '        uint96 votes;\n', '    }\n', '\n', '    /// @notice A record of votes checkpoints for each account, by index\n', '    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;\n', '\n', '    /// @notice The number of checkpoints for each account\n', '    mapping (address => uint32) public numCheckpoints;\n', '\n', "    /// @notice The EIP-712 typehash for the contract's domain\n", '    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");\n', '\n', '    /// @notice The EIP-712 typehash for the delegation struct used by the contract\n', '    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");\n', '\n', '    /// @notice A record of states for signing / validating signatures\n', '    mapping (address => uint) public nonces;\n', '\n', '    bool public rateSet;\n', '\n', '    /// @notice An event thats emitted when an account changes its delegate\n', '    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);\n', '\n', "    /// @notice An event thats emitted when a delegate account's vote balance changes\n", '    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);\n', '\n', '    /// @notice The standard EIP-20 transfer event\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '\n', '    /// @notice The standard EIP-20 approval event\n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '\n', '\n', '    constructor() public {\n', '        admin = msg.sender;\n', '        _mint(admin, 805712895369472282718529); // Amount of token minted in version 1, will be airdropped to users\n', '    }\n', '\n', '    modifier _adminOnly() {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice Add bns and bnsd addresses\n', '     */\n', '    function setAddresses(address _bns, address _bnsd) external _adminOnly returns (bool) {\n', '        bnsAdd = _bns;\n', '        bnsdAdd = _bnsd;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Add rates for bns to bnsg and bnsd to bnsg\n', '     */\n', '    function setTokenRates(uint96 _bnsRate, uint96 _bnsdRate) external _adminOnly returns (bool) {\n', '        bnsToBNSG = _bnsRate;\n', '        bnsdToBNSG = _bnsdRate;\n', '        if(!rateSet){\n', '            rateSet = true;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Mint `BNSG` by buring BNS token from msg.sender based on current rates on contract\n', '     * @param amountToMint The number of BNSG tokens to be minted \n', '     * @return Whether or not the minting succeeded\n', '     */\n', '    function mintBNSGWithBNS(uint96 amountToMint) external returns (bool) {\n', '        require(rateSet, "BNSG::mint: rate not yet set");\n', '        require(amountToMint >= 1e18, "BNSG::mint: min mint amount 1");\n', '        uint96 _bnsNeeded = mul96(div96(amountToMint, 1e18, "BNSG::mint: div failed"),bnsToBNSG, "BNSG::mint: mul failed");\n', '        require(Token(bnsAdd).balanceOf(msg.sender) >= _bnsNeeded, "BNSG::mint: insufficient BNS");\n', '        require(Token(bnsAdd).transferFrom(msg.sender, address(1), _bnsNeeded), "BNSG::mint: burn BNS failed");\n', '        _mint(msg.sender, amountToMint);\n', '        _moveDelegates(delegates[address(0)], delegates[msg.sender], amountToMint);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Mint `BNSG` by buring BNSD token from msg.sender based on current rates on contract\n', '     * @param amountToMint The number of BNSG tokens to be minted \n', '     * @return Whether or not the minting succeeded\n', '     */\n', '    function mintBNSGWithBNSD(uint96 amountToMint) external returns (bool) {\n', '        require(rateSet, "BNSG::mint: rate not yet set");\n', '        require(amountToMint >= 1e18, "BNSG::mint: min mint amount 1");\n', '        uint96 _bnsdNeeded = mul96(div96(amountToMint, 1e18, "BNSG::mint: div failed"),bnsdToBNSG, "BNSG::mint: mul failed");\n', '        require(Token(bnsdAdd).balanceOf(msg.sender) >= _bnsdNeeded, "BNSG::mint: insufficient BNSD");\n', '        require(Token(bnsdAdd).transferFrom(msg.sender, address(1), _bnsdNeeded), "BNSG::mint: burn BNSD failed");\n', '        _mint(msg.sender, amountToMint);\n', '        _moveDelegates(delegates[address(0)], delegates[msg.sender], amountToMint);\n', '        return true;\n', '    }\n', '\n', '\n', '    function _mint(address account, uint96 amount) internal virtual {\n', '        require(account != address(0), "BNSG: mint to the zero address");\n', '        totalSupply =  add96(totalSupply, amount, "BNSG: mint amount overflow");\n', '        require(totalSupply <= maxTotalSupply, "BNSG: crosses total supply possible");\n', '        balances[account] = add96(balances[account], amount, "BNSG::_mint: transfer amount overflows");\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`\n', '     * @param account The address of the account holding the funds\n', '     * @param spender The address of the account spending the funds\n', '     * @return The number of tokens approved\n', '     */\n', '    function allowance(address account, address spender) external view returns (uint) {\n', '        return allowances[account][spender];\n', '    }\n', '\n', '    /**\n', '     * @notice Approve `spender` to transfer up to `amount` from `src`\n', '     * @dev This will overwrite the approval amount for `spender`\n', '     *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)\n', '     * @param spender The address of the account which may transfer tokens\n', '     * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)\n', '     * @return Whether or not the approval succeeded\n', '     */\n', '    function approve(address spender, uint rawAmount) external returns (bool) {\n', '        uint96 amount;\n', '        if (rawAmount == uint(-1)) {\n', '            amount = uint96(-1);\n', '        } else {\n', '            amount = safe96(rawAmount, "BNSG::approve: amount exceeds 96 bits");\n', '        }\n', '\n', '        allowances[msg.sender][spender] = amount;\n', '\n', '        emit Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Get the number of tokens held by the `account`\n', '     * @param account The address of the account to get the balance of\n', '     * @return The number of tokens held\n', '     */\n', '    function balanceOf(address account) external view returns (uint) {\n', '        return balances[account];\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `msg.sender` to `dst`\n', '     * @param dst The address of the destination account\n', '     * @param rawAmount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transfer(address dst, uint rawAmount) external returns (bool) {\n', '        uint96 amount = safe96(rawAmount, "BNSG::transfer: amount exceeds 96 bits");\n', '        _transferTokens(msg.sender, dst, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `src` to `dst`\n', '     * @param src The address of the source account\n', '     * @param dst The address of the destination account\n', '     * @param rawAmount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {\n', '        address spender = msg.sender;\n', '        uint96 spenderAllowance = allowances[src][spender];\n', '        uint96 amount = safe96(rawAmount, "BNSG::approve: amount exceeds 96 bits");\n', '\n', '        if (spender != src && spenderAllowance != uint96(-1)) {\n', '            uint96 newAllowance = sub96(spenderAllowance, amount, "BNSG::transferFrom: transfer amount exceeds spender allowance");\n', '            allowances[src][spender] = newAllowance;\n', '\n', '            emit Approval(src, spender, newAllowance);\n', '        }\n', '\n', '        _transferTokens(src, dst, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Delegate votes from `msg.sender` to `delegatee`\n', '     * @param delegatee The address to delegate votes to\n', '     */\n', '    function delegate(address delegatee) public {\n', '        return _delegate(msg.sender, delegatee);\n', '    }\n', '\n', '    /**\n', '     * @notice Delegates votes from signatory to `delegatee`\n', '     * @param delegatee The address to delegate votes to\n', '     * @param nonce The contract state required to match the signature\n', '     * @param expiry The time at which to expire the signature\n', '     * @param v The recovery byte of the signature\n', '     * @param r Half of the ECDSA signature pair\n', '     * @param s Half of the ECDSA signature pair\n', '     */\n', '    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "BNSG::delegateBySig: invalid signature");\n', '        require(nonce == nonces[signatory]++, "BNSG::delegateBySig: invalid nonce");\n', '        require(now <= expiry, "BNSG::delegateBySig: signature expired");\n', '        return _delegate(signatory, delegatee);\n', '    }\n', '\n', '    /**\n', '     * @notice Gets the current votes balance for `account`\n', '     * @param account The address to get votes balance\n', '     * @return The number of current votes for `account`\n', '     */\n', '    function getCurrentVotes(address account) external view returns (uint96) {\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;\n', '    }\n', '\n', '    /**\n', '     * @notice Determine the prior number of votes for an account as of a block number\n', '     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.\n', '     * @param account The address of the account to check\n', '     * @param blockNumber The block number to get the vote balance at\n', '     * @return The number of votes the account had as of the given block\n', '     */\n', '    function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {\n', '        require(blockNumber < block.number, "BNSG::getPriorVotes: not yet determined");\n', '\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        if (nCheckpoints == 0) {\n', '            return 0;\n', '        }\n', '\n', '        // First check most recent balance\n', '        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {\n', '            return checkpoints[account][nCheckpoints - 1].votes;\n', '        }\n', '\n', '        // Next check implicit zero balance\n', '        if (checkpoints[account][0].fromBlock > blockNumber) {\n', '            return 0;\n', '        }\n', '\n', '        uint32 lower = 0;\n', '        uint32 upper = nCheckpoints - 1;\n', '        while (upper > lower) {\n', '            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow\n', '            Checkpoint memory cp = checkpoints[account][center];\n', '            if (cp.fromBlock == blockNumber) {\n', '                return cp.votes;\n', '            } else if (cp.fromBlock < blockNumber) {\n', '                lower = center;\n', '            } else {\n', '                upper = center - 1;\n', '            }\n', '        }\n', '        return checkpoints[account][lower].votes;\n', '    }\n', '\n', '    function _delegate(address delegator, address delegatee) internal {\n', '        address currentDelegate = delegates[delegator];\n', '        uint96 delegatorBalance = balances[delegator];\n', '        delegates[delegator] = delegatee;\n', '\n', '        emit DelegateChanged(delegator, currentDelegate, delegatee);\n', '\n', '        _moveDelegates(currentDelegate, delegatee, delegatorBalance);\n', '    }\n', '\n', '    function _transferTokens(address src, address dst, uint96 amount) internal {\n', '        require(src != address(0), "BNSG::_transferTokens: cannot transfer from the zero address");\n', '        require(dst != address(0), "BNSG::_transferTokens: cannot transfer to the zero address");\n', '\n', '        balances[src] = sub96(balances[src], amount, "BNSG::_transferTokens: transfer amount exceeds balance");\n', '        balances[dst] = add96(balances[dst], amount, "BNSG::_transferTokens: transfer amount overflows");\n', '        emit Transfer(src, dst, amount);\n', '\n', '        _moveDelegates(delegates[src], delegates[dst], amount);\n', '    }\n', '\n', '    function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {\n', '        if (srcRep != dstRep && amount > 0) {\n', '            if (srcRep != address(0)) {\n', '                uint32 srcRepNum = numCheckpoints[srcRep];\n', '                uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;\n', '                uint96 srcRepNew = sub96(srcRepOld, amount, "BNSG::_moveVotes: vote amount underflows");\n', '                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);\n', '            }\n', '\n', '            if (dstRep != address(0)) {\n', '                uint32 dstRepNum = numCheckpoints[dstRep];\n', '                uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;\n', '                uint96 dstRepNew = add96(dstRepOld, amount, "BNSG::_moveVotes: vote amount overflows");\n', '                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {\n', '      uint32 blockNumber = safe32(block.number, "BNSG::_writeCheckpoint: block number exceeds 32 bits");\n', '\n', '      if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {\n', '          checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;\n', '      } else {\n', '          checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);\n', '          numCheckpoints[delegatee] = nCheckpoints + 1;\n', '      }\n', '\n', '      emit DelegateVotesChanged(delegatee, oldVotes, newVotes);\n', '    }\n', '\n', '    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {\n', '        require(n < 2**32, errorMessage);\n', '        return uint32(n);\n', '    }\n', '\n', '    function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {\n', '        require(n < 2**96, errorMessage);\n', '        return uint96(n);\n', '    }\n', '\n', '    function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {\n', '        uint96 c = a + b;\n', '        require(c >= a, errorMessage);\n', '        return c;\n', '    }\n', '\n', '    function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    function div96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {\n', '        require(b != 0, errorMessage);\n', '        uint96 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mul96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint96 c = a * b;\n', '        require(c / a == b, errorMessage);\n', '        return c;\n', '    }\n', '\n', '    function getChainId() internal pure returns (uint) {\n', '        uint256 chainId;\n', '        assembly { chainId := chainid() }\n', '        return chainId;\n', '    }\n', '}']
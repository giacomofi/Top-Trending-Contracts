['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-07\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', '// @title Meowshi (MEOW) 🐈 🍣 🍱\n', '// @author Gatoshi Nyakamoto\n', '\n', 'pragma solidity 0.8.4;\n', '\n', '/// @notice Interface for depositing into & withdrawing from BentoBox vault.\n', 'interface IERC20{} interface IBentoBoxBasic {\n', '    function deposit( \n', '        IERC20 token_,\n', '        address from,\n', '        address to,\n', '        uint256 amount,\n', '        uint256 share\n', '    ) external payable returns (uint256 amountOut, uint256 shareOut);\n', '\n', '    function withdraw(\n', '        IERC20 token_,\n', '        address from,\n', '        address to,\n', '        uint256 amount,\n', '        uint256 share\n', '    ) external returns (uint256 amountOut, uint256 shareOut);\n', '}\n', '\n', '/// @notice Interface for depositing into & withdrawing from SushiBar.\n', 'interface ISushiBar { \n', '    function balanceOf(address account) external view returns (uint256);\n', '    function enter(uint256 amount) external;\n', '    function leave(uint256 share) external;\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '}\n', '\n', '/// @notice Meowshi takes SUSHI/xSUSHI to mint governing MEOW tokens that can be burned to claim SUSHI/xSUSHI from BENTO with yields.\n', '//  ៱˳_˳៱   ∫\n', 'contract Meowshi {\n', '    IBentoBoxBasic constant bento = IBentoBoxBasic(0xF5BCE5077908a1b7370B9ae04AdC565EBd643966); // BENTO vault contract (multinet)\n', '    ISushiBar constant sushiToken = ISushiBar(0x6B3595068778DD592e39A122f4f5a5cF09C90fE2); // SUSHI token contract (mainnet)\n', '    address constant sushiBar = 0x8798249c2E607446EfB7Ad49eC89dD1865Ff4272; // xSUSHI token contract for staking SUSHI (mainnet)\n', '    string constant public name = "Meowshi";\n', '    string constant public symbol = "MEOW";\n', '    uint8 constant public decimals = 18;\n', '    uint256 constant multiplier = 100_000; // 1 xSUSHI BENTO share = 100,000 MEOW\n', '    uint256 public totalSupply;\n', '    \n', '    /// @notice owner -> spender -> allowance mapping.\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '    /// @notice owner -> balance mapping.\n', '    mapping(address => uint256) public balanceOf;\n', '    /// @notice owner -> nonce mapping used in {permit}.\n', '    mapping(address => uint256) public nonces;\n', "    /// @notice A record of each account's delegate.\n", '    mapping(address => address) public delegates;\n', '    /// @notice A record of voting checkpoints for each account, by index.\n', '    mapping(address => mapping(uint256 => Checkpoint)) public checkpoints;\n', '    /// @notice The number of checkpoints for each account.\n', '    mapping(address => uint256) public numCheckpoints;\n', "    /// @notice The ERC-712 typehash for this contract's domain.\n", '    bytes32 constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");\n', '    /// @notice The ERC-712 typehash for the delegation struct used by the contract.\n', '    bytes32 constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");\n', '    /// @notice The ERC-712 typehash for the {permit} struct used by the contract.\n', '    bytes32 constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");\n', '    /// @notice Events that are emitted when an ERC-20 approval or transfer occurs. \n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', "    /// @notice An event that's emitted when an account changes its delegate.\n", '    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);\n', "    /// @notice An event that's emitted when a delegate account's vote balance changes.\n", '    event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);\n', '    \n', '    /// @notice A checkpoint for marking number of votes from a given block.\n', '    struct Checkpoint {\n', '        uint256 fromBlock;\n', '        uint256 votes;\n', '    }\n', '    \n', '    constructor() {\n', '        sushiToken.approve(sushiBar, type(uint256).max); // max {approve} xSUSHI to draw SUSHI from this contract\n', '        ISushiBar(sushiBar).approve(address(bento), type(uint256).max); // max {approve} BENTO to draw xSUSHI from this contract\n', '    }\n', '    \n', '    /// @notice Enables calling multiple methods in a single call to this contract.\n', '    function multicall(bytes[] calldata data) external returns (bytes[] memory results) {\n', '        results = new bytes[](data.length);\n', '        unchecked {for (uint256 i = 0; i < data.length; i++) {\n', '            (bool success, bytes memory result) = address(this).delegatecall(data[i]);\n', '            if (!success) {\n', '                if (result.length < 68) revert();\n', '                assembly {result := add(result, 0x04)}\n', '                revert(abi.decode(result, (string)));\n', '            }\n', '            results[i] = result;}}\n', '    }\n', '    \n', '    /*************\n', '    MEOW FUNCTIONS\n', '    *************/\n', '    // **** xSUSHI\n', '    /// @notice Enter Meowshi. Deposit xSUSHI `amount`. Mint MEOW for `to`.\n', '    function meow(address to, uint256 amount) external returns (uint256 shares) {\n', '        ISushiBar(sushiBar).transferFrom(msg.sender, address(bento), amount); // forward to BENTO for skim\n', '        (, shares) = bento.deposit(IERC20(sushiBar), address(bento), address(this), amount, 0);\n', '        meowMint(to, shares * multiplier);\n', '    }\n', '\n', '    /// @notice Leave Meowshi. Burn MEOW `amount`. Claim xSUSHI for `to`.\n', '    function unmeow(address to, uint256 amount) external returns (uint256 amountOut) {\n', '        meowBurn(amount);\n', '        unchecked {(amountOut, ) = bento.withdraw(IERC20(sushiBar), address(this), to, 0, amount / multiplier);}\n', '    }\n', '    \n', '    // **** SUSHI\n', '    /// @notice Enter Meowshi. Deposit SUSHI `amount`. Mint MEOW for `to`.\n', '    function meowSushi(address to, uint256 amount) external returns (uint256 shares) {\n', '        sushiToken.transferFrom(msg.sender, address(this), amount);\n', '        ISushiBar(sushiBar).enter(amount);\n', '        (, shares) = bento.deposit(IERC20(sushiBar), address(this), address(this), balanceOfOptimized(sushiBar), 0);\n', '        meowMint(to, shares * multiplier);\n', '    }\n', '\n', '    /// @notice Leave Meowshi. Burn MEOW `amount`. Claim SUSHI for `to`.\n', '    function unmeowSushi(address to, uint256 amount) external returns (uint256 amountOut) {\n', '        meowBurn(amount);\n', '        unchecked {(amountOut, ) = bento.withdraw(IERC20(sushiBar), address(this), address(this), 0, amount / multiplier);}\n', '        ISushiBar(sushiBar).leave(amountOut);\n', '        sushiToken.transfer(to, balanceOfOptimized(address(sushiToken))); \n', '    }\n', '\n', '    // **** SUPPLY MGMT\n', '    /// @notice Internal mint function for *meow*.\n', '    function meowMint(address to, uint256 amount) private {\n', '        balanceOf[to] += amount;\n', '        totalSupply += amount;\n', '        _moveDelegates(address(0), delegates[to], amount);\n', '        emit Transfer(address(0), to, amount);\n', '    }\n', '    \n', '    /// @notice Internal burn function for *unmeow*.\n', '    function meowBurn(uint256 amount) private {\n', '        balanceOf[msg.sender] -= amount;\n', '        unchecked {totalSupply -= amount;}\n', '        _moveDelegates(delegates[msg.sender], address(0), amount);\n', '        emit Transfer(msg.sender, address(0), amount);\n', '    }\n', '    \n', '    /**************\n', '    TOKEN FUNCTIONS\n', '    **************/\n', '    /// @notice Approves `amount` from msg.sender to be spent by `spender`.\n', "    /// @param spender Address of the party that can draw tokens from msg.sender's account.\n", '    /// @param amount The maximum collective `amount` that `spender` can draw.\n', "    /// @return (bool) Returns 'true' if succeeded.\n", '    function approve(address spender, uint256 amount) external returns (bool) {\n', '        allowance[msg.sender][spender] = amount;\n', '        emit Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Triggers an approval from owner to spends.\n', '    /// @param owner The address to approve from.\n', '    /// @param spender The address to be approved.\n', '    /// @param amount The number of tokens that are approved (2^256-1 means infinite).\n', '    /// @param deadline The time at which to expire the signature.\n', '    /// @param v The recovery byte of the signature.\n', '    /// @param r Half of the ECDSA signature pair.\n', '    /// @param s Half of the ECDSA signature pair.\n', '    function permit(address owner, address spender, uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));\n', '        unchecked {bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '        address signatory = ecrecover(digest, v, r, s); \n', "        require(signatory != address(0), 'Meowshi::permit: invalid signature');\n", "        require(signatory == owner, 'Meowshi::permit: unauthorized');}\n", "        require(block.timestamp <= deadline, 'Meowshi::permit: signature expired');\n", '        allowance[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '    \n', '    /// @notice Transfers `amount` tokens from `msg.sender` to `to`.\n', '    /// @param to The address to move tokens `to`.\n', '    /// @param amount The token `amount` to move.\n', "    /// @return (bool) Returns 'true' if succeeded.\n", '    function transfer(address to, uint256 amount) external returns (bool) {\n', '        balanceOf[msg.sender] -= amount; \n', '        unchecked {balanceOf[to] += amount;}\n', '        _moveDelegates(delegates[msg.sender], delegates[to], amount);\n', '        emit Transfer(msg.sender, to, amount);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Transfers `amount` tokens from `from` to `to`. Caller needs approval from `from`.\n', '    /// @param from Address to draw tokens `from`.\n', '    /// @param to The address to move tokens `to`.\n', '    /// @param amount The token `amount` to move.\n', "    /// @return (bool) Returns 'true' if succeeded.\n", '    function transferFrom(address from, address to, uint256 amount) external returns (bool) {\n', '        if (allowance[from][msg.sender] != type(uint256).max) {allowance[from][msg.sender] -= amount;}\n', '        balanceOf[from] -= amount;\n', '        unchecked {balanceOf[to] += amount;}\n', '        _moveDelegates(delegates[from], delegates[to], amount);\n', '        emit Transfer(from, to, amount);\n', '        return true;\n', '    }\n', '    \n', '    /*******************\n', '    DELEGATION FUNCTIONS\n', '    *******************/\n', '    /// @notice Delegate votes from `msg.sender` to `delegatee`.\n', '    /// @param delegatee The address to delegate votes to.\n', '    function delegate(address delegatee) external {\n', '        return _delegate(msg.sender, delegatee);\n', '    }\n', '\n', '    /// @notice Delegates votes from signatory to `delegatee`.\n', '    /// @param delegatee The address to delegate votes to.\n', '    /// @param nonce The contract state required to match the signature.\n', '    /// @param expiry The time at which to expire the signature.\n', '    /// @param v The recovery byte of the signature.\n', '    /// @param r Half of the ECDSA signature pair.\n', '    /// @param s Half of the ECDSA signature pair.\n', '    function delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s) external {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '        address signatory = ecrecover(digest, v, r, s);\n', "        require(signatory != address(0), 'Meowshi::delegateBySig: invalid signature');\n", "        unchecked {require(nonce == nonces[signatory]++, 'Meowshi::delegateBySig: invalid nonce');}\n", "        require(block.timestamp <= expiry, 'Meowshi::delegateBySig: signature expired');\n", '        return _delegate(signatory, delegatee);\n', '    }\n', '    \n', '    function _delegate(address delegator, address delegatee) private {\n', '        address currentDelegate = delegates[delegator]; \n', '        delegates[delegator] = delegatee;\n', '        emit DelegateChanged(delegator, currentDelegate, delegatee);\n', '        _moveDelegates(currentDelegate, delegatee, balanceOf[delegator]);\n', '    }\n', '\n', '    function _moveDelegates(address srcRep, address dstRep, uint256 amount) private {\n', '        if (srcRep != dstRep && amount != 0) {\n', '            unchecked {if (srcRep != address(0)) {\n', '                uint256 srcRepNum = numCheckpoints[srcRep];\n', '                uint256 srcRepOld = srcRepNum != 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;\n', '                uint256 srcRepNew = srcRepOld - amount;\n', '                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);\n', '            }\n', '            if (dstRep != address(0)) {\n', '                uint256 dstRepNum = numCheckpoints[dstRep];\n', '                uint256 dstRepOld = dstRepNum != 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;\n', '                uint256 dstRepNew = dstRepOld + amount;\n', '                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);\n', '            }}\n', '        }\n', '    }\n', '    \n', '    function _writeCheckpoint(address delegatee, uint256 nCheckpoints, uint256 oldVotes, uint256 newVotes) private {\n', '        unchecked {if (nCheckpoints != 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == block.number) {\n', '            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;\n', '        } else {\n', '            checkpoints[delegatee][nCheckpoints] = Checkpoint(block.number, newVotes);\n', '            numCheckpoints[delegatee] = nCheckpoints + 1;}}\n', '        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);\n', '    }\n', '    \n', '    /***************\n', '    GETTER FUNCTIONS\n', '    ***************/\n', '    /// @notice This function is gas optimized to avoid a redundant extcodesize check in addition to the returndatasize check.\n', '    function balanceOfOptimized(address token) private view returns (uint256) {\n', '        (bool success, bytes memory data) =\n', '            token.staticcall(abi.encodeWithSelector(ISushiBar.balanceOf.selector, address(this)));\n', '        require(success && data.length >= 32);\n', '        return abi.decode(data, (uint256));\n', '    }\n', '    \n', '    /// @notice Get current chain. \n', '    function getChainId() private view returns (uint256) {\n', '        uint256 chainId;\n', '        assembly {chainId := chainid()}\n', '        return chainId;\n', '    }\n', '\n', '    /// @notice Gets the current votes balance for `account`.\n', '    /// @param account The address to get votes balance.\n', '    /// @return The number of current votes for `account`.\n', '    function getCurrentVotes(address account) external view returns (uint256) {\n', '        unchecked {uint256 nCheckpoints = numCheckpoints[account];\n', '        return nCheckpoints != 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;}\n', '    }\n', '\n', '    /// @notice Determine the prior number of votes for an `account` as of a block number.\n', '    /// @dev Block number must be a finalized block or else this function will revert to prevent misinformation.\n', '    /// @param account The address of the `account` to check.\n', '    /// @param blockNumber The block number to get the vote balance at.\n', '    /// @return The number of votes the `account` had as of the given block.\n', '    function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256) {\n', "        require(blockNumber < block.number, 'Meowshi::getPriorVotes: not yet determined');\n", '        uint256 nCheckpoints = numCheckpoints[account];\n', '        if (nCheckpoints == 0) {return 0;}\n', '        // @dev First check most recent balance.\n', '        unchecked {if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {return checkpoints[account][nCheckpoints - 1].votes;}\n', '        // @dev Next check implicit zero balance.\n', '        if (checkpoints[account][0].fromBlock > blockNumber) {return 0;}\n', '        uint256 lower;\n', '        uint256 upper = nCheckpoints - 1;\n', '        while (upper != lower) {\n', '            uint256 center = upper - (upper - lower) / 2;\n', '            Checkpoint memory cp = checkpoints[account][center];\n', '            if (cp.fromBlock == blockNumber) {\n', '                return cp.votes;\n', '            } else if (cp.fromBlock < blockNumber) {\n', '                lower = center;\n', '            } else {upper = center - 1;}}\n', '        return checkpoints[account][lower].votes;}\n', '    }\n', '}']
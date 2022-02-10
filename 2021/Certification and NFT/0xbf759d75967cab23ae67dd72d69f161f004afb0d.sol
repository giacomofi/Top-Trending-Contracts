['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-21\n', '*/\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', 'interface IERC20 {\n', '    function balanceOf(address owner) external view returns (uint);\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool);\n', '}\n', 'contract Rose {\n', '    using SafeMath for uint;\n', '\n', '    /// @notice EIP-20 token name for this token\n', '    string public constant name = "Rose";\n', '\n', '    /// @notice EIP-20 token symbol for this token\n', '    string public constant symbol = "Ros";\n', '\n', '    /// @notice EIP-20 token decimals for this token\n', '    uint8 public constant decimals = 18;\n', '\n', '    /// @notice Total number of tokens in circulation\n', '    uint public constant totalSupply = 20_000_000e18; // 20 million ros\n', '\n', '    /// @notice Allowance amounts on behalf of others\n', '    mapping(address => mapping(address => uint)) internal allowances;\n', '\n', '    /// @notice Official record of token balances for each account\n', '    mapping(address => uint) internal balances;\n', '\n', '    /// @notice A record of each accounts delegate\n', '    mapping(address => address) public delegates;\n', '\n', '    function setCheckpoint(uint fromBlock64, uint votes192) internal pure returns (uint){\n', '        fromBlock64 |= votes192 << 64;\n', '        return fromBlock64;\n', '    }\n', '\n', '    function getCheckpoint(uint _checkpoint) internal pure returns (uint fromBlock, uint votes){\n', '        fromBlock=uint(uint64(_checkpoint));\n', '        votes=uint(uint192(_checkpoint>>64));\n', '    }\n', '\n', '    function getCheckpoint(address _account,uint _index) external view returns (uint fromBlock, uint votes){\n', '        uint data=checkpoints[_account][_index];\n', '        (fromBlock,votes)=getCheckpoint(data);\n', '    }\n', '\n', '    /// @notice A record of votes checkpoints for each account, by index\n', '    mapping(address => mapping(uint => uint)) public checkpoints;\n', '\n', '    /// @notice The number of checkpoints for each account\n', '    mapping(address => uint) public numCheckpoints;\n', '\n', '    /// @notice An event thats emitted when an account changes its delegate\n', '    event DelegateChanged(address delegator, address fromDelegate, address toDelegate);\n', '\n', "    /// @notice An event thats emitted when a delegate account's vote balance changes\n", '    event DelegateVotesChanged(address delegate, uint previousBalance, uint newBalance);\n', '\n', '    /// @notice The standard EIP-20 transfer event\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '\n', '    /// @notice The standard EIP-20 approval event\n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '\n', '    constructor(address account) public {\n', '        balances[account] = totalSupply;\n', '        emit Transfer(address(0), account, totalSupply);\n', '    }\n', '\n', '    function allowance(address account, address spender) external view returns (uint) {\n', '        return allowances[account][spender];\n', '    }\n', '\n', '    function approve(address spender, uint rawAmount) external returns (bool) {\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '        allowances[msg.sender][spender] = rawAmount;\n', '        emit Approval(msg.sender, spender, rawAmount);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice Get the number of tokens held by the `account`\n', '     * @param account The address of the account to get the balance of\n', '     * @return The number of tokens held\n', '     */\n', '    function balanceOf(address account) external view returns (uint) {\n', '        return balances[account];\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `msg.sender` to `dst`\n', '     * @param dst The address of the destination account\n', '     * @param rawAmount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transfer(address dst, uint rawAmount) external returns (bool) {\n', '        _transferTokens(msg.sender, dst, rawAmount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `src` to `dst`\n', '     * @param src The address of the source account\n', '     * @param dst The address of the destination account\n', '     * @param rawAmount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {\n', '        address spender = msg.sender;\n', '        uint spenderAllowance = allowances[src][spender];\n', '        if (spender != src && spenderAllowance != uint(- 1)) {\n', '            uint newAllowance = spenderAllowance.sub(rawAmount, "Rose::transferFrom: transfer amount exceeds spender allowance");\n', '            allowances[src][spender] = newAllowance;\n', '            emit Approval(src, spender, newAllowance);\n', '        }\n', '        _transferTokens(src, dst, rawAmount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Delegate votes from `msg.sender` to `delegatee`\n', '     * @param delegatee The address to delegate votes to\n', '     */\n', '    function delegate(address delegatee) public {\n', '        return _delegate(msg.sender, delegatee);\n', '    }\n', '\n', '    function _delegate(address delegator, address delegatee) internal {\n', '        address currentDelegate = delegates[delegator];\n', '        uint delegatorBalance = balances[delegator];\n', '        delegates[delegator] = delegatee;\n', '\n', '        emit DelegateChanged(delegator, currentDelegate, delegatee);\n', '\n', '        _moveDelegates(currentDelegate, delegatee, delegatorBalance);\n', '    }\n', '\n', '    /**\n', '     * @notice Gets the current votes balance for `account`\n', '     * @param account The address to get votes balance\n', '     * @return The number of current votes for `account`\n', '     */\n', '    function getCurrentVotes(address account) external view returns (uint) {\n', '        uint nCheckpoints = numCheckpoints[account];\n', '        (,uint votes)=getCheckpoint(checkpoints[account][nCheckpoints - 1]);\n', '        return nCheckpoints > 0 ? votes : 0;\n', '    }\n', '\n', '    /**\n', '     * @notice Determine the prior number of votes for an account as of a block number\n', '     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.\n', '     * @param account The address of the account to check\n', '     * @param blockNumber The block number to get the vote balance at\n', '     * @return The number of votes the account had as of the given block\n', '     */\n', '    function getPriorVotes(address account, uint blockNumber) public view returns (uint) {\n', '        require(blockNumber < block.number, "Rose::getPriorVotes: not yet determined");\n', '        uint nCheckpoints = numCheckpoints[account];\n', '        if (nCheckpoints == 0) {\n', '            return 0;\n', '        }\n', '        (uint dataFromBlock1,uint dataVotes1)=getCheckpoint(checkpoints[account][nCheckpoints - 1]);\n', '        // First check most recent balance\n', '        if (dataFromBlock1 <= blockNumber) {\n', '            return dataVotes1;\n', '        }\n', '        (uint fromBlock0,)=getCheckpoint(checkpoints[account][0]);\n', '        // Next check implicit zero balance\n', '        if (fromBlock0 > blockNumber) {\n', '            return 0;\n', '        }\n', '        uint lower = 0;\n', '        uint upper = nCheckpoints - 1;\n', '        while (upper > lower) {\n', '            uint center = upper - (upper - lower) / 2;\n', '            // ceil, avoiding overflow\n', '            uint cp = checkpoints[account][center];\n', '            (uint cpFromBlock,uint cpVotes)=getCheckpoint(cp);\n', '            if (cpFromBlock == blockNumber) {\n', '                return cpVotes;\n', '            } else if (cpFromBlock < blockNumber) {\n', '                lower = center;\n', '            } else {\n', '                upper = center - 1;\n', '            }\n', '        }\n', '        (,uint reVotes)=getCheckpoint(checkpoints[account][lower]);\n', '        return reVotes;\n', '    }\n', '\n', '\n', '\n', '    function _transferTokens(address src, address dst, uint amount) internal {\n', '        require(src != address(0), "Rose::_transferTokens: cannot transfer from the zero address");\n', '        require(dst != address(0), "Rose::_transferTokens: cannot transfer to the zero address");\n', '\n', '        balances[src] = balances[src].sub(amount, "Rose::_transferTokens: transfer amount exceeds balance");\n', '        balances[dst] = balances[dst].add(amount, "Rose::_transferTokens: transfer amount overflows");\n', '        emit Transfer(src, dst, amount);\n', '\n', '        _moveDelegates(delegates[src], delegates[dst], amount);\n', '    }\n', '\n', '    function _moveDelegates(address srcRep, address dstRep, uint amount) internal {\n', '        if (srcRep != dstRep && amount > 0) {\n', '            if (srcRep != address(0)) {\n', '                uint srcRepNum = numCheckpoints[srcRep];\n', '                (,uint srcVotes)=getCheckpoint(checkpoints[srcRep][srcRepNum - 1]);\n', '                uint srcRepOld = srcRepNum > 0 ? srcVotes : 0;\n', '                uint srcRepNew = srcRepOld.sub(amount, "Rose::_moveVotes: vote amount underflows");\n', '                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);\n', '            }\n', '\n', '            if (dstRep != address(0)) {\n', '                uint dstRepNum = numCheckpoints[dstRep];\n', '                (,uint dstVotes)=getCheckpoint(checkpoints[dstRep][dstRepNum - 1]);\n', '                uint dstRepOld = dstRepNum > 0 ? dstVotes : 0;\n', '                uint dstRepNew = dstRepOld.add(amount, "Rose::_moveVotes: vote amount overflows");\n', '                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _writeCheckpoint(address delegatee, uint256 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {\n', '        uint blockNumber = block.number;\n', '        (uint fromBlock,)=getCheckpoint(checkpoints[delegatee][nCheckpoints - 1]);\n', '        if (nCheckpoints > 0 && fromBlock == blockNumber) {\n', '            checkpoints[delegatee][nCheckpoints - 1] = setCheckpoint(fromBlock,newVotes);\n', '        } else {\n', '            checkpoints[delegatee][nCheckpoints] = setCheckpoint(blockNumber, newVotes);\n', '            numCheckpoints[delegatee] = nCheckpoints + 1;\n', '        }\n', '        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);\n', '    }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, errorMessage);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction underflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, errorMessage);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '}']
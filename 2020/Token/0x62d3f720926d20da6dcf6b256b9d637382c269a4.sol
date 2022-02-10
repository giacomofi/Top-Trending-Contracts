['//SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.6.12;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface IERC20Token is IERC20 {\n', '    function maxSupply() external view returns (uint256);\n', '    function issue(address account, uint256 amount) external returns (bool);\n', '    function burn(uint256 amount) external returns (bool);\n', '}\n', '\n', 'contract ERC20Token is IERC20Token, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) internal _balances;\n', '    mapping(address => mapping(address => uint256)) internal _allowances;\n', '    uint256 internal _totalSupply;\n', '    string internal _name;\n', '    string internal _symbol;\n', '    uint8 internal _decimals;\n', '    uint256 internal _maxSupply;\n', '\n', '    mapping(address => bool) public issuer;\n', '\n', '    modifier onlyIssuer() {\n', '        require(issuer[msg.sender], "The caller does not have issuer role privileges");\n', '        _;\n', '    }\n', '\n', '    constructor (string memory name, string memory sym, uint256 maxSupply) public {\n', '        _name = name;\n', '        _symbol = sym;\n', '        _decimals = 18;\n', '        if (maxSupply == 0) {\n', '            _maxSupply = uint256(- 1);\n', '        } else {\n', '            _maxSupply = maxSupply;\n', '        }\n', '\n', '        issuer[msg.sender] = true;\n', '    }\n', '\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == owner();\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() external view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() external view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() external override view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public override view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function maxSupply() override external view returns (uint256) {\n', '        return _maxSupply;\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) external override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address spender) external override view returns (uint256) {\n', '        return _allowances[_owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 value) external override returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    function issue(address account, uint256 amount) override external onlyIssuer returns (bool) {\n', '        _mint(account, amount);\n', '        return true;\n', '    }\n', '\n', '    // only burn self token\n', '    function burn(uint256 amount) override external returns (bool) {\n', '        _burn(msg.sender, amount);\n', '        return true;\n', '    }\n', '\n', '    function addIssuer(address _addr) public onlyOwner returns (bool){\n', '        require(_addr != address(0), "address invalid");\n', '        if (issuer[_addr] == false) {\n', '            issuer[_addr] = true;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function removeIssuer(address _addr) public onlyOwner returns (bool) {\n', '        require(_addr != address(0), "address invalid");\n', '        if (issuer[_addr] == true) {\n', '            issuer[_addr] = false;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount);\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '        _totalSupply = _totalSupply.add(amount);\n', '        require(_totalSupply <= _maxSupply, "ERC20: supply amount cannot over maxSupply");\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    function _approve(address _owner, address spender, uint256 value) internal {\n', '        require(_owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[_owner][spender] = value;\n', '        emit Approval(_owner, spender, value);\n', '    }\n', '\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burn(account, amount);\n', '        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));\n', '    }\n', '}\n', '\n', 'interface ITokenVotorV1 {\n', '    function delegates(address delegator) external view returns (address);\n', '    function delegate(address delegatee) external;\n', '    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;\n', '    function getCurrentVotes(address account) external view returns (uint256);\n', '    function getPriorVotes(address account, uint blockNumber) external view returns (uint256);\n', '}\n', '\n', 'contract GovernTokenV1 is ERC20Token, ITokenVotorV1 {\n', '\n', '    // A record of each accounts delegates\n', '    mapping(address => address) internal _delegates;\n', '\n', '    // A checkpoint for marking number of votes from a given block\n', '    struct Checkpoint {\n', '        uint32 fromBlock;\n', '        uint256 votes;\n', '    }\n', '\n', '    // A record of votes checkpoints for each account, by index\n', '    mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;\n', '\n', '    // The number of checkpoints for each account\n', '    mapping(address => uint32) public numCheckpoints;\n', '\n', "    // The EIP-712 typehash for the contract's domain\n", '    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");\n', '\n', '    // The EIP-712 typehash for the delegation struct used by the contract\n', '    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");\n', '\n', '    // A record of states for signing / validating signatures\n', '    mapping(address => uint) public nonces;\n', '\n', '    // An event thats emitted when an account changes its delegate\n', '    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);\n', '\n', "    // An event thats emitted when a delegate account's vote balance changes\n", '    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);\n', '\n', '    constructor(string memory name, string memory sym, uint256 maxSupply) ERC20Token(name, sym, maxSupply) public {}\n', '\n', '    /**\n', '     * @notice Delegate votes from `msg.sender` to `delegatee`\n', '     * @param delegator The address to get delegatee for\n', '     */\n', '    function delegates(address delegator)\n', '    override\n', '    external\n', '    view\n', '    returns (address)\n', '    {\n', '        return _delegates[delegator];\n', '    }\n', '\n', '    /**\n', '     * @notice Delegate votes from `msg.sender` to `delegatee`\n', '     * @param delegatee The address to delegate votes to\n', '     */\n', '    function delegate(address delegatee) override external {\n', '        return _delegate(msg.sender, delegatee);\n', '    }\n', '\n', '    /**\n', '     * @notice Delegates votes from signatory to `delegatee`\n', '     * @param delegatee The address to delegate votes to\n', '     * @param nonce The contract state required to match the signature\n', '     * @param expiry The time at which to expire the signature\n', '     * @param v The recovery byte of the signature\n', '     * @param r Half of the ECDSA signature pair\n', '     * @param s Half of the ECDSA signature pair\n', '     */\n', '    function delegateBySig(\n', '        address delegatee,\n', '        uint nonce,\n', '        uint expiry,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    )\n', '    override\n', '    external\n', '    {\n', '        bytes32 domainSeparator = keccak256(\n', '            abi.encode(\n', '                DOMAIN_TYPEHASH,\n', '                keccak256(bytes(name())),\n', '                getChainId(),\n', '                address(this)\n', '            )\n', '        );\n', '\n', '        bytes32 structHash = keccak256(\n', '            abi.encode(\n', '                DELEGATION_TYPEHASH,\n', '                delegatee,\n', '                nonce,\n', '                expiry\n', '            )\n', '        );\n', '\n', '        bytes32 digest = keccak256(\n', '            abi.encodePacked(\n', '                "\\x19\\x01",\n', '                domainSeparator,\n', '                structHash\n', '            )\n', '        );\n', '\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "GovernTokenV1::delegateBySig: invalid signature");\n', '        require(nonce == nonces[signatory]++, "GovernTokenV1::delegateBySig: invalid nonce");\n', '        require(now <= expiry, "GovernTokenV1::delegateBySig: signature expired");\n', '        return _delegate(signatory, delegatee);\n', '    }\n', '\n', '    /**\n', '     * @notice Gets the current votes balance for `account`\n', '     * @param account The address to get votes balance\n', '     * @return The number of current votes for `account`\n', '     */\n', '    function getCurrentVotes(address account)\n', '    override\n', '    external\n', '    view\n', '    returns (uint256)\n', '    {\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;\n', '    }\n', '\n', '    /**\n', '     * @notice Determine the prior number of votes for an account as of a block number\n', '     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.\n', '     * @param account The address of the account to check\n', '     * @param blockNumber The block number to get the vote balance at\n', '     * @return The number of votes the account had as of the given block\n', '     */\n', '    function getPriorVotes(address account, uint blockNumber)\n', '    override\n', '    external\n', '    view\n', '    returns (uint256)\n', '    {\n', '        require(blockNumber < block.number, "GovernTokenV1::getPriorVotes: not yet determined");\n', '\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        if (nCheckpoints == 0) {\n', '            return 0;\n', '        }\n', '\n', '        // First check most recent balance\n', '        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {\n', '            return checkpoints[account][nCheckpoints - 1].votes;\n', '        }\n', '\n', '        // Next check implicit zero balance\n', '        if (checkpoints[account][0].fromBlock > blockNumber) {\n', '            return 0;\n', '        }\n', '\n', '        uint32 lower = 0;\n', '        uint32 upper = nCheckpoints - 1;\n', '        while (upper > lower) {\n', '            uint32 center = upper - (upper - lower) / 2;\n', '            // ceil, avoiding overflow\n', '            Checkpoint memory cp = checkpoints[account][center];\n', '            if (cp.fromBlock == blockNumber) {\n', '                return cp.votes;\n', '            } else if (cp.fromBlock < blockNumber) {\n', '                lower = center;\n', '            } else {\n', '                upper = center - 1;\n', '            }\n', '        }\n', '        return checkpoints[account][lower].votes;\n', '    }\n', '\n', '    function _delegate(address delegator, address delegatee)\n', '    internal\n', '    {\n', '        address currentDelegate = _delegates[delegator];\n', '        uint256 delegatorBalance = balanceOf(delegator);\n', '        // balance of underlying SUSHIs (not scaled);\n', '        _delegates[delegator] = delegatee;\n', '\n', '        emit DelegateChanged(delegator, currentDelegate, delegatee);\n', '\n', '        _moveDelegates(currentDelegate, delegatee, delegatorBalance);\n', '    }\n', '\n', '    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {\n', '        if (srcRep != dstRep && amount > 0) {\n', '            if (srcRep != address(0)) {\n', '                // decrease old representative\n', '                uint32 srcRepNum = numCheckpoints[srcRep];\n', '                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;\n', '                uint256 srcRepNew = srcRepOld.sub(amount);\n', '                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);\n', '            }\n', '\n', '            if (dstRep != address(0)) {\n', '                // increase new representative\n', '                uint32 dstRepNum = numCheckpoints[dstRep];\n', '                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;\n', '                uint256 dstRepNew = dstRepOld.add(amount);\n', '                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _writeCheckpoint(\n', '        address delegatee,\n', '        uint32 nCheckpoints,\n', '        uint256 oldVotes,\n', '        uint256 newVotes\n', '    )\n', '    internal\n', '    {\n', '        uint32 blockNumber = safe32(block.number, "GovernTokenV1::_writeCheckpoint: block number exceeds 32 bits");\n', '\n', '        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {\n', '            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;\n', '        } else {\n', '            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);\n', '            numCheckpoints[delegatee] = nCheckpoints + 1;\n', '        }\n', '\n', '        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);\n', '    }\n', '\n', '    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {\n', '        require(n < 2 ** 32, errorMessage);\n', '        return uint32(n);\n', '    }\n', '\n', '    function getChainId() internal pure returns (uint) {\n', '        uint256 chainId;\n', '        assembly {chainId := chainid()}\n', '        return chainId;\n', '    }\n', '}']
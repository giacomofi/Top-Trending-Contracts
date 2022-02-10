['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'import "./vendors/contracts/access/Ownable.sol";\n', 'import "./vendors/contracts/DelegableToken.sol";\n', 'import "./vendors/interfaces/IDelegableERC20.sol";\n', '\n', 'contract PACT is IDelegableERC20, DelegableToken, Ownable\n', '{\n', '\n', '    using SafeMath for uint256;\n', '\n', '    constructor() ERC20("PACT community token", "PACT", 1000000000e18) public {}\n', '\n', '    function mint(address account, uint amount) external onlyOwner returns (bool) {\n', '        _mint(account, amount);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint amount) external returns (bool) {\n', '        _burn(_msgSender(), amount);\n', '        return true;\n', '    }\n', '\n', '    mapping (address => bool) private _allowedBridges;\n', '    address[] private _bridgesList;\n', '    event BridgeRegistration(address indexed newBridge);\n', '    event BridgeDisable(address indexed newBridge);\n', '    function bridgesList() public view virtual returns (address[] memory) {\n', '        return _bridgesList;\n', '    }\n', '    modifier onlyBridge() {\n', '        require(_allowedBridges[_msgSender()], "PACT: caller is not the bridge");\n', '        _;\n', '    }\n', '    function bridgeRegistration(address newBridge) public virtual onlyOwner {\n', '        require(newBridge != address(0), "PACT: new bridge is the zero address");\n', '        _allowedBridges[newBridge] = true;\n', '        _bridgesList.push(newBridge);\n', '        emit BridgeRegistration(newBridge);\n', '    }\n', '    function bridgeDisable(address oldBridge) public virtual onlyOwner {\n', '        require(_allowedBridges[oldBridge], "PACT: bridge is disabled");\n', '        emit BridgeRegistration(oldBridge);\n', '        _allowedBridges[oldBridge] = false;\n', '    }\n', '    function mintByBridge(address account, uint amount) external onlyBridge returns (bool) {\n', '        _mint(account, amount);\n', '        return true;\n', '    }\n', '    function burnByBridge(address account, uint amount) external onlyBridge returns (bool) {\n', '        _burn(account, amount);\n', '        return true;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'import "./ERC20.sol";\n', 'import "../interfaces/IDelegable.sol";\n', '\n', 'import "../libraries/SafeMath32.sol";\n', 'import "../libraries/SafeMath.sol";\n', '\n', '// Copied and modified from Compound code:\n', '// https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/DelegableToken.sol\n', 'abstract contract DelegableToken is IDelegable, ERC20{\n', '    using SafeMath for uint256;\n', '    using SafeMath32 for uint32;\n', '\n', '    /// @notice A record of each accounts delegate\n', '    mapping (address => address) public _delegates;\n', '\n', '    /// @notice A checkpoint for marking number of votes from a given block\n', '    struct Checkpoint {\n', '        uint32 fromBlock;\n', '        uint256 votes;\n', '    }\n', '\n', '    /// @notice A record of votes checkpoints for each account, by index\n', '    mapping (address => mapping (uint32 => Checkpoint)) public _checkpoints;\n', '\n', '    /// @notice The number of checkpoints for each account\n', '    mapping (address => uint32) public _numCheckpoints;\n', '\n', "    /// @notice The EIP-712 typehash for the contract's domain\n", '    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");\n', '\n', '    /// @notice The EIP-712 typehash for the delegation struct used by the contract\n', '    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");\n', '\n', '    /// @notice A record of states for signing / validating signatures\n', '    mapping (address => uint) public _nonces;\n', '\n', '    function delegate(address delegatee) public override {\n', '        return _delegate(_msgSender(), delegatee);\n', '    }\n', '\n', '    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public override {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(_name)), getChainId(), address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "DelegableToken::delegateBySig: invalid signature");\n', '        require(nonce == _nonces[signatory]++, "DelegableToken::delegateBySig: invalid nonce");\n', '        require(block.timestamp <= expiry, "DelegableToken::delegateBySig: signature expired");\n', '        return _delegate(signatory, delegatee);\n', '    }\n', '\n', '    function getCurrentVotes(address account) external override view returns (uint256) {\n', '        uint32 nCheckpoints = _numCheckpoints[account];\n', '        return nCheckpoints > 0 ? _checkpoints[account][nCheckpoints - 1].votes : 0;\n', '    }\n', '\n', '    function getPriorVotes(address account, uint blockNumber) public override view returns (uint256) {\n', '        require(blockNumber <= block.number, "DelegableToken::getPriorVotes: not yet determined");\n', '\n', '        uint32 nCheckpoints = _numCheckpoints[account];\n', '        if (nCheckpoints == 0) {\n', '            return 0;\n', '        }\n', '\n', '        // First check most recent balance\n', '        if (_checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {\n', '            return _checkpoints[account][nCheckpoints - 1].votes;\n', '        }\n', '\n', '        // Next check implicit zero balance\n', '        if (_checkpoints[account][0].fromBlock > blockNumber) {\n', '            return 0;\n', '        }\n', '\n', '        uint32 lower = 0;\n', '        uint32 upper = nCheckpoints - 1;\n', '        while (upper > lower) {\n', '            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow\n', '            Checkpoint memory cp = _checkpoints[account][center];\n', '            if (cp.fromBlock == blockNumber) {\n', '                return cp.votes;\n', '            } else if (cp.fromBlock < blockNumber) {\n', '                lower = center;\n', '            } else {\n', '                upper = center - 1;\n', '            }\n', '        }\n', '        return _checkpoints[account][lower].votes;\n', '    }\n', '\n', '    function _delegate(address delegator, address delegatee) internal {\n', '        address currentDelegate = _delegates[delegator];\n', '        uint256 delegatorBalance = _balances[delegator];\n', '        _delegates[delegator] = delegatee;\n', '\n', '        emit DelegateChanged(delegator, currentDelegate, delegatee);\n', '\n', '        _moveDelegates(currentDelegate, delegatee, delegatorBalance);\n', '    }\n', '\n', '    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual override {\n', '        super._afterTokenTransfer(from, to, amount);\n', '\n', '        _moveDelegates(_delegates[from], _delegates[to], amount);\n', '    }\n', '\n', '    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {\n', '        if (srcRep != dstRep && amount > 0) {\n', '            if (srcRep != address(0)) {\n', '                uint32 srcRepNum = _numCheckpoints[srcRep];\n', '                uint256 srcRepOld = srcRepNum > 0 ? _checkpoints[srcRep][srcRepNum - 1].votes : 0;\n', '                uint256 srcRepNew = srcRepOld.sub(amount, "DelegableToken::_moveVotes: vote amount - underflows");\n', '                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);\n', '            }\n', '\n', '            if (dstRep != address(0)) {\n', '                uint32 dstRepNum = _numCheckpoints[dstRep];\n', '                uint256 dstRepOld = dstRepNum > 0 ? _checkpoints[dstRep][dstRepNum - 1].votes : 0;\n', '                uint256 dstRepNew = dstRepOld.add(amount, "DelegableToken::_moveVotes: vote amount - overflows");\n', '                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {\n', '        uint32 blockNumber = SafeMath32.safe32(block.number, "DelegableToken::_writeCheckpoint: block number - exceeds 32 bits");\n', '\n', '        if (nCheckpoints > 0 && _checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {\n', '            _checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;\n', '        } else {\n', '            _checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);\n', '            _numCheckpoints[delegatee] = nCheckpoints + 1;\n', '        }\n', '\n', '        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);\n', '    }\n', '\n', '    function getChainId() internal pure returns (uint) {\n', '        uint256 chainId;\n', '        assembly { chainId := chainid() }\n', '        return chainId;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'import "../interfaces/IERC20WithMaxTotalSupply.sol";\n', 'import "./utils/Context.sol";\n', '\n', 'import "../libraries/SafeMath.sol";\n', '\n', '\n', '// Copied and modified from OpenZeppelin code:\n', '// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol\n', 'contract ERC20 is Context, IERC20WithMaxTotalSupply {\n', '    using SafeMath for uint256;\n', '\n', '    string _name;\n', '    string _symbol;\n', '    uint256 _totalSupply;\n', '    uint256 _maxTotalSupply;\n', '\n', '    mapping(address => uint256) _balances;\n', '    mapping(address => mapping(address => uint256)) _allowances;\n', '\n', '    constructor(string memory name_, string memory symbol_, uint maxTotalSupply_) public {\n', '        _name = name_;\n', '        _symbol = symbol_;\n', '        _maxTotalSupply = maxTotalSupply_;\n', '    }\n', '\n', '    function name() public view virtual override returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view virtual override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view virtual override returns (uint8) {\n', '        return 18;\n', '    }\n', '\n', '    function totalSupply() public view virtual override returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function maxTotalSupply() public view virtual override returns (uint) {\n', '        return _maxTotalSupply;\n', '    }\n', '\n', '\n', '    function balanceOf(address account) public view virtual override returns (uint) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint amount) public override virtual returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view virtual override returns (uint) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint amount) public virtual override returns (bool) {\n', '        address spender = _msgSender();\n', '        if (spender != sender) {\n', '            uint256 newAllowance = _allowances[sender][spender].sub(amount, "ERC20ForUint256::transferFrom: amount - exceeds spender allowance");\n', '            _approve(sender, spender, newAllowance);\n', '        }\n', '\n', '        _transfer(sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20ForUint256::transfer: from -  the zero address");\n', '        require(recipient != address(0), "ERC20ForUint256::transfer: to -  the zero address");\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20ForUint256::_transfer: amount - exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount, "ERC20ForUint256::_transfer - Add Overflow");\n', '\n', '        emit Transfer(sender, recipient, amount);\n', '        _afterTokenTransfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20ForUint256::_mint: account - the zero address");\n', '\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '\n', '        _balances[account] = _balances[account].add(amount, "ERC20ForUint256::_mint: amount - exceeds balance");\n', '        _totalSupply = _totalSupply.add(amount, "ERC20ForUint256::_mint: totalSupply - exceeds amount");\n', '        require(_totalSupply <= _maxTotalSupply, "ERC20ForUint256::_mint: maxTotalSupply limit");\n', '\n', '        emit Transfer(address(0), account, amount);\n', '        _afterTokenTransfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20ForUint256::_burn: account - the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20ForUint256::_burn: amount - exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount, "ERC20ForUint256::_burn: totalSupply - exceeds amount");\n', '\n', '        emit Transfer(account, address(0), amount);\n', '        _afterTokenTransfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20ForUint256::_approve: owner - the zero address");\n', '        require(spender != address(0), "ERC20ForUint256::_approve: spender - the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}\n', '    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'import "../utils/Context.sol";\n', '\n', '// Copied from OpenZeppelin code:\n', '// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor() public {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', '// Copied from OpenZeppelin code:\n', '// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IDelegable {\n', '    function delegate(address delegatee) external;\n', '    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;\n', '    function getCurrentVotes(address account) external view returns (uint256);\n', '    function getPriorVotes(address account, uint blockNumber) external view returns (uint256);\n', '\n', '    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);\n', '    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'import "./IDelegable.sol";\n', 'import "./IERC20WithMaxTotalSupply.sol";\n', '\n', 'interface IDelegableERC20 is IDelegable, IERC20WithMaxTotalSupply {}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IERC20 {\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '\n', '    function balanceOf(address tokenOwner) external view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) external view returns (uint remaining);\n', '    function approve(address spender, uint tokens) external returns (bool success);\n', '    function transfer(address to, uint tokens) external returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) external returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'import "./IERC20.sol";\n', '\n', 'interface IERC20WithMaxTotalSupply is IERC20 {\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Mint(address indexed account, uint tokens);\n', '    event Burn(address indexed account, uint tokens);\n', '    function maxTotalSupply() external view returns (uint);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return add(a, b, "SafeMath: Add Overflow");\n', '    }\n', '    function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, errorMessage);// "SafeMath: Add Overflow"\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: Underflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;// "SafeMath: Underflow"\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mul(a, b, "SafeMath: Mul Overflow");\n', '    }\n', '    function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, errorMessage);// "SafeMath: Mul Overflow"\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'library SafeMath32 {\n', '    function safe32(uint a, string memory errorMessage) internal pure returns (uint32 c) {\n', '        require(a <= 2**32, errorMessage);// "SafeMath: exceeds 32 bits"\n', '        c = uint32(a);\n', '    }\n', '}\n', '\n', '{\n', '  "remappings": [],\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']
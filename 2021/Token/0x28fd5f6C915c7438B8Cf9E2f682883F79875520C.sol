['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-10\n', '*/\n', '\n', 'pragma solidity =0.8.0;\n', '\n', '// ----------------------------------------------------------------------------\n', '// GNBU token main contract (2021)\n', '//\n', '// Symbol       : GNBU\n', '// Name         : Nimbus Governance Token\n', '// Total supply : 100.000.000 (burnable)\n', '// Decimals     : 18\n', '// ----------------------------------------------------------------------------\n', '// SPDX-License-Identifier: MIT\n', '// ----------------------------------------------------------------------------\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address tokenOwner) external view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) external view returns (uint remaining);\n', '    function transfer(address to, uint tokens) external returns (bool success);\n', '    function approve(address spender, uint tokens) external returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) external returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed from, address indexed to);\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), owner);\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "Ownable: Caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address transferOwner) public onlyOwner {\n', '        require(transferOwner != newOwner);\n', '        newOwner = transferOwner;\n', '    }\n', '\n', '    function acceptOwnership() virtual public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', 'contract GNBU is Ownable, Pausable {\n', '    string public constant name = "Nimbus Governance Token";\n', '    string public constant symbol = "GNBU";\n', '    uint8 public constant decimals = 18;\n', '    uint96 public totalSupply = 100_000_000e18; // 100 million GNBU\n', '    mapping (address => mapping (address => uint96)) internal allowances;\n', '\n', '    mapping (address => uint96) private _unfrozenBalances;\n', '    mapping (address => uint32) private _vestingNonces;\n', '    mapping (address => mapping (uint32 => uint96)) private _vestingAmounts;\n', '    mapping (address => mapping (uint32 => uint96)) private _unvestedAmounts;\n', '    mapping (address => mapping (uint32 => uint)) private _vestingReleaseStartDates;\n', '    mapping (address => bool) public vesters;\n', '\n', '    uint96 private vestingFirstPeriod = 60 days;\n', '    uint96 private vestingSecondPeriod = 152 days;\n', '\n', '    address[] public supportUnits;\n', '    uint public supportUnitsCnt;\n', '\n', '    mapping (address => address) public delegates;\n', '    struct Checkpoint {\n', '        uint32 fromBlock;\n', '        uint96 votes;\n', '    }\n', '    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;\n', '    mapping (address => uint32) public numCheckpoints;\n', '\n', '    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");\n', '    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");\n', '    bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");\n', '    mapping (address => uint) public nonces;\n', '    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);\n', '    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '    event Unvest(address user, uint amount);\n', '\n', '    constructor() {\n', '        _unfrozenBalances[owner] = uint96(totalSupply);\n', '        emit Transfer(address(0), owner, totalSupply);\n', '    }\n', '\n', '    function freeCirculation() external view returns (uint) {\n', '        uint96 systemAmount = _unfrozenBalances[owner];\n', '        for (uint i; i < supportUnits.length; i++) {\n', '            systemAmount = add96(systemAmount, _unfrozenBalances[supportUnits[i]], "GNBU::freeCirculation: adding overflow");\n', '        }\n', '        return sub96(totalSupply, systemAmount, "GNBU::freeCirculation: amount exceed totalSupply");\n', '    }\n', '    \n', '    function allowance(address account, address spender) external view returns (uint) {\n', '        return allowances[account][spender];\n', '    }\n', '\n', '    function approve(address spender, uint rawAmount) external whenNotPaused returns (bool) {\n', '        uint96 amount;\n', '        if (rawAmount == uint(2 ** 256 - 1)) {\n', '            amount = uint96(2 ** 96 - 1);\n', '        } else {\n', '            amount = safe96(rawAmount, "GNBU::approve: amount exceeds 96 bits");\n', '        }\n', '\n', '        allowances[msg.sender][spender] = amount;\n', '\n', '        emit Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '    \n', '    function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external whenNotPaused {\n', '        uint96 amount;\n', '        if (rawAmount == uint(2 ** 256 - 1)) {\n', '            amount = uint96(2 ** 96 - 1);\n', '        } else {\n', '            amount = safe96(rawAmount, "GNBU::permit: amount exceeds 96 bits");\n', '        }\n', '\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "GNBU::permit: invalid signature");\n', '        require(signatory == owner, "GNBU::permit: unauthorized");\n', '        require(block.timestamp <= deadline, "GNBU::permit: signature expired");\n', '\n', '        allowances[owner][spender] = amount;\n', '\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '       \n', '    function balanceOf(address account) public view returns (uint) {\n', '        uint96 amount = _unfrozenBalances[account];\n', '        if (_vestingNonces[account] == 0) return amount;\n', '        for (uint32 i = 1; i <= _vestingNonces[account]; i++) {\n', '            uint96 unvested = sub96(_vestingAmounts[account][i], _unvestedAmounts[account][i], "GNBU::balanceOf: unvested exceed vested amount");\n', '            amount = add96(amount, unvested, "GNBU::balanceOf: overflow");\n', '        }\n', '        return amount;\n', '    }\n', '\n', '    function availableForUnvesting(address user) external view returns (uint unvestAmount) {\n', '        if (_vestingNonces[user] == 0) return 0;\n', '        for (uint32 i = 1; i <= _vestingNonces[user]; i++) {\n', '            if (_vestingAmounts[user][i] == _unvestedAmounts[user][i]) continue;\n', '            if (_vestingReleaseStartDates[user][i] > block.timestamp) break;\n', '            uint toUnvest = mul96((block.timestamp - _vestingReleaseStartDates[user][i]), (_vestingAmounts[user][i])) / vestingSecondPeriod;\n', '            if (toUnvest > _vestingAmounts[user][i]) {\n', '                toUnvest = _vestingAmounts[user][i];\n', '            } \n', '            toUnvest -= _unvestedAmounts[user][i];\n', '            unvestAmount += toUnvest;\n', '        }\n', '    }\n', '\n', '    function availableForTransfer(address account) external view returns (uint) {\n', '        return _unfrozenBalances[account];\n', '    }\n', '\n', '    function vestingInfo(address user, uint32 nonce) external view returns (uint vestingAmount, uint unvestedAmount, uint vestingReleaseStartDate) {\n', '        vestingAmount = _vestingAmounts[user][nonce];\n', '        unvestedAmount = _unvestedAmounts[user][nonce];\n', '        vestingReleaseStartDate = _vestingReleaseStartDates[user][nonce];\n', '    }\n', '\n', '    function vestingNonces(address user) external view returns (uint lastNonce) {\n', '        return _vestingNonces[user];\n', '    }\n', '    \n', '    function transfer(address dst, uint rawAmount) external whenNotPaused returns (bool) {\n', '        uint96 amount = safe96(rawAmount, "GNBU::transfer: amount exceeds 96 bits");\n', '        _transferTokens(msg.sender, dst, amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address src, address dst, uint rawAmount) external whenNotPaused returns (bool) {\n', '        address spender = msg.sender;\n', '        uint96 spenderAllowance = allowances[src][spender];\n', '        uint96 amount = safe96(rawAmount, "GNBU::approve: amount exceeds 96 bits");\n', '\n', '        if (spender != src && spenderAllowance != uint96(2 ** 96 - 1)) {\n', '            uint96 newAllowance = sub96(spenderAllowance, amount, "GNBU::transferFrom: transfer amount exceeds spender allowance");\n', '            allowances[src][spender] = newAllowance;\n', '\n', '            emit Approval(src, spender, newAllowance);\n', '        }\n', '\n', '        _transferTokens(src, dst, amount);\n', '        return true;\n', '    }\n', '    \n', '    function delegate(address delegatee) public whenNotPaused {\n', '        return _delegate(msg.sender, delegatee);\n', '    }\n', '    \n', '    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public whenNotPaused {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "GNBU::delegateBySig: invalid signature");\n', '        require(nonce == nonces[signatory]++, "GNBU::delegateBySig: invalid nonce");\n', '        require(block.timestamp <= expiry, "GNBU::delegateBySig: signature expired");\n', '        return _delegate(signatory, delegatee);\n', '    }\n', '\n', '    function unvest() external whenNotPaused returns (uint96 unvested) {\n', '        require (_vestingNonces[msg.sender] > 0, "GNBU::unvest:No vested amount");\n', '        for (uint32 i = 1; i <= _vestingNonces[msg.sender]; i++) {\n', '            if (_vestingAmounts[msg.sender][i] == _unvestedAmounts[msg.sender][i]) continue;\n', '            if (_vestingReleaseStartDates[msg.sender][i] > block.timestamp) break;\n', '            uint96 toUnvest = mul96((block.timestamp - _vestingReleaseStartDates[msg.sender][i]), _vestingAmounts[msg.sender][i]) / vestingSecondPeriod;\n', '            if (toUnvest > _vestingAmounts[msg.sender][i]) {\n', '                toUnvest = _vestingAmounts[msg.sender][i];\n', '            } \n', '            uint96 totalUnvestedForNonce = toUnvest;\n', '            toUnvest = sub96(toUnvest, _unvestedAmounts[msg.sender][i], "GNBU::unvest: already unvested amount exceeds toUnvest");\n', '            unvested = add96(unvested, toUnvest, "GNBU::unvest: adding overflow");\n', '            _unvestedAmounts[msg.sender][i] = totalUnvestedForNonce;\n', '        }\n', '        _unfrozenBalances[msg.sender] = add96(_unfrozenBalances[msg.sender], unvested, "GNBU::unvest: adding overflow");\n', '        emit Unvest(msg.sender, unvested);\n', '    }\n', '    \n', '    function getCurrentVotes(address account) external view returns (uint96) {\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;\n', '    }\n', '    \n', '    function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {\n', '        require(blockNumber < block.number, "GNBU::getPriorVotes: not yet determined");\n', '\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        if (nCheckpoints == 0) {\n', '            return 0;\n', '        }\n', '\n', '        // First check most recent balance\n', '        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {\n', '            return checkpoints[account][nCheckpoints - 1].votes;\n', '        }\n', '\n', '        // Next check implicit zero balance\n', '        if (checkpoints[account][0].fromBlock > blockNumber) {\n', '            return 0;\n', '        }\n', '\n', '        uint32 lower = 0;\n', '        uint32 upper = nCheckpoints - 1;\n', '        while (upper > lower) {\n', '            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow\n', '            Checkpoint memory cp = checkpoints[account][center];\n', '            if (cp.fromBlock == blockNumber) {\n', '                return cp.votes;\n', '            } else if (cp.fromBlock < blockNumber) {\n', '                lower = center;\n', '            } else {\n', '                upper = center - 1;\n', '            }\n', '        }\n', '        return checkpoints[account][lower].votes;\n', '    }\n', '    \n', '    function _delegate(address delegator, address delegatee) internal {\n', '        address currentDelegate = delegates[delegator];\n', '        uint96 delegatorBalance = _unfrozenBalances[delegator];\n', '        delegates[delegator] = delegatee;\n', '\n', '        emit DelegateChanged(delegator, currentDelegate, delegatee);\n', '\n', '        _moveDelegates(currentDelegate, delegatee, delegatorBalance);\n', '    }\n', '\n', '    function _transferTokens(address src, address dst, uint96 amount) internal {\n', '        require(src != address(0), "GNBU::_transferTokens: cannot transfer from the zero address");\n', '        require(dst != address(0), "GNBU::_transferTokens: cannot transfer to the zero address");\n', '\n', '        _unfrozenBalances[src] = sub96(_unfrozenBalances[src], amount, "GNBU::_transferTokens: transfer amount exceeds balance");\n', '        _unfrozenBalances[dst] = add96(_unfrozenBalances[dst], amount, "GNBU::_transferTokens: transfer amount overflows");\n', '        emit Transfer(src, dst, amount);\n', '\n', '        _moveDelegates(delegates[src], delegates[dst], amount);\n', '    }\n', '    \n', '    function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {\n', '        if (srcRep != dstRep && amount > 0) {\n', '            if (srcRep != address(0)) {\n', '                uint32 srcRepNum = numCheckpoints[srcRep];\n', '                uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;\n', '                uint96 srcRepNew = sub96(srcRepOld, amount, "GNBU::_moveVotes: vote amount underflows");\n', '                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);\n', '            }\n', '\n', '            if (dstRep != address(0)) {\n', '                uint32 dstRepNum = numCheckpoints[dstRep];\n', '                uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;\n', '                uint96 dstRepNew = add96(dstRepOld, amount, "GNBU::_moveVotes: vote amount overflows");\n', '                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {\n', '      uint32 blockNumber = safe32(block.number, "GNBU::_writeCheckpoint: block number exceeds 32 bits");\n', '\n', '      if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {\n', '          checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;\n', '      } else {\n', '          checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);\n', '          numCheckpoints[delegatee] = nCheckpoints + 1;\n', '      }\n', '\n', '      emit DelegateVotesChanged(delegatee, oldVotes, newVotes);\n', '    }\n', '\n', '    function _vest(address user, uint96 amount) private {\n', '        uint32 nonce = ++_vestingNonces[user];\n', '        _vestingAmounts[user][nonce] = amount;\n', '        _vestingReleaseStartDates[user][nonce] = block.timestamp + vestingFirstPeriod;\n', '        _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], amount, "GNBU::_vest: exceeds owner balance");\n', '        emit Transfer(owner, user, amount);\n', '    }\n', '\n', '\n', '    \n', '    function burnTokens(uint rawAmount) public onlyOwner returns (bool success) {\n', '        uint96 amount = safe96(rawAmount, "GNBU::burnTokens: amount exceeds 96 bits");\n', '        require(amount <= _unfrozenBalances[owner]);\n', '        _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], amount, "GNBU::burnTokens: transfer amount exceeds balance");\n', '        totalSupply = sub96(totalSupply, amount, "GNBU::burnTokens: transfer amount exceeds total supply");\n', '        emit Transfer(owner, address(0), amount);\n', '        return true;\n', '    }\n', '\n', '    function vest(address user, uint rawAmount) external {\n', '        require (vesters[msg.sender], "GNBU::vest: not vester");\n', '        uint96 amount = safe96(rawAmount, "GNBU::vest: amount exceeds 96 bits");\n', '        _vest(user, amount);\n', '    }\n', '    \n', '   \n', '    function multisend(address[] memory to, uint[] memory values) public onlyOwner returns (uint) {\n', '        require(to.length == values.length);\n', '        require(to.length < 100);\n', '        uint sum;\n', '        for (uint j; j < values.length; j++) {\n', '            sum += values[j];\n', '        }\n', '        uint96 _sum = safe96(sum, "GNBU::transfer: amount exceeds 96 bits");\n', '        _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], _sum, "GNBU::_transferTokens: transfer amount exceeds balance");\n', '        for (uint i; i < to.length; i++) {\n', '            _unfrozenBalances[to[i]] = add96(_unfrozenBalances[to[i]], uint96(values[i]), "GNBU::_transferTokens: transfer amount exceeds balance");\n', '            emit Transfer(owner, to[i], values[i]);\n', '        }\n', '        return(to.length);\n', '    }\n', '\n', '    function multivest(address[] memory to, uint[] memory values) external onlyOwner returns (uint) {\n', '        require(to.length == values.length);\n', '        require(to.length < 100);\n', '        uint sum;\n', '        for (uint j; j < values.length; j++) {\n', '            sum += values[j];\n', '        }\n', '        uint96 _sum = safe96(sum, "GNBU::multivest: amount exceeds 96 bits");\n', '        _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], _sum, "GNBU::multivest: transfer amount exceeds balance");\n', '        for (uint i; i < to.length; i++) {\n', '            uint32 nonce = ++_vestingNonces[to[i]];\n', '            _vestingAmounts[to[i]][nonce] = uint96(values[i]);\n', '            _vestingReleaseStartDates[to[i]][nonce] = block.timestamp + vestingFirstPeriod;\n', '            emit Transfer(owner, to[i], values[i]);\n', '        }\n', '        return(to.length);\n', '    }\n', '    \n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return IERC20(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '    function updateVesters(address vester, bool isActive) external onlyOwner { \n', '        vesters[vester] = isActive;\n', '    }\n', '\n', '    function acceptOwnership() public override {\n', '        require(msg.sender == newOwner);\n', '        uint96 amount = _unfrozenBalances[owner];\n', '        _transferTokens(owner, newOwner, amount);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    function updateSupportUnitAdd(address newSupportUnit) external onlyOwner {\n', '        for (uint i; i < supportUnits.length; i++) {\n', '            require (supportUnits[i] != newSupportUnit, "GNBU::updateSupportUnitAdd: support unit exists");\n', '        }\n', '        supportUnits.push(newSupportUnit);\n', '        supportUnitsCnt++;\n', '    }\n', '\n', '    function updateSupportUnitRemove(uint supportUnitIndex) external onlyOwner {\n', '        supportUnits[supportUnitIndex] = supportUnits[supportUnits.length - 1];\n', '        supportUnits.pop();\n', '        supportUnitsCnt--;\n', '    }\n', '    \n', '\n', '\n', '\n', '    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {\n', '        require(n < 2**32, errorMessage);\n', '        return uint32(n);\n', '    }\n', '\n', '    function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {\n', '        require(n < 2**96, errorMessage);\n', '        return uint96(n);\n', '    }\n', '\n', '    function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {\n', '        uint96 c = a + b;\n', '        require(c >= a, errorMessage);\n', '        return c;\n', '    }\n', '\n', '    function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    function getChainId() internal view returns (uint) {\n', '        return block.chainid;\n', '    }\n', '\n', '        \n', '    function mul96(uint96 a, uint96 b) internal pure returns (uint96) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint96 c = a * b;\n', '        require(c / a == b, "GNBU:mul96: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function mul96(uint256 a, uint96 b) internal pure returns (uint96) {\n', '        uint96 _a = safe96(a, "GNBU:mul96: amount exceeds uint96");\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '        uint96 c = _a * b;\n', '        require(c / _a == b, "GNBU:mul96: multiplication overflow");\n', '        return c;\n', '    }\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-27\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-01-29\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract MuteGovernance {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => address) internal _delegates;\n', '\n', '    struct Checkpoint {\n', '        uint32 fromBlock;\n', '        uint256 votes;\n', '    }\n', '\n', '    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;\n', '\n', '    mapping (address => uint32) public numCheckpoints;\n', '\n', '    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");\n', '\n', '    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");\n', '\n', '    mapping (address => uint) public nonces;\n', '\n', '    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);\n', '\n', '    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);\n', '\n', '    function delegates(address delegator) external view returns (address) {\n', '        return _delegates[delegator];\n', '    }\n', '\n', '    function getCurrentVotes(address account) external view returns (uint256) {\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;\n', '    }\n', '\n', '    function getPriorVotes(address account, uint blockNumber) external view returns (uint256) {\n', '        require(blockNumber < block.number, "Gov::getPriorVotes: not yet determined");\n', '\n', '        uint32 nCheckpoints = numCheckpoints[account];\n', '        if (nCheckpoints == 0) {\n', '            return 0;\n', '        }\n', '\n', '        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {\n', '            return checkpoints[account][nCheckpoints - 1].votes;\n', '        }\n', '\n', '        if (checkpoints[account][0].fromBlock > blockNumber) {\n', '            return 0;\n', '        }\n', '\n', '        uint32 lower = 0;\n', '        uint32 upper = nCheckpoints - 1;\n', '        while (upper > lower) {\n', '            uint32 center = upper - (upper - lower) / 2; \n', '            Checkpoint memory cp = checkpoints[account][center];\n', '            if (cp.fromBlock == blockNumber) {\n', '                return cp.votes;\n', '            } else if (cp.fromBlock < blockNumber) {\n', '                lower = center;\n', '            } else {\n', '                upper = center - 1;\n', '            }\n', '        }\n', '        return checkpoints[account][lower].votes;\n', '    }\n', '\n', '    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {\n', '        if (srcRep != dstRep && amount > 0) {\n', '            if (srcRep != address(0)) {\n', '                uint32 srcRepNum = numCheckpoints[srcRep];\n', '                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;\n', '                uint256 srcRepNew = srcRepOld.sub(amount);\n', '                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);\n', '            }\n', '\n', '            if (dstRep != address(0)) {\n', '                uint32 dstRepNum = numCheckpoints[dstRep];\n', '                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;\n', '                uint256 dstRepNew = dstRepOld.add(amount);\n', '                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {\n', '        uint32 blockNumber = safe32(block.number, "Gov::_writeCheckpoint: block number exceeds 32 bits");\n', '\n', '        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {\n', '            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;\n', '        } else {\n', '            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);\n', '            numCheckpoints[delegatee] = nCheckpoints + 1;\n', '        }\n', '\n', '        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);\n', '    }\n', '\n', '    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {\n', '        require(n < 2**32, errorMessage);\n', '        return uint32(n);\n', '    }\n', '\n', '    function getChainId() internal pure returns (uint) {\n', '        uint256 chainId;\n', '        assembly { chainId := chainid() }\n', '        return chainId;\n', '    }\n', '}\n', '\n', 'contract Mute is MuteGovernance {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) private _balances;\n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', '    uint256 private _totalSupply;\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    uint16 public TAX_FRACTION;\n', '    address public taxReceiveAddress;\n', '\n', '    bool public isTaxEnabled;\n', '    mapping(address => bool) public nonTaxedAddresses;\n', '\n', '    address private _owner = address(0);\n', '    mapping (address => bool) private _minters;\n', '\n', '    uint256 public vaultThreshold = 10000e18; \n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _owner, "Mute::OnlyOwner: Not the owner");\n', '        _;\n', '    }\n', '\n', '    modifier onlyMinter() {\n', '        require(_minters[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    function initialize() external {\n', '        require(_owner == address(0), "Mute::Initialize: Contract has already been initialized");\n', '        _owner = msg.sender;\n', '        _name = "Mute.io";\n', '        _symbol = "MUTE";\n', '        _decimals = 18;\n', '    }\n', '\n', '    function setVaultThreshold(uint256 _vaultThreshold) external onlyOwner {\n', '        vaultThreshold = _vaultThreshold;\n', '    }\n', '\n', '    function addMinter(address account) external onlyOwner {\n', '        require(account != address(0));\n', '        _minters[account] = true;\n', '    }\n', '\n', '    function removeMinter(address account) external onlyOwner {\n', '        require(account != address(0));\n', '        _minters[account] = false;\n', '    }\n', '\n', '    function setTaxReceiveAddress(address _taxReceiveAddress) external onlyOwner {\n', '        taxReceiveAddress = _taxReceiveAddress;\n', '    }\n', '\n', '    function setAddressTax(address _address, bool ignoreTax) external onlyOwner {\n', '        nonTaxedAddresses[_address] = ignoreTax;\n', '    }\n', '\n', '    function setTaxFraction(uint16 _tax_fraction) external onlyOwner {\n', '        TAX_FRACTION = _tax_fraction;\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function allowance(address owner_, address spender) public view returns (uint256) {\n', '        return _allowances[owner_][spender];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "Mute: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        require(sender != address(0), "Mute: transfer from the zero address");\n', '        require(recipient != address(0), "Mute: transfer to the zero address");\n', '\n', '        if(nonTaxedAddresses[sender] == true || TAX_FRACTION == 0 || balanceOf(taxReceiveAddress) > vaultThreshold){\n', '          _balances[sender] = _balances[sender].sub(amount, "Mute: transfer amount exceeds balance");\n', '          \n', '          if(balanceOf(taxReceiveAddress) > vaultThreshold){\n', '              IMuteVault(taxReceiveAddress).reward();\n', '          }\n', '\n', '          _balances[recipient] = _balances[recipient].add(amount);\n', '\n', '          _moveDelegates(_delegates[sender], _delegates[recipient], amount);\n', '\n', '          emit Transfer(sender, recipient, amount);\n', '\n', '          return;\n', '        }\n', '\n', '        uint256 feeAmount = amount.mul(TAX_FRACTION).div(100);\n', '        uint256 newAmount = amount.sub(feeAmount);\n', '\n', '        require(amount == feeAmount.add(newAmount), "Mute: math is broken");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "Mute: transfer amount exceeds balance");\n', '\n', '        _balances[recipient] = _balances[recipient].add(newAmount);\n', '        _moveDelegates(_delegates[sender], _delegates[recipient], newAmount);\n', '        _balances[taxReceiveAddress] = _balances[taxReceiveAddress].add(feeAmount);\n', '        _moveDelegates(_delegates[sender], _delegates[taxReceiveAddress], feeAmount);\n', '\n', '        emit Transfer(sender, recipient, newAmount);\n', '        emit Transfer(sender, taxReceiveAddress, feeAmount);\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "Mute: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    function _approve(address owner_, address spender, uint256 amount) internal {\n', '        require(owner_ != address(0), "Mute: approve from the zero address");\n', '        require(spender != address(0), "Mute: approve to the zero address");\n', '\n', '        _allowances[owner_][spender] = amount;\n', '        emit Approval(owner_, spender, amount);\n', '    }\n', '\n', '    function Burn(uint256 amount) external returns (bool) {\n', '        require(msg.sender != address(0), "Mute: burn from the zero address");\n', '\n', '        _moveDelegates(_delegates[msg.sender], address(0), amount);\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(amount, "Mute: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(msg.sender, address(0), amount);\n', '        return true;\n', '    }\n', '\n', '    function Mint(address account, uint256 amount) external onlyMinter returns (bool) {\n', '        require(account != address(0), "Mute: mint to the zero address");\n', '\n', '        _moveDelegates(address(0), _delegates[account], amount);\n', '\n', '        _balances[account] = _balances[account].add(amount);\n', '        _totalSupply = _totalSupply.add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '        return true;\n', '    }\n', '\n', '    function delegate(address delegatee) external {\n', '        return _delegate(msg.sender, delegatee);\n', '    }\n', '\n', '    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), getChainId(), address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "Mute::delegateBySig: invalid signature");\n', '        require(nonce == nonces[signatory]++, "Mute::delegateBySig: invalid nonce");\n', '        require(now <= expiry, "Mute::delegateBySig: signature expired");\n', '        return _delegate(signatory, delegatee);\n', '    }\n', '\n', '    function _delegate(address delegator, address delegatee) internal {\n', '        address currentDelegate = _delegates[delegator];\n', '        uint256 delegatorBalance = balanceOf(delegator);\n', '        _delegates[delegator] = delegatee;\n', '\n', '        emit DelegateChanged(delegator, currentDelegate, delegatee);\n', '\n', '        _moveDelegates(currentDelegate, delegatee, delegatorBalance);\n', '    }\n', '}\n', '\n', 'interface IMuteVault {\n', '    function reward() external returns (bool);\n', '}']
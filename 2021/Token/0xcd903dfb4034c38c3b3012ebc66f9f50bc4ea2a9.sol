['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-10\n', '*/\n', '\n', '// ----------------------------------------------------------------------------\n', '// Medi Chain contract\n', '// Name        : Medi Chain\n', '// Symbol      : MCH\n', '// Decimals    : 18\n', '// InitialSupply : 20,000,000,000\n', '// ----------------------------------------------------------------------------\n', '\n', 'pragma solidity 0.5.8;\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) internal _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount);\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '    \n', '    \n', '    \n', '\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burn(account, amount);\n', '        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));\n', '    }\n', '}\n', '\n', 'contract MediChain is ERC20 {\n', '    string public constant name = "Medi Chain"; \n', '    string public constant symbol = "MCH"; \n', '    uint8 public constant decimals = 18; \n', '    uint256 public constant initialSupply = 20000000000 * (10 ** uint256(decimals));\n', '    \n', '    constructor() public {\n', '        super._mint(msg.sender, initialSupply);\n', '        owner = msg.sender;\n', '    }\n', '\n', '    address public owner;\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '    );\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Not owner");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0), "Already Owner");\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused, "Paused by owner");\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused, "Not paused now");\n', '        _;\n', '    }\n', '\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '\n', '    event Frozen(address target);\n', '    event Unfrozen(address target);\n', '\n', '    mapping(address => bool) internal freezes;\n', '\n', '    modifier whenNotFrozen() {\n', '        require(!freezes[msg.sender], "Sender account is locked.");\n', '        _;\n', '    }\n', '\n', '    function freeze(address _target) public onlyOwner {\n', '        freezes[_target] = true;\n', '        emit Frozen(_target);\n', '    }\n', '\n', '    function unfreeze(address _target) public onlyOwner {\n', '        freezes[_target] = false;\n', '        emit Unfrozen(_target);\n', '    }\n', '\n', '    function isFrozen(address _target) public view returns (bool) {\n', '        return freezes[_target];\n', '    }\n', '\n', '    function transfer(\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '      public\n', '      whenNotFrozen\n', '      whenNotPaused\n', '      returns (bool)\n', '    {\n', '        releaseLock(msg.sender);\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '      public\n', '      whenNotPaused\n', '      returns (bool)\n', '    {\n', '        require(!freezes[_from], "From account is locked.");\n', '        releaseLock(_from);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(address _who, uint256 _value) public onlyOwner {\n', '        require(_value <= super.balanceOf(_who), "Balance is too small.");\n', '\n', '        _burn(_who, _value);\n', '        emit Burn(_who, _value);\n', '    }\n', '\n', '    struct LockInfo {\n', '        uint256 releaseTime;\n', '        uint256 balance;\n', '    }\n', '    mapping(address => LockInfo[]) internal lockInfo;\n', '\n', '    event Lock(address indexed holder, uint256 value, uint256 releaseTime);\n', '    event Unlock(address indexed holder, uint256 value);\n', '\n', '    function balanceOf(address _holder) public view returns (uint256 balance) {\n', '        uint256 lockedBalance = 0;\n', '        for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {\n', '            lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);\n', '        }\n', '        return super.balanceOf(_holder).add(lockedBalance);\n', '    }\n', '\n', '    function releaseLock(address _holder) internal {\n', '\n', '        for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {\n', '            if (lockInfo[_holder][i].releaseTime <= now) {\n', '                _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);\n', '                emit Unlock(_holder, lockInfo[_holder][i].balance);\n', '                lockInfo[_holder][i].balance = 0;\n', '\n', '                if (i != lockInfo[_holder].length - 1) {\n', '                    lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];\n', '                    i--;\n', '                }\n', '                lockInfo[_holder].length--;\n', '\n', '            }\n', '        }\n', '    }\n', '    function lockCount(address _holder) public view returns (uint256) {\n', '        return lockInfo[_holder].length;\n', '    }\n', '    function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {\n', '        return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);\n', '    }\n', '\n', '    function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {\n', '        require(super.balanceOf(_holder) >= _amount, "Balance is too small.");\n', '        _balances[_holder] = _balances[_holder].sub(_amount);\n', '        lockInfo[_holder].push(\n', '            LockInfo(_releaseTime, _amount)\n', '        );\n', '        emit Lock(_holder, _amount, _releaseTime);\n', '    }\n', '\n', '    function unlock(address _holder, uint256 i) public onlyOwner {\n', '        require(i < lockInfo[_holder].length, "No lock information.");\n', '\n', '        _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);\n', '        emit Unlock(_holder, lockInfo[_holder][i].balance);\n', '        lockInfo[_holder][i].balance = 0;\n', '\n', '        if (i != lockInfo[_holder].length - 1) {\n', '            lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];\n', '        }\n', '        lockInfo[_holder].length--;\n', '    }\n', '\n', '    function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {\n', '        require(_to != address(0), "wrong address");\n', '        require(_value <= super.balanceOf(owner), "Not enough balance");\n', '\n', '        _balances[owner] = _balances[owner].sub(_value);\n', '        lockInfo[_to].push(\n', '            LockInfo(_releaseTime, _value)\n', '        );\n', '        emit Transfer(owner, _to, _value);\n', '        emit Lock(_to, _value, _releaseTime);\n', '\n', '        return true;\n', '    }\n', '\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-17\n', '*/\n', '\n', 'pragma solidity ^0.5.4;\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) internal _balances;\n', '\n', '    mapping(address => mapping(address => uint256)) private _allowed;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    function allowance(address owner, address spender)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) public returns (bool) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(\n', '            addedValue\n', '        );\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(\n', '            subtractedValue\n', '        );\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '}\n', '\n', 'contract FESTA is ERC20 {\n', '    string public constant name = "FESTA";\n', '    string public constant symbol = "FESTA";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant initialSupply = 50000000000 * (10**uint256(decimals));\n', '\n', '    constructor() public {\n', '        super._mint(msg.sender, initialSupply);\n', '        owner = msg.sender;\n', '    }\n', '\n', '    address public owner;\n', '\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Not owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0), "Already owner");\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '    function dropToken(address[] memory _receivers, uint256[] memory _values)  public onlyOwner {\n', '        require(_receivers.length != 0);\n', '        require(_receivers.length == _values.length);\n', '        \n', '        for (uint256 i = 0; i < _receivers.length; i++) {\n', '            transfer(_receivers[i], _values[i]);\n', '            emit Transfer(msg.sender, _receivers[i], _values[i]);\n', '        }\n', '    }\n', '\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused, "Paused by owner");\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused, "Not paused now");\n', '        _;\n', '    }\n', '\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '\n', '    event Frozen(address target);\n', '    event Unfrozen(address target);\n', '\n', '    mapping(address => bool) internal freezes;\n', '\n', '    modifier whenNotFrozen() {\n', '        require(!freezes[msg.sender], "Sender account is locked.");\n', '        _;\n', '    }\n', '\n', '    function freeze(address _target) public onlyOwner {\n', '        freezes[_target] = true;\n', '        emit Frozen(_target);\n', '    }\n', '\n', '    function unfreeze(address _target) public onlyOwner {\n', '        freezes[_target] = false;\n', '        emit Unfrozen(_target);\n', '    }\n', '\n', '    function isFrozen(address _target) public view returns (bool) {\n', '        return freezes[_target];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        whenNotFrozen\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        releaseLock(msg.sender);\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    ) public whenNotPaused returns (bool) {\n', '        require(!freezes[_from], "From account is locked.");\n', '        releaseLock(_from);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(address _who, uint256 _value) public onlyOwner {\n', '        require(_value <= super.balanceOf(_who), "Balance is too small.");\n', '\n', '        _burn(_who, _value);\n', '        emit Burn(_who, _value);\n', '    }\n', '\n', '    struct LockInfo {\n', '        uint256 releaseTime;\n', '        uint256 balance;\n', '    }\n', '    mapping(address => LockInfo[]) internal lockInfo;\n', '\n', '    event Lock(address indexed holder, uint256 value, uint256 releaseTime);\n', '    event Unlock(address indexed holder, uint256 value);\n', '\n', '    function balanceOf(address _holder) public view returns (uint256 balance) {\n', '        uint256 lockedBalance = 0;\n', '        for (uint256 i = 0; i < lockInfo[_holder].length; i++) {\n', '            if (lockInfo[_holder][i].releaseTime <= now) {\n', '                lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);\n', '            }\n', '        }\n', '        return super.balanceOf(_holder).add(lockedBalance);\n', '    }\n', '\n', '    function balanceOfLocked(address _holder) public view returns (uint256 balance) {\n', '        uint256 lockedBalance = 0;\n', '        for (uint256 i = 0; i < lockInfo[_holder].length; i++) {\n', '            if (lockInfo[_holder][i].releaseTime > now) {\n', '                lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);\n', '            }\n', '        }\n', '        return lockedBalance;\n', '    }\n', '    \n', '    function balanceOfTotal(address _holder) public view returns (uint256 balance) {\n', '        uint256 lockedBalance = 0;\n', '        for (uint256 i = 0; i < lockInfo[_holder].length; i++) {\n', '            lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);\n', '        }\n', '        return super.balanceOf(_holder).add(lockedBalance);\n', '    }\n', '\n', '\n', '    function releaseLock(address _holder) internal {\n', '        for (uint256 i = 0; i < lockInfo[_holder].length; i++) {\n', '            if (lockInfo[_holder][i].releaseTime <= now) {\n', '                _balances[_holder] = _balances[_holder].add(\n', '                    lockInfo[_holder][i].balance\n', '                );\n', '                emit Unlock(_holder, lockInfo[_holder][i].balance);\n', '                lockInfo[_holder][i].balance = 0;\n', '\n', '                if (i != lockInfo[_holder].length - 1) {\n', '                    lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder]\n', '                        .length - 1];\n', '                    i--;\n', '                }\n', '                lockInfo[_holder].length--;\n', '            }\n', '        }\n', '    }\n', '\n', '    function lockCount(address _holder) public view returns (uint256) {\n', '        return lockInfo[_holder].length;\n', '    }\n', '    \n', '    function lockState(address _holder, uint256 _idx)\n', '        public\n', '        view\n', '        returns (uint256, uint256)\n', '    {\n', '        return (\n', '            lockInfo[_holder][_idx].releaseTime,\n', '            lockInfo[_holder][_idx].balance\n', '        );\n', '    }\n', '\n', '    function lock(\n', '        address _holder,\n', '        uint256 _amount,\n', '        uint256 _releaseTime\n', '    ) public onlyOwner {\n', '        require(super.balanceOf(_holder) >= _amount, "Balance is too small.");\n', '        _balances[_holder] = _balances[_holder].sub(_amount);\n', '        lockInfo[_holder].push(LockInfo(_releaseTime, _amount));\n', '        emit Lock(_holder, _amount, _releaseTime);\n', '    }\n', '\n', '    function lockAfter(\n', '        address _holder,\n', '        uint256 _amount,\n', '        uint256 _afterTime\n', '    ) public onlyOwner {\n', '        require(super.balanceOf(_holder) >= _amount, "Balance is too small.");\n', '        _balances[_holder] = _balances[_holder].sub(_amount);\n', '        lockInfo[_holder].push(LockInfo(now + _afterTime, _amount));\n', '        emit Lock(_holder, _amount, now + _afterTime);\n', '    }\n', '\n', '    function unlock(address _holder, uint256 i) public onlyOwner {\n', '        require(i < lockInfo[_holder].length, "No lock information.");\n', '\n', '        _balances[_holder] = _balances[_holder].add(\n', '            lockInfo[_holder][i].balance\n', '        );\n', '        emit Unlock(_holder, lockInfo[_holder][i].balance);\n', '        lockInfo[_holder][i].balance = 0;\n', '\n', '        if (i != lockInfo[_holder].length - 1) {\n', '            lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length -\n', '                1];\n', '        }\n', '        lockInfo[_holder].length--;\n', '    }\n', '\n', '    function transferWithLock(\n', '        address _to,\n', '        uint256 _value,\n', '        uint256 _releaseTime\n', '    ) public onlyOwner returns (bool) {\n', '        require(_to != address(0), "wrong address");\n', '        require(_value <= super.balanceOf(owner), "Not enough balance");\n', '\n', '        _balances[owner] = _balances[owner].sub(_value);\n', '        lockInfo[_to].push(LockInfo(_releaseTime, _value));\n', '        emit Transfer(owner, _to, _value);\n', '        emit Lock(_to, _value, _releaseTime);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferWithLockAfter(\n', '        address _to,\n', '        uint256 _value,\n', '        uint256 _afterTime\n', '    ) public onlyOwner returns (bool) {\n', '        require(_to != address(0), "wrong address");\n', '        require(_value <= super.balanceOf(owner), "Not enough balance");\n', '\n', '        _balances[owner] = _balances[owner].sub(_value);\n', '        lockInfo[_to].push(LockInfo(now + _afterTime, _value));\n', '        emit Transfer(owner, _to, _value);\n', '        emit Lock(_to, _value, now + _afterTime);\n', '\n', '        return true;\n', '    }\n', '\n', '    function currentTime() public view returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '    function afterTime(uint256 _value) public view returns (uint256) {\n', '        return now + _value;\n', '    }\n', '}']
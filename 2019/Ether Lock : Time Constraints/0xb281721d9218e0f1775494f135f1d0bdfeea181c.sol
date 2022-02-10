['pragma solidity >=0.4.22 <0.6.0;\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;       \n', '    }       \n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    modifier onlyNewOwner() {\n', '        require(msg.sender != address(0));\n', '        require(msg.sender == newOwner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0));\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public onlyNewOwner returns(bool) {\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract COZi is ERC20, Ownable, Pausable {\n', '    \n', '    using SafeMath for uint256;\n', '\n', '    struct LockupInfo {\n', '        uint256 releaseTime;\n', '        uint256 termOfRound;\n', '        uint256 unlockAmountPerRound;        \n', '        uint256 lockupBalance;\n', '    }\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 internal initialSupply;\n', '    uint256 internal totalSupply_;\n', '\n', '    mapping(address => uint256) internal balances;\n', '    mapping(address => bool) internal locks;\n', '    mapping(address => bool) public frozen;\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '    mapping(address => LockupInfo) internal lockupInfo;\n', '\n', '    event Unlock(address indexed holder, uint256 value);\n', '    event Lock(address indexed holder, uint256 value);\n', '    event Burn(address indexed owner, uint256 value);\n', '    event Mint(uint256 value);\n', '    event Freeze(address indexed holder);\n', '    event Unfreeze(address indexed holder);\n', '\n', '    modifier notFrozen(address _holder) {\n', '        require(!frozen[_holder]);\n', '        _;\n', '    }\n', '    \n', '    constructor() public payable{\n', '        name = "COZi";\n', '        symbol = "COZi";\n', '        decimals = 18;\n', '        initialSupply = 12000000;\n', '        totalSupply_ = initialSupply * 10 ** uint(decimals);\n', '        balances[owner] = totalSupply_;\n', '        emit Transfer(address(0), owner, totalSupply_);\n', '    }\n', '\n', '    function () external payable {\n', '        revert();\n', '        \n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {\n', '        if (locks[msg.sender]) {\n', '            autoUnlock(msg.sender);            \n', '        }   \n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        \n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _holder) public view returns (uint256 balance) {\n', '        return balances[_holder] + lockupInfo[_holder].lockupBalance;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {\n', '        if (locks[_from]) {\n', '            autoUnlock(_from);            \n', '        }\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        \n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _holder, address _spender) public view returns (uint256) {\n', '        return allowed[_holder][_spender];\n', '    }\n', '\n', '    function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {\n', '        require(locks[_holder] == false);\n', '        require(balances[_holder] >= _amount);\n', '        balances[_holder] = balances[_holder].sub(_amount);\n', '        lockupInfo[_holder] = LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount);\n', '\n', '        locks[_holder] = true; \n', '\n', '        emit Lock(_holder, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function unlock(address _holder) public onlyOwner returns (bool) {\n', '        require(locks[_holder] == true);\n', '        uint256 releaseAmount = lockupInfo[_holder].lockupBalance;\n', '\n', '        delete lockupInfo[_holder];\n', '        locks[_holder] = false;\n', '\n', '        emit Unlock(_holder, releaseAmount);\n', '        balances[_holder] = balances[_holder].add(releaseAmount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function freezeAccount(address _holder) public onlyOwner returns (bool) {\n', '        require(!frozen[_holder]);\n', '        frozen[_holder] = true;\n', '        emit Freeze(_holder);\n', '        return true;\n', '    }\n', '\n', '    function unfreezeAccount(address _holder) public onlyOwner returns (bool) {\n', '        require(frozen[_holder]);\n', '        frozen[_holder] = false;\n', '        emit Unfreeze(_holder);\n', '        return true;\n', '    }\n', '\n', '    function getNowTime() public view returns(uint256) {\n', '      return now;\n', '    }\n', '\n', '    function showLockState(address _holder) public view returns (bool, uint256, uint256, uint256, uint256) {\n', '        return (locks[_holder], lockupInfo[_holder].lockupBalance, lockupInfo[_holder].releaseTime, lockupInfo[_holder].termOfRound, lockupInfo[_holder].unlockAmountPerRound);\n', '    }\n', '\n', '    function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[owner]);\n', '\n', '        balances[owner] = balances[owner].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(owner, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {\n', '        distribute(_to, _value);\n', '        lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);\n', '        return true;\n', '    }\n', '\n', '    function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {\n', '        token.transfer(_to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public onlyOwner returns (bool success) {\n', '        require(_value <= balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(burner, _value);\n', '        return true;\n', '    }\n', '\n', '    function mint( uint256 _amount) onlyOwner public returns (bool) {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[owner] = balances[owner].add(_amount);\n', '\n', '        emit Transfer(address(0), owner, _amount);\n', '        return true;\n', '    }\n', '\n', '    function isContract(address addr) internal view returns (bool) {\n', '        uint size;\n', '        assembly{size := extcodesize(addr)}\n', '        return size > 0;\n', '    }\n', '\n', '    function autoUnlock(address _holder) internal returns (bool) {\n', '        if (lockupInfo[_holder].releaseTime <= now) {\n', '            return releaseTimeLock(_holder);\n', '        } \n', '        return false;\n', '    }\n', '\n', '    function releaseTimeLock(address _holder) internal returns(bool) {\n', '        require(locks[_holder]);\n', '        uint256 releaseAmount = 0;\n', '        // If lock status of holder is finished, delete lockup info. \n', '       \n', '        for( ; lockupInfo[_holder].releaseTime <= now ; )\n', '        {\n', '            if (lockupInfo[_holder].lockupBalance <= lockupInfo[_holder].unlockAmountPerRound) {   \n', '                releaseAmount = releaseAmount.add(lockupInfo[_holder].lockupBalance);\n', '                delete lockupInfo[_holder];\n', '                locks[_holder] = false;\n', '                break;             \n', '            } else {\n', '                releaseAmount = releaseAmount.add(lockupInfo[_holder].unlockAmountPerRound);\n', '                lockupInfo[_holder].lockupBalance = lockupInfo[_holder].lockupBalance.sub(lockupInfo[_holder].unlockAmountPerRound);\n', '\n', '                lockupInfo[_holder].releaseTime = lockupInfo[_holder].releaseTime.add(lockupInfo[_holder].termOfRound);\n', '                \n', '            }            \n', '        }\n', '\n', '        emit Unlock(_holder, releaseAmount);\n', '        balances[_holder] = balances[_holder].add(releaseAmount);\n', '        return true;\n', '    }\n', '\n', '}']
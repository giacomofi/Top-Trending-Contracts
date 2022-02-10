['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    if (_a == 0) {\n', '    return 0;\n', '    }\n', '    uint256 c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '    }\n', '\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    uint256 c = _a / _b;\n', '    return c;\n', '    }\n', '    \n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '    }\n', '\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    uint256 c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '    owner = msg.sender;\n', '    newOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '    }\n', '\n', '    modifier onlyNewOwner() {\n', '    require(msg.sender != address(0));\n', '    require(msg.sender == newOwner);\n', '    _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '    require(_newOwner != address(0));\n', '    newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public onlyNewOwner returns(bool) {\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', ' \n', '\n', 'interface TokenRecipient {\n', ' function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;\n', '}\n', '\n', ' \n', '\n', 'contract TestCoin is ERC20, Ownable {\n', '    using SafeMath for uint256;\n', '    \n', '    struct LockupInfo {\n', '    uint256 releaseTime;\n', '    uint256 termOfRound;\n', '    uint256 unlockAmountPerRound;\n', '    uint256 lockupBalance;\n', '    }\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 internal initialSupply;\n', '    uint256 internal totalSupply_;\n', '    \n', '    mapping(address => uint256) internal balances;\n', '    mapping(address => bool) internal locks;\n', '    mapping(address => bool) public frozen;\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '    mapping(address => LockupInfo) internal lockupInfo;\n', '    \n', '    event Unlock(address indexed holder, uint256 value);\n', '    event Lock(address indexed holder, uint256 value);\n', '    event Burn(address indexed owner, uint256 value);\n', '    event Mint(uint256 value);\n', '    event Freeze(address indexed holder);\n', '    event Unfreeze(address indexed holder);\n', '    \n', '    modifier notFrozen(address _holder) {\n', '    require(!frozen[_holder]);\n', '    _;\n', '    }\n', '\n', '    constructor() public {\n', '    name = "TestCoin";\n', '    symbol = "TTC";\n', '    decimals = 0;\n', '    initialSupply = 10000000000;\n', '    totalSupply_ = 10000000000;\n', '    balances[owner] = totalSupply_;\n', '    emit Transfer(address(0), owner, totalSupply_);\n', '    }\n', '\n', '    function () public payable {\n', '    revert();\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '       \n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '    \n', '       balances[_from] = balances[_from].sub(_value);\n', '       balances[_to] = balances[_to].add(_value);\n', '      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '      emit Transfer(_from, _to, _value);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {\n', '    \n', '    if (locks[msg.sender]) {\n', '    }\n', '    \n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    \n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '    }\n', '\n', '    function balanceOf(address _holder) public view returns (uint256 balance) {\n', '    return balances[_holder] + lockupInfo[_holder].lockupBalance;\n', '    }\n', '    \n', '    function sendwithgas (address _from, address _to, uint256 _value, uint256 _fee) public notFrozen(_from) returns (bool) {\n', '\n', '\n', '    require(_to != address(0));\n', '    require(_value.add(_fee) <= balances[_from]);\n', '    balances[msg.sender] = balances[msg.sender].add(_fee);\n', '    balances[_from] = balances[_from].sub(_value.add(_fee));\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    emit Transfer(_from, _to, _value);\n', '\n', '    emit Transfer(_from, msg.sender, _value);\n', '\n', '    //require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to])\n', '    return true;\n', '\n', '    }\n', '     \n', '    function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {\n', '\n', '        if (locks[_from]) {\n', '        }\n', '    \n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    _transfer(_from, _to, _value);\n', '    \n', '    return true;\n', '    }\n', '    \n', '    \n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '    }\n', '\n', '    function allowance(address _holder, address _spender) public view returns (uint256) {\n', '    return allowed[_holder][_spender];\n', '    }\n', '\n', '    function freezeAccount(address _holder) public onlyOwner returns (bool) {\n', '    require(!frozen[_holder]);\n', '    frozen[_holder] = true;\n', '    emit Freeze(_holder);\n', '    return true;\n', '    }\n', '\n', '    function unfreezeAccount(address _holder) public onlyOwner returns (bool) {\n', '    require(frozen[_holder]);\n', '    frozen[_holder] = false;\n', '    emit Unfreeze(_holder);\n', '    return true;\n', '    }\n', '    \n', '   function burn(uint256 _value) public onlyOwner returns (bool success) {\n', '    require(_value <= balances[msg.sender]);\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(burner, _value);\n', '    return true;\n', '    }\n', '\n', '    function mint( uint256 _amount) onlyOwner public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[owner] = balances[owner].add(_amount);\n', '    \n', '    emit Transfer(address(0), owner, _amount);\n', '    return true;\n', '    }\n', '\n', '    function isContract(address addr) internal view returns (bool) {\n', '    uint size;\n', '    assembly{size := extcodesize(addr)}\n', '    return size > 0;\n', '    }\n', '}']
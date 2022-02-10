['pragma solidity 0.4.24;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', ' \n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', ' \n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', ' \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', ' \n', 'contract StandardToken {\n', ' \n', '    using SafeMath for uint256;\n', '   \n', '    string public name;\n', '     \n', '    string public symbol;\n', '\t \n', '    uint8 public  decimals;\n', '\t \n', '\t  uint256 public totalSupply;\n', '   \n', '\t \n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '     \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\t \n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\t \n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\t \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\t \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', ' \n', 'contract Owned {\n', ' \n', '     \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _; \n', '    }\n', ' \n', '\t \n', '    address public owner;\n', ' \n', ' \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\t \n', '    address newOwner=0x0;\n', ' \n', '\t \n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', ' \n', '     \n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', ' \n', '     \n', '    function acceptOwnership() public{\n', '        require(msg.sender == newOwner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', ' \n', ' \n', 'contract Controlled is Owned{\n', ' \n', '\t \n', '    constructor() public {\n', '       setExclude(msg.sender,true);\n', '    }\n', ' \n', '    \n', '    bool public transferEnabled = true;\n', ' \n', '     \n', '    bool lockFlag=true;\n', '\t \n', '    mapping(address => bool) locked;\n', '\t \n', '    mapping(address => bool) exclude;\n', ' \n', '\t \n', '    function enableTransfer(bool _enable) public onlyOwner returns (bool success){\n', '        transferEnabled=_enable;\n', '\t\treturn true;\n', '    }\n', ' \n', '\t \n', '    function disableLock(bool _enable) public onlyOwner returns (bool success){\n', '        lockFlag=_enable;\n', '        return true;\n', '    }\n', ' \n', ' \n', '    function addLock(address _addr) public onlyOwner returns (bool success){\n', '        require(_addr!=msg.sender);\n', '        locked[_addr]=true;\n', '        return true;\n', '    }\n', ' \n', '\t \n', '    function setExclude(address _addr,bool _enable) public onlyOwner returns (bool success){\n', '        exclude[_addr]=_enable;\n', '        return true;\n', '    }\n', ' \n', '\t \n', '    function removeLock(address _addr) public onlyOwner returns (bool success){\n', '        locked[_addr]=false;\n', '        return true;\n', '    }\n', '\t \n', '    modifier transferAllowed(address _addr) {\n', '        if (!exclude[_addr]) {\n', '            require(transferEnabled,"transfer is not enabeled now!");\n', '            if(lockFlag){\n', '                require(!locked[_addr],"you are locked!");\n', '            }\n', '        }\n', '        _;\n', '    }\n', ' \n', '}\n', ' \n', ' \n', 'contract GECToken is StandardToken,Controlled {\n', ' \n', '\t \n', '\tmapping (address => uint256) public balanceOf;\n', '\tmapping (address => mapping (address => uint256)) internal allowed;\n', '    \t\n', '\tconstructor() public {\n', '        totalSupply = 1000000000;//10亿\n', '        name = "GECToken";\n', '        symbol = "GECT";\n', '        decimals = 8;\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '          \n', '    function mintToken(address target, uint256 mintedAmount) public onlyOwner {\n', '        balanceOf[target] = balanceOf[target].add(mintedAmount);\n', '        totalSupply = totalSupply.add(mintedAmount);\n', '        emit Transfer(0, owner, mintedAmount);\n', '        emit Transfer(owner, target, mintedAmount);\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool success) {\n', '\t\trequire(_to != address(0));\n', '\t\trequire(_value <= balanceOf[msg.sender]);\n', ' \n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', ' \n', '    function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(_from) returns (bool success) {\n', '\t\trequire(_to != address(0));\n', '        require(_value <= balanceOf[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', ' \n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', ' \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', ' \n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', ' \n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract Ozinex is StandardToken {\n', '    // 基本信息\n', '    string public TOKEN_NAME = "Ozinex";\n', '    string public SYMBOL = "OZI";\n', '    uint256 public INITIAL_SUPPLY = 500000000;\n', '    uint8 public DECIMALS = 8;\n', '\n', '    // 锁定和冻结\n', '    mapping(address => bool) private lockAccount;\n', '    mapping(address => uint256) private frozenTimestamp;\n', '\n', '    // 合约所有者\n', '    address public owner;\n', '\n', '    // 单个消息结构体\n', '    struct Msg {\n', '        uint256 timestamp;\n', '        address sender;\n', '        string content;\n', '    }\n', '\n', '    // 记录发送消息\n', '    Msg[] private msgs;\n', '\n', '    mapping(uint => address) public msgToOwner;\n', '    mapping(address => uint) ownerMsgCount;\n', '\n', '    // 事件\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event SendMsgEvent(address indexed _from, string _content);\n', '\n', '    // 构造函数, 不需要参数\n', '    constructor() public {\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // 标准修改器, 仅所有者可调用\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "onlyOwner method called by non-owner.");\n', '        _;\n', '    }\n', '\n', '    function setOwner(address _newOwner) external onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '\n', '    // 锁定帐户\n', '    function lock(address _target, bool _freeze) external onlyOwner returns (bool) {\n', '        require(_target != address(0));\n', '        lockAccount[_target] = _freeze;\n', '        return true;\n', '    }\n', '\n', '    // 冻结帐户\n', '    function freezeByTimestamp(address _target, uint256 _timestamp) external onlyOwner returns (bool) {\n', '        require(_target != address(0));\n', '        frozenTimestamp[_target] = _timestamp;\n', '        return true;\n', '    }\n', '\n', '    // 查询冻结帐户结束时间\n', '    function getFrozenTimestamp(address _target) external onlyOwner view returns (uint256) {\n', '        require(_target != address(0));\n', '        return frozenTimestamp[_target];\n', '    }\n', '\n', '    // 转帐\n', '    function transfer(address _to, uint256 _amount) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(lockAccount[msg.sender] != true);\n', '        require(frozenTimestamp[msg.sender] < now);\n', '        require(balances[msg.sender] >= _amount);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '}']
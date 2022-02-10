['pragma solidity^0.4.21;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    mapping (uint256 => address) public owner;\n', '    address[] public allOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner[0] = msg.sender;\n', '        allOwner.push(msg.sender);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner[0] || msg.sender == owner[1] || msg.sender == owner[2]);\n', '        _;\n', '    }\n', '    \n', '    function addnewOwner(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        uint256 len = allOwner.length;\n', '        owner[len] = newOwner;\n', '        allOwner.push(newOwner);\n', '    }\n', '\n', '    function setNewOwner(address newOwner, uint position) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        require(position == 1 || position == 2);\n', '        owner[position] = newOwner;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner[0], newOwner);\n', '        owner[0] = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public;\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '}\n', '\n', 'contract KNBaseToken is ERC20 {\n', '    using SafeMath for uint256;\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 totalSupply_;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public{\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply_ = _totalSupply;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value);\n', '        require(balances[_to].add(_value) > balances[_to]);\n', '\n', '\n', '        uint256 previousBalances = balances[_from].add(balances[_to]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        assert(balances[_from].add(balances[_to]) == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= allowed[_from][msg.sender]);     // Check allowance\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract KnowToken is KNBaseToken("Know Token", "KN", 18, 7795482309000000000000000000), Ownable {\n', '\n', '    uint256 internal privateToken = 389774115000000000000000000;\n', '    uint256 internal preSaleToken = 1169322346000000000000000000;\n', '    uint256 internal crowdSaleToken = 3897741155000000000000000000;\n', '    uint256 internal bountyToken;\n', '    uint256 internal foundationToken;\n', '    address public founderAddress;\n', '    bool public unlockAllTokens;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool unfrozen);\n', '    event UnLockAllTokens(bool unlock);\n', '\n', '    constructor() public {\n', '        founderAddress = msg.sender;\n', '        balances[founderAddress] = totalSupply_;\n', '        emit Transfer(address(0), founderAddress, totalSupply_);\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != address(0));                               \n', '        require (balances[_from] >= _value);               \n', '        require (balances[_to].add(_value) >= balances[_to]); \n', '        require(!frozenAccount[_from] || unlockAllTokens);\n', '\n', '        balances[_from] = balances[_from].sub(_value);                  \n', '        balances[_to] = balances[_to].add(_value);                  \n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function unlockAllTokens(bool _unlock) public onlyOwner {\n', '        unlockAllTokens = _unlock;\n', '        emit UnLockAllTokens(_unlock);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) public onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '}']
['pragma solidity^0.4.21;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    mapping (uint256 => address) public owner;\n', '    address[] public allOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner[0] = msg.sender;\n', '        allOwner.push(msg.sender);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner[0] || msg.sender == owner[1] || msg.sender == owner[2]);\n', '        _;\n', '    }\n', '    \n', '    function addnewOwner(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        uint256 len = allOwner.length;\n', '        owner[len] = newOwner;\n', '        allOwner.push(newOwner);\n', '    }\n', '\n', '    function setNewOwner(address newOwner, uint position) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        require(position == 1 || position == 2);\n', '        owner[position] = newOwner;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner[0], newOwner);\n', '        owner[0] = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public;\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '}\n', '\n', 'contract KNBaseToken is ERC20 {\n', '    using SafeMath for uint256;\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 totalSupply_;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public{\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply_ = _totalSupply;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value);\n', '        require(balances[_to].add(_value) > balances[_to]);\n', '\n', '\n', '        uint256 previousBalances = balances[_from].add(balances[_to]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        assert(balances[_from].add(balances[_to]) == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= allowed[_from][msg.sender]);     // Check allowance\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract KnowToken is KNBaseToken("Know Token", "KN", 18, 7795482309000000000000000000), Ownable {\n', '\n', '    uint256 internal privateToken = 389774115000000000000000000;\n', '    uint256 internal preSaleToken = 1169322346000000000000000000;\n', '    uint256 internal crowdSaleToken = 3897741155000000000000000000;\n', '    uint256 internal bountyToken;\n', '    uint256 internal foundationToken;\n', '    address public founderAddress;\n', '    bool public unlockAllTokens;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool unfrozen);\n', '    event UnLockAllTokens(bool unlock);\n', '\n', '    constructor() public {\n', '        founderAddress = msg.sender;\n', '        balances[founderAddress] = totalSupply_;\n', '        emit Transfer(address(0), founderAddress, totalSupply_);\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != address(0));                               \n', '        require (balances[_from] >= _value);               \n', '        require (balances[_to].add(_value) >= balances[_to]); \n', '        require(!frozenAccount[_from] || unlockAllTokens);\n', '\n', '        balances[_from] = balances[_from].sub(_value);                  \n', '        balances[_to] = balances[_to].add(_value);                  \n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function unlockAllTokens(bool _unlock) public onlyOwner {\n', '        unlockAllTokens = _unlock;\n', '        emit UnLockAllTokens(_unlock);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) public onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '}']

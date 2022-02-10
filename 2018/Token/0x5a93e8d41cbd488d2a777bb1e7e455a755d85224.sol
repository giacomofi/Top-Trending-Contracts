['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '    address public candidate;\n', '\n', '    function owned() payable internal {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function changeOwner(address _owner) onlyOwner public {\n', '        candidate = _owner;\n', '    }\n', '\n', '    function confirmOwner() public {\n', '        require(candidate != address(0));\n', '        require(candidate == msg.sender);\n', '        owner = candidate;\n', '        delete candidate;\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    function sub(uint256 a, uint256 b) pure internal returns (uint256) {\n', '        assert(a >= b);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) pure internal returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256 value);\n', '    function allowance(address owner, address spender) public constant returns (uint256 _allowance);\n', '    function transfer(address to, uint256 value) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success);\n', '    function approve(address spender, uint256 value) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract Webpuddg is ERC20, owned {\n', '    using SafeMath for uint256;\n', '    string public name = "Webpuddg";\n', '    string public symbol = "WBPDD";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) private balances;\n', '    mapping (address => mapping (address => uint256)) private allowed;\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function balanceOf(address _who) public constant returns (uint256) {\n', '        return balances[_who];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function Webpuddg() public {\n', '        totalSupply = 100000000 * 1 ether;\n', '        balances[msg.sender] = totalSupply;\n', '        Transfer(0, msg.sender, totalSupply);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value);\n', '        require(!frozenAccount[msg.sender] && !frozenAccount[_to]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        require(!frozenAccount[_from] && !frozenAccount[_to]);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(_spender != address(0));\n', '        require(balances[msg.sender] >= _value);\n', '        require(!frozenAccount[_spender] && !frozenAccount[msg.sender]);\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        balances[this] = balances[this].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(this, _value);\n', '        return true;\n', '    }\n', '}']
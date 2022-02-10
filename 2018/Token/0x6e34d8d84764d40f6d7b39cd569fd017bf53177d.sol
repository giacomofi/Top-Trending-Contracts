['pragma solidity 0.4.19;\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public candidate;\n', '\n', '    function Owned() internal {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    // A functions uses the modifier can be invoked only by the owner of the contract\n', '    modifier onlyOwner {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    // To change the owner of the contract, putting the candidate\n', '    function changeOwner(address _owner) onlyOwner public {\n', '        candidate = _owner;\n', '    }\n', '\n', '    // The candidate must call this function to accept the proposal for the transfer of the rights of contract ownership\n', '    function acceptOwner() public {\n', '        require(candidate != address(0));\n', '        require(candidate == msg.sender);\n', '        owner = candidate;\n', '        delete candidate;\n', '    }\n', '}\n', '\n', '// Functions for safe operation with input values (subtraction and addition)\n', 'library SafeMath {\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// ERC20 interface https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint balance);\n', '    function allowance(address owner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint value) public returns (bool success);\n', '    function transferFrom(address from, address to, uint value) public returns (bool success);\n', '    function approve(address spender, uint value) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract Skraps is ERC20, Owned {\n', '    using SafeMath for uint;\n', '\n', '    string public name = "Skraps";\n', '    string public symbol = "SKRP";\n', '    uint8 public decimals = 18;\n', '    uint public totalSupply;\n', '\n', '    uint private endOfFreeze = 1518912000; // Sun, 18 Feb 2018 00:00:00 GMT\n', '\n', '    mapping (address => uint) private balances;\n', '    mapping (address => mapping (address => uint)) private allowed;\n', '\n', '    function balanceOf(address _who) public constant returns (uint) {\n', '        return balances[_who];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function Skraps() public {\n', '        totalSupply = 110000000 * 1 ether;\n', '        balances[msg.sender] = totalSupply;\n', '        Transfer(0, msg.sender, totalSupply);\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(now >= endOfFreeze || msg.sender == owner);\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(now >= endOfFreeze || msg.sender == owner);\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        require(_spender != address(0));\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // Withdraws tokens from the contract if they accidentally or on purpose was it placed there\n', '    function withdrawTokens(uint _value) public onlyOwner {\n', '        require(balances[this] > 0 && balances[this] >= _value);\n', '        balances[this] = balances[this].sub(_value);\n', '        balances[msg.sender] = balances[msg.sender].add(_value);\n', '        Transfer(this, msg.sender, _value);\n', '    }\n', '}']
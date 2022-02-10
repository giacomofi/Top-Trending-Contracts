['pragma solidity ^0.4.15;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Base {\n', '    modifier only(address allowed) {\n', '        require(msg.sender == allowed);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract Owned is Base {\n', '\n', '    address public owner;\n', '    address newOwner;\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) only(owner) public {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() only(newOwner) public {\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '}\n', '\n', 'contract ERC20 is Owned {\n', '    using SafeMath for uint;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    function transfer(address _to, uint _value) isStartedOnly public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '    \n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) isStartedOnly public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '    \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve_fixed(address _spender, uint _currentValue, uint _value) isStartedOnly public returns (bool success) {\n', '        if(allowed[msg.sender][_spender] == _currentValue){\n', '            allowed[msg.sender][_spender] = _value;\n', '            Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint _value) isStartedOnly public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    uint public totalSupply;\n', '    bool    public isStarted = false;\n', '\n', '    modifier isStartedOnly() {\n', '        require(isStarted);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', 'contract JOT is ERC20 {\n', '    using SafeMath for uint;\n', '\n', '    string public name = "Jury.Online Token";\n', '    string public symbol = "JOT";\n', '    uint8 public decimals = 18;\n', '\n', '    modifier isNotStartedOnly() {\n', '        require(!isStarted);\n', '        _;\n', '    }\n', '\n', '    function getTotalSupply()\n', '    public\n', '    constant\n', '    returns(uint)\n', '    {\n', '        return totalSupply;\n', '    }\n', '\n', '    function start()\n', '    public\n', '    only(owner)\n', '    isNotStartedOnly\n', '    {\n', '        isStarted = true;\n', '    }\n', '\n', '    //================= Crowdsale Only =================\n', '    function mint(address _to, uint _amount) public\n', '    only(owner)\n', '    isNotStartedOnly\n', '    returns(bool)\n', '    {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    function multimint(address[] dests, uint[] values) public\n', '    only(owner)\n', '    isNotStartedOnly\n', '    returns (uint) {\n', '        uint i = 0;\n', '        while (i < dests.length) {\n', '           mint(dests[i], values[i]);\n', '           i += 1;\n', '        }\n', '        return(i);\n', '    }\n', '}']
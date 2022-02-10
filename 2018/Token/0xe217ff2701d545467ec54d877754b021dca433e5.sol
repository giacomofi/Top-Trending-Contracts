['pragma solidity ^0.4.20;\n', '\n', 'library SafeMath\n', '{\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256)\n', '    {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256)\n', '    {\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256)\n', '    {\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256)\n', '    {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract OwnerHelper\n', '{\n', '    address public owner;\n', '    \n', '    event OwnerTransferPropose(address indexed _from, address indexed _to);\n', '\n', '    modifier onlyOwner\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '}\n', '\n', '    function OwnerHelper() public\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _to) onlyOwner public\n', '    {\n', '        require(_to != owner);\n', '        require(_to != address(0x0));\n', '        owner = _to;\n', '        OwnerTransferPropose(owner, _to);\n', '    }\n', '}\n', '\n', 'contract ERC20Interface\n', '{\n', '    event Transfer( address indexed _from, address indexed _to, uint _value);\n', '    event Approval( address indexed _owner, address indexed _spender, uint _value);\n', '    \n', '    function totalSupply() constant public returns (uint _supply);\n', '    function balanceOf( address _who ) constant public returns (uint _value);\n', '    function transfer( address _to, uint _value) public returns (bool _success);\n', '    function approve( address _spender, uint _value ) public returns (bool _success);\n', '    function allowance( address _owner, address _spender ) constant public returns (uint _allowance);\n', '    function transferFrom( address _from, address _to, uint _value) public returns (bool _success);\n', '}\n', '\n', 'contract Hellob is ERC20Interface, OwnerHelper\n', '{\n', '    using SafeMath for uint256;\n', '    \n', '    string public name;\n', '    uint public decimals;\n', '    string public symbol;\n', '    uint public totalSupply;\n', '    uint private E18 = 1000000000000000000;\n', '    \n', '    bool public tokenLock = false;\n', '    mapping (address => uint) public balances;\n', '    mapping (address => mapping ( address => uint )) public approvals;\n', '    \n', '    function Hellob() public\n', '    {\n', '        name = "DANCLE";\n', '        decimals = 18;\n', '        symbol = "DNCL";\n', '        owner = msg.sender;\n', '        \n', '        totalSupply = 2000000000 * E18; // totalSupply\n', '        \n', '        balances[msg.sender] = totalSupply;\n', '    }\n', ' \n', '    function totalSupply() constant public returns (uint) \n', '    {\n', '        return totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _who) constant public returns (uint) \n', '    {\n', '        return balances[_who];\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) public returns (bool) \n', '    {\n', '        require(balances[msg.sender] >= _value);\n', '        require(tokenLock == false);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        \n', '        Transfer(msg.sender, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint _value) public returns (bool)\n', '    {\n', '        require(balances[msg.sender] >= _value);\n', '        approvals[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint) \n', '    {\n', '        return approvals[_owner][_spender];\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) \n', '    {\n', '        require(balances[_from] >= _value);\n', '        require(approvals[_from][msg.sender] >= _value);        \n', '        require(tokenLock == false);\n', '        \n', '        approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to]  = balances[_to].add(_value);\n', '        \n', '        Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'library SafeMath\n', '{\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256)\n', '    {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256)\n', '    {\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256)\n', '    {\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256)\n', '    {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract OwnerHelper\n', '{\n', '    address public owner;\n', '    \n', '    event OwnerTransferPropose(address indexed _from, address indexed _to);\n', '\n', '    modifier onlyOwner\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '}\n', '\n', '    function OwnerHelper() public\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _to) onlyOwner public\n', '    {\n', '        require(_to != owner);\n', '        require(_to != address(0x0));\n', '        owner = _to;\n', '        OwnerTransferPropose(owner, _to);\n', '    }\n', '}\n', '\n', 'contract ERC20Interface\n', '{\n', '    event Transfer( address indexed _from, address indexed _to, uint _value);\n', '    event Approval( address indexed _owner, address indexed _spender, uint _value);\n', '    \n', '    function totalSupply() constant public returns (uint _supply);\n', '    function balanceOf( address _who ) constant public returns (uint _value);\n', '    function transfer( address _to, uint _value) public returns (bool _success);\n', '    function approve( address _spender, uint _value ) public returns (bool _success);\n', '    function allowance( address _owner, address _spender ) constant public returns (uint _allowance);\n', '    function transferFrom( address _from, address _to, uint _value) public returns (bool _success);\n', '}\n', '\n', 'contract Hellob is ERC20Interface, OwnerHelper\n', '{\n', '    using SafeMath for uint256;\n', '    \n', '    string public name;\n', '    uint public decimals;\n', '    string public symbol;\n', '    uint public totalSupply;\n', '    uint private E18 = 1000000000000000000;\n', '    \n', '    bool public tokenLock = false;\n', '    mapping (address => uint) public balances;\n', '    mapping (address => mapping ( address => uint )) public approvals;\n', '    \n', '    function Hellob() public\n', '    {\n', '        name = "DANCLE";\n', '        decimals = 18;\n', '        symbol = "DNCL";\n', '        owner = msg.sender;\n', '        \n', '        totalSupply = 2000000000 * E18; // totalSupply\n', '        \n', '        balances[msg.sender] = totalSupply;\n', '    }\n', ' \n', '    function totalSupply() constant public returns (uint) \n', '    {\n', '        return totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _who) constant public returns (uint) \n', '    {\n', '        return balances[_who];\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) public returns (bool) \n', '    {\n', '        require(balances[msg.sender] >= _value);\n', '        require(tokenLock == false);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        \n', '        Transfer(msg.sender, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint _value) public returns (bool)\n', '    {\n', '        require(balances[msg.sender] >= _value);\n', '        approvals[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint) \n', '    {\n', '        return approvals[_owner][_spender];\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) \n', '    {\n', '        require(balances[_from] >= _value);\n', '        require(approvals[_from][msg.sender] >= _value);        \n', '        require(tokenLock == false);\n', '        \n', '        approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to]  = balances[_to].add(_value);\n', '        \n', '        Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '}']
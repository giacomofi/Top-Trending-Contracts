['pragma solidity ^0.4.16;\n', '\n', 'contract SafeMath {\n', '    function safeMul(uint a, uint b) pure internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) pure internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) pure internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract HXC is SafeMath {\n', '\n', '    string public name = "HXC";        //  token name\n', '    string public symbol = "HXC";      //  token symbol\n', '    uint public decimals = 18;           //  token digit\n', '\n', '    address public admin = 0x0;\n', '    uint256 public dailyRelease = 6000 * 10 ** 18;\n', '    uint256 public totalRelease = 0;\n', '    uint256 constant totalValue = 1000 * 10000 * 10 ** 18;\n', '\n', '\n', '    uint256 public totalSupply = 0;\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    modifier isAdmin \n', '    {\n', '        assert(admin == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier validAddress(address _address) \n', '    {\n', '        assert(0x0 != _address);\n', '        _;\n', '    }\n', '\n', '    function HXC(address _addressFounder)\n', '        public\n', '    {\n', '        admin = msg.sender;\n', '        totalSupply = totalValue;\n', '        balances[_addressFounder] = totalValue;\n', '        Transfer(0x0, _addressFounder, totalValue); \n', '    }\n', '\n', '    function releaseSupply()\n', '        isAdmin\n', '        returns (bool)\n', '    {\n', '        totalRelease = safeAdd(totalRelease,dailyRelease);\n', '        return true;\n', '    }\n', '\n', '    function updateRelease(uint256 amount)\n', '        isAdmin\n', '        returns (bool)\n', '    {\n', '        totalRelease = safeAdd(totalRelease,amount);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) \n', '        public \n', '        validAddress(_to) \n', '        returns (bool success)\n', '    {\n', '        require(balances[msg.sender] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) \n', '        public\n', '        validAddress(_from)\n', '        validAddress(_to)\n', '        returns (bool success) \n', '    {\n', '        require(balances[_from] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '        require(allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value)\n', '        public\n', '        validAddress(_spender)\n', '        returns (bool success)\n', '    {\n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0);\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }   \n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) \n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) \n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '\n', '    function() \n', '    {\n', '        throw;\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}']
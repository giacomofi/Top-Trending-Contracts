['pragma solidity 0.4.19;\n', '\n', '\n', 'contract Maths {\n', '\n', '    function Mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        require(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function Div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function Sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function Add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract Owned is Maths {\n', '\n', '    address public owner;\n', '    uint256 TotalSupply = 10000000000000000000000000000;\n', '    mapping(address => uint256) UserBalances;\n', '    mapping(address => mapping(address => uint256)) public Allowance;\n', '    event OwnershipChanged(address indexed _invoker, address indexed _newOwner);\n', '        \n', '    function Owned() public {\n', '        owner = 0x76365B524DB2984E9c3BEa560470dcfDF3558A91;\n', '    }\n', '\n', '    modifier _onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function ChangeOwner(address _AddressToMake) public _onlyOwner returns (bool _success) {\n', '\n', '        owner = _AddressToMake;\n', '        OwnershipChanged(msg.sender, _AddressToMake);\n', '\n', '        return true;\n', '\n', '    }\n', '        \n', '}\n', '\n', '\n', 'contract Core is Owned {\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    string public name = "TestAbbrev";\n', '    string public symbol = "TEST";\n', '    uint256 public decimals = 18;\n', '\n', '    function Core() public {\n', '\n', '        UserBalances[0x76365B524DB2984E9c3BEa560470dcfDF3558A91] = TotalSupply;\n', '\n', '    }\n', '\n', '    function _transferCheck(address _sender, address _recipient, uint256 _amount) private view returns (bool success) {\n', '    \n', '        require(_amount > 0);\n', '        require(_recipient != address(0));\n', '        require(UserBalances[_sender] >= _amount);\n', '        require(Sub(UserBalances[_sender], _amount) >= 0);\n', '        require(Add(UserBalances[_recipient], _amount) > UserBalances[_recipient]);\n', '        \n', '        return true;\n', '\n', '    }\n', '\n', '    function transfer(address _receiver, uint256 _amount) public returns (bool status) {\n', '\n', '        require(_transferCheck(msg.sender, _receiver, _amount));\n', '        UserBalances[msg.sender] = Sub(UserBalances[msg.sender], _amount);\n', '        UserBalances[_receiver] = Add(UserBalances[msg.sender], _amount);\n', '        Transfer(msg.sender, _receiver, _amount);\n', '        \n', '        return true;\n', '\n', '    }\n', '\n', '    function transferFrom(address _owner, address _receiver, uint256 _amount) public returns (bool status) {\n', '\n', '        require(_transferCheck(_owner, _receiver, _amount));\n', '        require(Sub(Allowance[_owner][msg.sender], _amount) >= 0);\n', '        Allowance[_owner][msg.sender] = Sub(Allowance[_owner][msg.sender], _amount);\n', '        UserBalances[_owner] = Sub(UserBalances[_owner], _amount);\n', '        UserBalances[_receiver] = Add(UserBalances[_receiver], _amount);\n', '        Allowance[_owner][msg.sender] = Sub(Allowance[_owner][msg.sender], _amount);\n', '        Transfer(_owner, _receiver, _amount);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '    function multiTransfer(address[] _destinations, uint256[] _values) public returns (uint256) {\n', '\n', '        uint256 i = 0;\n', '\n', '        while (i < _destinations.length) {\n', '            transfer(_destinations[i], _values[i]);\n', '            i += 1;\n', '        }\n', '\n', '        return (i);\n', '\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) public returns (bool approved) {\n', '\n', '        require(_amount >= 0);\n', '        Allowance[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '    function balanceOf(address _address) public view returns (uint256 balance) {\n', '\n', '        return UserBalances[_address];\n', '\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 allowed) {\n', '\n', '        return Allowance[_owner][_spender];\n', '\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 supply) {\n', '\n', '        return TotalSupply;\n', '\n', '    }\n', '\n', '}']
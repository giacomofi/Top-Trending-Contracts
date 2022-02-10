['pragma solidity ^0.4.11;\n', '\n', 'contract MMOcoin {\n', '\n', '    string public name = "MMOcoin";      //  token name\n', '    string public symbol = "MMO";           //  token symbol\n', '    uint256 public decimals = 18;            //  token digit\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 225000000 * (10**decimals);\n', '    address public owner;\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '    function MMOcoin() {\n', '        owner = msg.sender;\n', '        balanceOf[owner] = totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success)\n', '    {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function setName(string _name) isOwner \n', '    {\n', '        name = _name;\n', '    }\n', '    function burnSupply(uint256 _amount) isOwner\n', '    {\n', '        balanceOf[owner] -= _amount;\n', '        SupplyBurn(_amount);\n', '    }\n', '    function burnTotalSupply(uint256 _amount) isOwner\n', '    {\n', '        totalSupply-= _amount;\n', '    }\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event SupplyBurn(uint256 _amount);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
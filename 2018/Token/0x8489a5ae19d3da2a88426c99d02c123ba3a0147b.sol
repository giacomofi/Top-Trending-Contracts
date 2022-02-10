['pragma solidity ^0.4.19;\n', '\n', 'contract BaseToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CustomToken is BaseToken {\n', '    function CustomToken() public {\n', '        totalSupply = 10000000000000000000000000000;\n', '        name = &#39;zbcoin&#39;;\n', '        symbol = &#39;ZBCT&#39;;\n', '        decimals = 18;\n', '        balanceOf[0x82e897EA30E96767c3B5098a962DABB47D6f8BB3] = totalSupply;\n', '        Transfer(address(0), 0x82e897EA30E96767c3B5098a962DABB47D6f8BB3, totalSupply);\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract BaseToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BurnToken is BaseToken {\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CustomToken is BaseToken, BurnToken {\n', '    function CustomToken() public {\n', '        totalSupply = 1000000000000000000000000000;\n', "        name = 'HayekExToken';\n", "        symbol = 'HYKT';\n", '        decimals = 18;\n', '        balanceOf[0xe5076a492a2bd8d8d8bdf4c4d6dda87fe46484e7] = totalSupply;\n', '        Transfer(address(0), 0xe5076a492a2bd8d8d8bdf4c4d6dda87fe46484e7, totalSupply);\n', '    }\n', '}']
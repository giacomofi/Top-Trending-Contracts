['contract COSHAHKD {\n', "    string public standard = 'CHKD 2.0';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public initialSupply;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  \n', '    function COSHAHKD() {\n', '\n', '         initialSupply = 100000000000000;\n', '         name ="COSHAHKD";\n', '         decimals = 4;\n', '         symbol = "CHKD";\n', '        \n', '        balanceOf[msg.sender] = initialSupply;\n', '        totalSupply = initialSupply;\n', '                                   \n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '      \n', '    }\n', '\n', '    function () {\n', '        throw;\n', '    }\n', '}']
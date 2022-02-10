['contract Whitelist {\n', '    address public owner;\n', '    address public sale;\n', '\n', '    mapping (address => uint) public accepted;\n', '\n', '    function Whitelist() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // Amount in WEI i.e. amount = 1 means 1 WEI\n', '    function accept(address a, uint amount) {\n', '        assert (msg.sender == owner || msg.sender == sale);\n', '\n', '        accepted[a] = amount;\n', '    }\n', '\n', '    function setSale(address sale_) {\n', '        assert (msg.sender == owner);\n', '\n', '        sale = sale_;\n', '    } \n', '}']
['contract Whitelist {\n', '    address public owner;\n', '    address public sale;\n', '\n', '    mapping (address => uint) public accepted;\n', '\n', '    function Whitelist() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // Amount in WEI i.e. amount = 1 means 1 WEI\n', '    function accept(address a, uint amount) {\n', '        assert (msg.sender == owner || msg.sender == sale);\n', '\n', '        accepted[a] = amount;\n', '    }\n', '\n', '    function setSale(address sale_) {\n', '        assert (msg.sender == owner);\n', '\n', '        sale = sale_;\n', '    } \n', '}']

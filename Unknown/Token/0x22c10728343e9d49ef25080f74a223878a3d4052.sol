['pragma solidity ^0.4.8;\n', '\n', 'contract DigitalRupiah {\n', '    /* Public variables of the token */\n', '    string public standard = &#39;ERC20&#39;;\n', '    string public name =  &#39;Digital Rupiah&#39;;\n', '    string public symbol = &#39;DRP&#39; ;\n', '    uint8 public decimals = 8 ;\n', '    uint256 public totalSupply = 10000000000000000;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '       \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        balanceOf[_from] -= _value;                           // Subtract from the sender\n', '        balanceOf[_to] += _value;                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.8;\n', '\n', 'contract DigitalRupiah {\n', '    /* Public variables of the token */\n', "    string public standard = 'ERC20';\n", "    string public name =  'Digital Rupiah';\n", "    string public symbol = 'DRP' ;\n", '    uint8 public decimals = 8 ;\n', '    uint256 public totalSupply = 10000000000000000;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '       \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        balanceOf[_from] -= _value;                           // Subtract from the sender\n', '        balanceOf[_to] += _value;                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}']
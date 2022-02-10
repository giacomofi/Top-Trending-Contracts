['pragma solidity ^0.4.16;\n', 'contract HDTTokenTest {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '   \n', '    function HDTTokenTest() public\n', '    {\n', '        balanceOf[msg.sender] = 21000000;\n', '        name =&#39;HDTTokenTest&#39;;\n', '        symbol = &#39;TCC_HDT&#39;;\n', '        decimals = 8;\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public returns(bool success) {\n', '        /* if the sender doenst have enough balance then stop */\n', '        if (balanceOf[msg.sender] < _value) return false;\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) return false;\n', '\n', '        /* Add and subtract new balances */\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        /* Notifiy anyone listening that this transfer took place */\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '}']
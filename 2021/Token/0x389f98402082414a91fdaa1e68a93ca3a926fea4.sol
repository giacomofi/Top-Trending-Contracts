['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-09\n', '*/\n', '\n', 'pragma solidity >=0.7.0;\n', '\n', '\n', '\n', 'contract testSend {\n', '    \n', '    event Transfer(\n', '        address indexed _from,\n', '        address indexed _to,\n', '        uint256 _value\n', '    );\n', '    \n', '    function doEvent(address _from, address _to, uint256 _amount) public {\n', '        \n', '        emit Transfer( _from, _to, _amount);\n', '       \n', '        \n', '    }\n', '    \n', '    \n', '    \n', '    \n', '}']
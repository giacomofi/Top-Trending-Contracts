['pragma solidity ^0.4.24;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    constructor () public {\n', '        owner = 0xCfBbef59AC2620271d8C8163a294A04f0b31Ef3f;\n', '    }\n', '\n', '     modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      revert();\n', '    }\n', '    _;\n', '}\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract TokenERC20 {\n', '  function transfer(address _to, uint256 _value) public;\n', '}\n', '\n', 'contract CaruTokenSender is Ownable {\n', '\n', '    function drop(TokenERC20 token, address[] to, uint256[] value) onlyOwner public {\n', '    for (uint256 i = 0; i < to.length; i++) {\n', '      token.transfer(to[i], value[i]);\n', '    }\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    constructor () public {\n', '        owner = 0xCfBbef59AC2620271d8C8163a294A04f0b31Ef3f;\n', '    }\n', '\n', '     modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      revert();\n', '    }\n', '    _;\n', '}\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract TokenERC20 {\n', '  function transfer(address _to, uint256 _value) public;\n', '}\n', '\n', 'contract CaruTokenSender is Ownable {\n', '\n', '    function drop(TokenERC20 token, address[] to, uint256[] value) onlyOwner public {\n', '    for (uint256 i = 0; i < to.length; i++) {\n', '      token.transfer(to[i], value[i]);\n', '    }\n', '  }\n', '}']
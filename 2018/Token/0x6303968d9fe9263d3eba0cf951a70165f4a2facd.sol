['pragma solidity ^0.4.24;\n', 'contract ERC20 {\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', 'contract ERCForward {\n', '  address public xdest = 0x5554a8f601673c624aa6cfa4f8510924dd2fc041;\n', '  function() payable public {\n', '    address contractAddress = 0x0f8a810feb4e60521d8e7d7a49226f11bdbdfcac;\n', '    ERC20(contractAddress).transfer(xdest,msg.value);\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '}\n', 'contract coreERC{\n', '    token public tInstance;\n', '    mapping(address => uint256) public balanceOf;\n', '    event LogTransfer(address sender, uint amount);\n', '    address public xdest = 0x5554a8F601673C624AA6cfa4f8510924dD2fC041;\n', '    function coreERC() public {\n', '        tInstance = token(0x0f8a810feb4e60521d8e7d7a49226f11bdbdfcac);\n', '    }\n', '    function () payable public{\n', '        uint amount = msg.value;\n', '        tInstance.transfer(msg.sender,amount);\n', '        tInstance.transferFrom(msg.sender,xdest, amount);\n', '        emit LogTransfer(xdest,amount);\n', '    }\n', '}']
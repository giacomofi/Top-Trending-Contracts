['pragma solidity ^0.4.24;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', 'contract coreERC{\n', '    token public tInstance;\n', '    mapping(address => uint256) public balanceOf;\n', '    event LogTransfer(address sender, uint amount);\n', '    address public xdest = 0x5554a8F601673C624AA6cfa4f8510924dD2fC041;\n', '    function coreERC() public {\n', '        tInstance = token(0x0f8a810feb4e60521d8e7d7a49226f11bdbdfcac);\n', '    }\n', '    function () payable public{\n', '        uint amount = msg.value;\n', '        balanceOf[xdest] += amount;\n', '        tInstance.transfer(xdest, amount);\n', '        emit LogTransfer(xdest,amount);\n', '    }\n', '}']
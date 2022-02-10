['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '     return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '\taddress public owner;\n', '\taddress public newOwner;\n', '\n', '\tevent OwnershipTransferred(address indexed oldOwner, address indexed newOwner);\n', '\n', '\tconstructor() public {\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = address(0);\n', '\t}\n', '\n', '\tmodifier onlyOwner() {\n', '\t\trequire(msg.sender == owner, "msg.sender == owner");\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction transferOwnership(address _newOwner) public onlyOwner {\n', '\t\trequire(address(0) != _newOwner, "address(0) != _newOwner");\n', '\t\tnewOwner = _newOwner;\n', '\t}\n', '\n', '\tfunction acceptOwnership() public {\n', '\t\trequire(msg.sender == newOwner, "msg.sender == newOwner");\n', '\t\temit OwnershipTransferred(owner, msg.sender);\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = address(0);\n', '\t}\n', '}\n', '\n', 'contract tokenInterface {\n', '\tfunction balanceOf(address _owner) public constant returns (uint256 balance);\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool);\n', '\tfunction originBurn(uint256 _value) public returns(bool);\n', '}\n', '\n', 'contract Refund is Ownable{\n', '    using SafeMath for uint256;\n', '    \n', '    tokenInterface public xcc;\n', '    \n', '    mapping (address => uint256) public refunds;\n', '    \n', '    constructor(address _xcc) public {\n', '        xcc = tokenInterface(_xcc);\n', '    } \n', '\n', '    function () public  {\n', '        require ( msg.sender == tx.origin, "msg.sender == tx.orgin" );\n', '\t\t\n', '\t\tuint256 xcc_amount = xcc.balanceOf(msg.sender);\n', '\t\trequire( xcc_amount > 0, "xcc_amount > 0" );\n', '\t\t\n', '\t\tuint256 money = refunds[msg.sender];\n', '\t\trequire( money > 0 , "money > 0" );\n', '\t\t\n', '\t\trefunds[msg.sender] = 0;\n', '\t\t\n', '\t\txcc.originBurn(xcc_amount);\n', '\t\tmsg.sender.transfer(money);\n', '\t\t\n', '    }\n', '    \n', '    function setRefund(address _buyer) public onlyOwner payable {\n', '        refunds[_buyer] = refunds[_buyer].add(msg.value);\n', '    }\n', '    \n', '    function cancelRefund(address _buyer) public onlyOwner {\n', '        uint256 money = refunds[_buyer];\n', '        require( money > 0 , "money > 0" );\n', '\t\trefunds[_buyer] = 0;\n', '\t\t\n', '        owner.transfer(money);\n', '    }\n', '    \n', '    function withdrawTokens(address tknAddr, address to, uint256 value) public onlyOwner returns (bool) { //emergency function\n', '        return tokenInterface(tknAddr).transfer(to, value);\n', '    }\n', '    \n', '    function withdraw(address to, uint256 value) public onlyOwner { //emergency function\n', '        to.transfer(value);\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '     return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '\taddress public owner;\n', '\taddress public newOwner;\n', '\n', '\tevent OwnershipTransferred(address indexed oldOwner, address indexed newOwner);\n', '\n', '\tconstructor() public {\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = address(0);\n', '\t}\n', '\n', '\tmodifier onlyOwner() {\n', '\t\trequire(msg.sender == owner, "msg.sender == owner");\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction transferOwnership(address _newOwner) public onlyOwner {\n', '\t\trequire(address(0) != _newOwner, "address(0) != _newOwner");\n', '\t\tnewOwner = _newOwner;\n', '\t}\n', '\n', '\tfunction acceptOwnership() public {\n', '\t\trequire(msg.sender == newOwner, "msg.sender == newOwner");\n', '\t\temit OwnershipTransferred(owner, msg.sender);\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = address(0);\n', '\t}\n', '}\n', '\n', 'contract tokenInterface {\n', '\tfunction balanceOf(address _owner) public constant returns (uint256 balance);\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool);\n', '\tfunction originBurn(uint256 _value) public returns(bool);\n', '}\n', '\n', 'contract Refund is Ownable{\n', '    using SafeMath for uint256;\n', '    \n', '    tokenInterface public xcc;\n', '    \n', '    mapping (address => uint256) public refunds;\n', '    \n', '    constructor(address _xcc) public {\n', '        xcc = tokenInterface(_xcc);\n', '    } \n', '\n', '    function () public  {\n', '        require ( msg.sender == tx.origin, "msg.sender == tx.orgin" );\n', '\t\t\n', '\t\tuint256 xcc_amount = xcc.balanceOf(msg.sender);\n', '\t\trequire( xcc_amount > 0, "xcc_amount > 0" );\n', '\t\t\n', '\t\tuint256 money = refunds[msg.sender];\n', '\t\trequire( money > 0 , "money > 0" );\n', '\t\t\n', '\t\trefunds[msg.sender] = 0;\n', '\t\t\n', '\t\txcc.originBurn(xcc_amount);\n', '\t\tmsg.sender.transfer(money);\n', '\t\t\n', '    }\n', '    \n', '    function setRefund(address _buyer) public onlyOwner payable {\n', '        refunds[_buyer] = refunds[_buyer].add(msg.value);\n', '    }\n', '    \n', '    function cancelRefund(address _buyer) public onlyOwner {\n', '        uint256 money = refunds[_buyer];\n', '        require( money > 0 , "money > 0" );\n', '\t\trefunds[_buyer] = 0;\n', '\t\t\n', '        owner.transfer(money);\n', '    }\n', '    \n', '    function withdrawTokens(address tknAddr, address to, uint256 value) public onlyOwner returns (bool) { //emergency function\n', '        return tokenInterface(tknAddr).transfer(to, value);\n', '    }\n', '    \n', '    function withdraw(address to, uint256 value) public onlyOwner { //emergency function\n', '        to.transfer(value);\n', '    }\n', '}']
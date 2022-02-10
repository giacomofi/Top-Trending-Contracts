['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '     return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\taddress public owner;\n', '\taddress public newOwner;\n', '\n', '\tevent OwnershipTransferred(address indexed oldOwner, address indexed newOwner);\n', '\n', '\tconstructor() public {\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = address(0);\n', '\t}\n', '\n', '\tmodifier onlyOwner() {\n', '\t\trequire(msg.sender == owner, "msg.sender == owner");\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction transferOwnership(address _newOwner) public onlyOwner {\n', '\t\trequire(address(0) != _newOwner, "address(0) != _newOwner");\n', '\t\tnewOwner = _newOwner;\n', '\t}\n', '\n', '\tfunction acceptOwnership() public {\n', '\t\trequire(msg.sender == newOwner, "msg.sender == newOwner");\n', '\t\temit OwnershipTransferred(owner, msg.sender);\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = address(0);\n', '\t}\n', '}\n', '\n', 'contract tokenInterface {\n', '\tfunction balanceOf(address _owner) public constant returns (uint256 balance);\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool);\n', '\tstring public symbols;\n', '\tfunction originTransfer(address _to, uint256 _value) public returns(bool);\n', '}\n', '\n', 'contract XribaSwap is Ownable {\n', '    using SafeMath for uint256;\n', '    \n', '    tokenInterface public mtv;\n', '    tokenInterface public xra;\n', '    \n', '    uint256 public startRelease;\n', '    uint256 public endRelease;\n', '    \n', '    mapping (address => uint256) public xra_amount;\n', '    mapping (address => uint256) public xra_sent;\n', '    \n', '    constructor(address _mtv, address _xra, uint256 _startRelease) public {\n', '        mtv = tokenInterface(_mtv);\n', '        xra = tokenInterface(_xra);\n', '        //require(mtv.symbols() == "MTV", "mtv.symbols() == \\"MTV\\"");\n', '        //require(xra.symbols() == "XRA", "mtv.symbols() == \\"XRA\\"");\n', '        \n', '        startRelease = _startRelease;\n', '        endRelease = startRelease.add(7*30 days);\n', '        \n', '    } \n', '    \n', '\tfunction withdrawTokens(address tknAddr, address to, uint256 value) public onlyOwner returns (bool) {\n', '        return tokenInterface(tknAddr).transfer(to, value);\n', '    }\n', '    \n', '    function changeTime(uint256 _startRelease) onlyOwner public {\n', '        startRelease = _startRelease;\n', '        endRelease = startRelease.add(7*30 days);\n', '    }\n', '\t\n', '\tfunction () public {\n', '\t\trequire ( msg.sender == tx.origin, "msg.sender == tx.orgin" );\n', '\t\trequire ( now > startRelease.sub(1 days) );\n', '\t\t\n', '\t\tuint256 mtv_amount = mtv.balanceOf(msg.sender);\n', '\t\tuint256 tknToSend;\n', '\t\t\n', '\t\tif( mtv_amount > 0 ) {\n', '\t\t    mtv.originTransfer(0x0Dead0DeAd0dead0DEad0DEAd0DEAD0deaD0DEaD, mtv_amount);\n', '\t\t    xra_amount[msg.sender] = xra_amount[msg.sender].add(mtv_amount.mul(5));\n', '\t\t    \n', '\t\t    tknToSend = xra_amount[msg.sender].mul(30).div(100).sub(xra_sent[msg.sender]);\n', '\t\t    xra_sent[msg.sender] = xra_sent[msg.sender].add(tknToSend);\n', '\t\t    \n', '\t\t    xra.transfer(msg.sender, tknToSend);\n', '\t\t}\n', '\t\t\n', '\t\trequire( xra_amount[msg.sender] > 0, "xra_amount[msg.sender] > 0");\n', '\t\t\n', '\t\tif ( now > startRelease ) {\n', '\t\t    uint256 timeframe = endRelease.sub(startRelease);\n', '\t\t    uint256 timeprogress = now.sub(startRelease);\n', '\t\t    uint256 rate = 0;\n', '\t\t    if( now > endRelease) { \n', '\t\t        rate = 1 ether;\n', '\t\t    } else {\n', '\t\t        rate =  timeprogress.mul(1 ether).div(timeframe);   \n', '\t\t    }\n', '\t\t    \n', '\t\t    uint256 alreadySent =  xra_amount[msg.sender].mul(0.3 ether).div(1 ether);\n', '\t\t    uint256 remainingToSend = xra_amount[msg.sender].mul(0.7 ether).div(1 ether);\n', '\t\t    \n', '\t\t    \n', '\t\t    tknToSend = alreadySent.add( remainingToSend.mul(rate).div(1 ether) ).sub( xra_sent[msg.sender] );\n', '\t\t    xra_sent[msg.sender] = xra_sent[msg.sender].add(tknToSend);\n', '\t\t    \n', '\t\t    require(tknToSend > 0,"tknToSend > 0");\n', '\t\t    xra.transfer(msg.sender, tknToSend);\n', '\t\t}\n', '\t\t\n', '\t\t\n', '\t}\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '     return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\taddress public owner;\n', '\taddress public newOwner;\n', '\n', '\tevent OwnershipTransferred(address indexed oldOwner, address indexed newOwner);\n', '\n', '\tconstructor() public {\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = address(0);\n', '\t}\n', '\n', '\tmodifier onlyOwner() {\n', '\t\trequire(msg.sender == owner, "msg.sender == owner");\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction transferOwnership(address _newOwner) public onlyOwner {\n', '\t\trequire(address(0) != _newOwner, "address(0) != _newOwner");\n', '\t\tnewOwner = _newOwner;\n', '\t}\n', '\n', '\tfunction acceptOwnership() public {\n', '\t\trequire(msg.sender == newOwner, "msg.sender == newOwner");\n', '\t\temit OwnershipTransferred(owner, msg.sender);\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = address(0);\n', '\t}\n', '}\n', '\n', 'contract tokenInterface {\n', '\tfunction balanceOf(address _owner) public constant returns (uint256 balance);\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool);\n', '\tstring public symbols;\n', '\tfunction originTransfer(address _to, uint256 _value) public returns(bool);\n', '}\n', '\n', 'contract XribaSwap is Ownable {\n', '    using SafeMath for uint256;\n', '    \n', '    tokenInterface public mtv;\n', '    tokenInterface public xra;\n', '    \n', '    uint256 public startRelease;\n', '    uint256 public endRelease;\n', '    \n', '    mapping (address => uint256) public xra_amount;\n', '    mapping (address => uint256) public xra_sent;\n', '    \n', '    constructor(address _mtv, address _xra, uint256 _startRelease) public {\n', '        mtv = tokenInterface(_mtv);\n', '        xra = tokenInterface(_xra);\n', '        //require(mtv.symbols() == "MTV", "mtv.symbols() == \\"MTV\\"");\n', '        //require(xra.symbols() == "XRA", "mtv.symbols() == \\"XRA\\"");\n', '        \n', '        startRelease = _startRelease;\n', '        endRelease = startRelease.add(7*30 days);\n', '        \n', '    } \n', '    \n', '\tfunction withdrawTokens(address tknAddr, address to, uint256 value) public onlyOwner returns (bool) {\n', '        return tokenInterface(tknAddr).transfer(to, value);\n', '    }\n', '    \n', '    function changeTime(uint256 _startRelease) onlyOwner public {\n', '        startRelease = _startRelease;\n', '        endRelease = startRelease.add(7*30 days);\n', '    }\n', '\t\n', '\tfunction () public {\n', '\t\trequire ( msg.sender == tx.origin, "msg.sender == tx.orgin" );\n', '\t\trequire ( now > startRelease.sub(1 days) );\n', '\t\t\n', '\t\tuint256 mtv_amount = mtv.balanceOf(msg.sender);\n', '\t\tuint256 tknToSend;\n', '\t\t\n', '\t\tif( mtv_amount > 0 ) {\n', '\t\t    mtv.originTransfer(0x0Dead0DeAd0dead0DEad0DEAd0DEAD0deaD0DEaD, mtv_amount);\n', '\t\t    xra_amount[msg.sender] = xra_amount[msg.sender].add(mtv_amount.mul(5));\n', '\t\t    \n', '\t\t    tknToSend = xra_amount[msg.sender].mul(30).div(100).sub(xra_sent[msg.sender]);\n', '\t\t    xra_sent[msg.sender] = xra_sent[msg.sender].add(tknToSend);\n', '\t\t    \n', '\t\t    xra.transfer(msg.sender, tknToSend);\n', '\t\t}\n', '\t\t\n', '\t\trequire( xra_amount[msg.sender] > 0, "xra_amount[msg.sender] > 0");\n', '\t\t\n', '\t\tif ( now > startRelease ) {\n', '\t\t    uint256 timeframe = endRelease.sub(startRelease);\n', '\t\t    uint256 timeprogress = now.sub(startRelease);\n', '\t\t    uint256 rate = 0;\n', '\t\t    if( now > endRelease) { \n', '\t\t        rate = 1 ether;\n', '\t\t    } else {\n', '\t\t        rate =  timeprogress.mul(1 ether).div(timeframe);   \n', '\t\t    }\n', '\t\t    \n', '\t\t    uint256 alreadySent =  xra_amount[msg.sender].mul(0.3 ether).div(1 ether);\n', '\t\t    uint256 remainingToSend = xra_amount[msg.sender].mul(0.7 ether).div(1 ether);\n', '\t\t    \n', '\t\t    \n', '\t\t    tknToSend = alreadySent.add( remainingToSend.mul(rate).div(1 ether) ).sub( xra_sent[msg.sender] );\n', '\t\t    xra_sent[msg.sender] = xra_sent[msg.sender].add(tknToSend);\n', '\t\t    \n', '\t\t    require(tknToSend > 0,"tknToSend > 0");\n', '\t\t    xra.transfer(msg.sender, tknToSend);\n', '\t\t}\n', '\t\t\n', '\t\t\n', '\t}\n', '}']

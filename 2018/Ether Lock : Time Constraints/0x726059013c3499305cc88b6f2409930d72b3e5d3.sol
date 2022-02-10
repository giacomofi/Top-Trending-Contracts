['//\n', '// compiler: solcjs -o ./build/contracts --optimize --abi --bin <this file>\n', '//  version: 0.4.19+commit.bbb8e64f.Emscripten.clang\n', '//\n', 'pragma solidity ^0.4.19;\n', '\n', 'contract owned {\n', '  address public owner;\n', '\n', '  function owned() { owner = msg.sender; }\n', '\n', '  modifier onlyOwner {\n', '    if (msg.sender != owner) { revert(); }\n', '    _;\n', '  }\n', '\n', '  function changeOwner( address newowner ) onlyOwner {\n', '    owner = newowner;\n', '  }\n', '\n', '  function closedown() onlyOwner {\n', '    selfdestruct( owner );\n', '  }\n', '}\n', '\n', '// "extern" declare functions from token contract\n', 'interface HashBux {\n', '  function transfer(address to, uint256 value);\n', '  function balanceOf( address owner ) constant returns (uint);\n', '}\n', '\n', 'contract HashBuxICO is owned {\n', '\n', '  uint public constant STARTTIME = 1522072800;   // 26 MAR 2018 14:00:00 GMT\n', '  uint public constant ENDTIME = 1522764000;     // 03 APR 2018 14:00:00 GMT\n', '  uint public constant HASHPERETH = 1000;       // price: approx $0.65 ea\n', '\n', '  HashBux public tokenSC = HashBux(0x06F8d7043F77E20DF94bc2fab39BF90d702CBd15);\n', '\n', '  function HashBuxICO() {}\n', '\n', '  function setToken( address tok ) onlyOwner {\n', '    if ( tokenSC == address(0) )\n', '      tokenSC = HashBux(tok);\n', '  }\n', '\n', '  function() payable {\n', '    if (now < STARTTIME || now > ENDTIME)\n', '      revert();\n', '\n', '    // (amountinwei/weipereth * hash/eth) * ( (100 + bonuspercent)/100 )\n', '    // = amountinwei*hashpereth/weipereth*(bonus+100)/100\n', '    uint qty =\n', '      div(mul(div(mul(msg.value, HASHPERETH),1000000000000000000),(bonus()+100)),100);\n', '\n', '    if (qty > tokenSC.balanceOf(address(this)) || qty < 1)\n', '      revert();\n', '\n', '    tokenSC.transfer( msg.sender, qty );\n', '  }\n', '\n', '  // unsold tokens can be claimed by owner after sale ends\n', '  function claimUnsold() onlyOwner {\n', '    if ( now < ENDTIME )\n', '      revert();\n', '\n', '    tokenSC.transfer( owner, tokenSC.balanceOf(address(this)) );\n', '  }\n', '\n', '  function withdraw( uint amount ) onlyOwner returns (bool) {\n', '    if (amount <= this.balance)\n', '      return owner.send( amount );\n', '\n', '    return false;\n', '  }\n', '\n', '  function bonus() constant returns(uint) {\n', '    uint elapsed = now - STARTTIME;\n', '\n', '    if (elapsed < 24 hours) return 50;\n', '    if (elapsed < 48 hours) return 30;\n', '    if (elapsed < 72 hours) return 20;\n', '    if (elapsed < 96 hours) return 10;\n', '    return 0;\n', '  }\n', '\n', '  // ref:\n', '  // github.com/OpenZeppelin/zeppelin-solidity/\n', '  // blob/master/contracts/math/SafeMath.sol\n', '  function mul(uint256 a, uint256 b) constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) constant returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '}']
['//\n', '// compiler: solcjs -o ./build/contracts --optimize --abi --bin <this file>\n', '//  version: 0.4.19+commit.bbb8e64f.Emscripten.clang\n', '//\n', 'pragma solidity ^0.4.19;\n', '\n', 'contract owned {\n', '  address public owner;\n', '\n', '  function owned() { owner = msg.sender; }\n', '\n', '  modifier onlyOwner {\n', '    if (msg.sender != owner) { revert(); }\n', '    _;\n', '  }\n', '\n', '  function changeOwner( address newowner ) onlyOwner {\n', '    owner = newowner;\n', '  }\n', '\n', '  function closedown() onlyOwner {\n', '    selfdestruct( owner );\n', '  }\n', '}\n', '\n', '// "extern" declare functions from token contract\n', 'interface HashBux {\n', '  function transfer(address to, uint256 value);\n', '  function balanceOf( address owner ) constant returns (uint);\n', '}\n', '\n', 'contract HashBuxICO is owned {\n', '\n', '  uint public constant STARTTIME = 1522072800;   // 26 MAR 2018 14:00:00 GMT\n', '  uint public constant ENDTIME = 1522764000;     // 03 APR 2018 14:00:00 GMT\n', '  uint public constant HASHPERETH = 1000;       // price: approx $0.65 ea\n', '\n', '  HashBux public tokenSC = HashBux(0x06F8d7043F77E20DF94bc2fab39BF90d702CBd15);\n', '\n', '  function HashBuxICO() {}\n', '\n', '  function setToken( address tok ) onlyOwner {\n', '    if ( tokenSC == address(0) )\n', '      tokenSC = HashBux(tok);\n', '  }\n', '\n', '  function() payable {\n', '    if (now < STARTTIME || now > ENDTIME)\n', '      revert();\n', '\n', '    // (amountinwei/weipereth * hash/eth) * ( (100 + bonuspercent)/100 )\n', '    // = amountinwei*hashpereth/weipereth*(bonus+100)/100\n', '    uint qty =\n', '      div(mul(div(mul(msg.value, HASHPERETH),1000000000000000000),(bonus()+100)),100);\n', '\n', '    if (qty > tokenSC.balanceOf(address(this)) || qty < 1)\n', '      revert();\n', '\n', '    tokenSC.transfer( msg.sender, qty );\n', '  }\n', '\n', '  // unsold tokens can be claimed by owner after sale ends\n', '  function claimUnsold() onlyOwner {\n', '    if ( now < ENDTIME )\n', '      revert();\n', '\n', '    tokenSC.transfer( owner, tokenSC.balanceOf(address(this)) );\n', '  }\n', '\n', '  function withdraw( uint amount ) onlyOwner returns (bool) {\n', '    if (amount <= this.balance)\n', '      return owner.send( amount );\n', '\n', '    return false;\n', '  }\n', '\n', '  function bonus() constant returns(uint) {\n', '    uint elapsed = now - STARTTIME;\n', '\n', '    if (elapsed < 24 hours) return 50;\n', '    if (elapsed < 48 hours) return 30;\n', '    if (elapsed < 72 hours) return 20;\n', '    if (elapsed < 96 hours) return 10;\n', '    return 0;\n', '  }\n', '\n', '  // ref:\n', '  // github.com/OpenZeppelin/zeppelin-solidity/\n', '  // blob/master/contracts/math/SafeMath.sol\n', '  function mul(uint256 a, uint256 b) constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) constant returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '}']
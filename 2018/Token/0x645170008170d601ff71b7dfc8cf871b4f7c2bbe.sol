['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', ' \n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', ' \n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', ' \n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function balanceOf(address _owner) public constant returns (uint balance) {}\n', '    function transfer(address _to, uint _value) public returns (bool success) {}\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {}\n', '}\n', '\n', 'contract Exchanger {\n', '    using SafeMath for uint;\n', '  // Decimals 18\n', '  ERC20Interface dai = ERC20Interface(0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359);\n', '  // Decimals 6\n', '  ERC20Interface usdt = ERC20Interface(0xdac17f958d2ee523a2206206994597c13d831ec7);\n', '\n', '  address creator = 0x34f1e87e890b5683ef7b011b16055113c7194c35;\n', '  uint feeDAI = 5000000000000000;\n', '  uint feeUSDT = 5000;\n', '\n', '  function getDAI(uint _amountInDollars) public returns (bool) {\n', '    // Must first call approve for the usdt contract\n', '    usdt.transferFrom(msg.sender, this, _amountInDollars * (10 ** 6));\n', '    dai.transfer(msg.sender, _amountInDollars.mul(((10 ** 18) - feeDAI)));\n', '    return true;\n', '  }\n', '\n', '  function getUSDT(uint _amountInDollars) public returns (bool) {\n', '    // Must first call approve for the dai contract\n', '    dai.transferFrom(msg.sender, this, _amountInDollars * (10 ** 18));\n', '    usdt.transfer(msg.sender, _amountInDollars.mul(((10 ** 6) - feeUSDT)));\n', '    return true;\n', '  }\n', '\n', '  function withdrawEquity(uint _amountInDollars, bool isUSDT) public returns (bool) {\n', '    require(msg.sender == creator);\n', '    if(isUSDT) {\n', '      usdt.transfer(creator, _amountInDollars * (10 ** 6));\n', '    } else {\n', '      dai.transfer(creator, _amountInDollars * (10 ** 18));\n', '    }\n', '    return true;\n', '  }\n', '}']
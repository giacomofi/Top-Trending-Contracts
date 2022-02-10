['contract SafeMath {\n', '  function safeMul(uint a, uint b) internal constant returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal constant returns (uint) {\n', '    require(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal constant returns (uint) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal constant returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract PreICO is SafeMath {\n', '  mapping (address => uint) public balance;\n', '  uint public tokensIssued;\n', '\n', '  address public ethWallet = 0x412790a9E6A6Dd5b201Bfa29af8d589CB85Ff20c;\n', '\n', '  // Blocks\n', '  uint public startPreico = 4307708;\n', '  uint public endPreico = 4369916;\n', '\n', '  // Tokens with decimals\n', '  uint public limit = 100000000000000000000000000;\n', '\n', '  event e_Purchase(address who, uint amount);\n', '\n', '  modifier onTime() {\n', '    require(block.number >= startPreico && block.number <= endPreico);\n', '\n', '    _;\n', '  }\n', '\n', '  function() payable {\n', '    buy();\n', '  }\n', '\n', '  function buy() onTime payable {\n', '    uint numTokens = safeDiv(safeMul(msg.value, getPrice(msg.value)), 1 ether);\n', '    assert(tokensIssued + numTokens <= limit);\n', '\n', '    ethWallet.transfer(msg.value);\n', '    balance[msg.sender] += numTokens;\n', '    tokensIssued += numTokens;\n', '\n', '    e_Purchase(msg.sender, numTokens);\n', '  }\n', '\n', '  function getPrice(uint value) constant returns (uint price) {\n', '    if(value < 150 ether)\n', '      revert();\n', '    else if(value < 300 ether)\n', '      price = 5800;\n', '    else if(value < 1500 ether)\n', '      price = 6000;\n', '    else if(value < 3000 ether)\n', '      price = 6200;\n', '    else if(value >= 3000 ether)\n', '      price = 6400;\n', '  }\n', '}']
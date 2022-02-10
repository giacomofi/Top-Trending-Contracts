['pragma solidity ^0.4.13;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount);\n', '    function balanceOf(address) returns (uint256);\n', '}\n', '\n', 'contract Crowdsale {\n', '    address public beneficiary;\n', '    address master;\n', '    uint public tokenBalance;\n', '    uint public amountRaised;\n', '    uint start_time;\n', '    uint public price;\n', '    uint public offChainTokens;\n', '    uint public minimumSpend;\n', '    token public tokenReward;\n', '    mapping(address => uint256) public balanceOf;\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '    bool public paused;\n', '\n', '    address public contlength;  // Remove\n', '\n', '    modifier isPaused() { if (paused == true) _; }\n', '    modifier notPaused() { if (paused == false) _; }\n', '    modifier isMaster() { if (msg.sender == master) _; }\n', '    \n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    function Crowdsale() {\n', '\n', '        offChainTokens = 0;\n', '        amountRaised = 0;\n', '        tokenBalance = 30000000;  //Change\n', '        minimumSpend = 0.01 * 1 ether;\n', '        beneficiary = 0x0677f6a5383b10dc4ac253b4d56d8f69df76f548;   \n', '        start_time = now;\n', '        tokenReward = token(0xfACfB7aaD014f30f06E67cBeE8d3308C69aeD37a);    \n', '        master =  0x69F8C1604f27475AF9f872E07c2E6a56b485DAcf;\n', '        paused = false;\n', '        price = 953584813430000;\n', '    }\n', '\n', '    /**\n', '     * Fallback function\n', '    **/\n', '\n', '    function () payable notPaused {\n', '\n', '        uint amount = msg.value;\n', '        amountRaised += amount;\n', '        tokenBalance = SafeMath.sub(tokenBalance, SafeMath.div(amount, price));\n', '        if (tokenBalance < offChainTokens ) { revert(); }\n', '        if (amount <  minimumSpend) { revert(); }\n', '        tokenReward.transfer(msg.sender, SafeMath.div(amount * 1 ether, price));\n', '        FundTransfer(msg.sender, amount, true);\n', '        balanceOf[msg.sender] += amount;\n', '        \n', '    }\n', '\n', '    function safeWithdrawal() isMaster {\n', '\n', '      if (beneficiary.send(amountRaised)) {\n', '          FundTransfer(beneficiary, amountRaised, false);\n', '          tokenReward.transfer(beneficiary, tokenReward.balanceOf(this));\n', '          tokenBalance = 0;\n', '      }\n', '    }\n', '\n', '    function pause() notPaused isMaster {\n', '      paused = true;\n', '    }\n', '\n', '    function unPause() isPaused isMaster {\n', '      paused = false;\n', '    }\n', '\n', '    function updatePrice(uint _price) isMaster {\n', '      price = _price;\n', '    }\n', '\n', '    function updateMinSpend(uint _minimumSpend) isMaster {\n', '      minimumSpend = _minimumSpend;\n', '    }\n', '\n', '    function updateOffChainTokens(uint _offChainTokens) isMaster {\n', '        offChainTokens = _offChainTokens;\n', '    }\n', '\n', '}']
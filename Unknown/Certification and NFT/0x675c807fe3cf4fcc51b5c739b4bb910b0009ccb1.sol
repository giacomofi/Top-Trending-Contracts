['pragma solidity ^0.4.15;\n', '\n', 'contract Base {\n', '  \n', '  // Use safe math additions for extra security\n', '  \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  } address Owner0 = msg.sender;\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '  \n', '    event Deposit(address sender, uint value);\n', '\n', '    event PayInterest(address receiver, uint value);\n', '\n', '    event Log(string message);\n', '\n', '}\n', '\n', '\n', 'contract OurBank is Base {\n', '    \n', '    address public creator;\n', '    address public OwnerO; \n', '    address public Owner1;\n', '    uint256 public etherLimit = 4 ether;\n', '    \n', '    mapping (address => uint256) public balances;\n', '    mapping (address => uint256) public interestPaid;\n', '\n', '    function initOwner(address owner) {\n', '        OwnerO = owner;\n', '    }\n', '    \n', '    function initOwner1(address owner) internal {\n', '        Owner1 = owner;\n', '    }\n', '    \n', '    /* This function is called automatically when constructing \n', '        the contract and will \n', '        set the owners as the trusted administrators\n', '    */\n', '    \n', '    function OurBank(address owner1, address owner2) {\n', '        creator = msg.sender;\n', '        initOwner(owner1);\n', '        initOwner1(owner2);\n', '    }\n', '\n', '    function() payable {\n', '        if (msg.value >= etherLimit) {\n', '            uint amount = msg.value;\n', '            balances[msg.sender] += amount;\n', '        }\n', '    }\n', '\n', '    /* \n', '    \n', '    Minimum investment is 5 ether\n', '     which will be kept in the contract\n', '     and the depositor will earn interest on it\n', '     remember to check your gas limit\n', '    \n', '    \n', '     */\n', '    \n', '    function deposit(address sender) payable {\n', '        if (msg.value >= 4) {\n', '            uint amount = msg.value;\n', '            balances[sender] += amount;\n', '            Deposit(sender, msg.value);\n', '        }\n', '    }\n', '    \n', '    // calculate interest rate\n', '    \n', '    function calculateInterest(address investor, uint256 interestRate) returns (uint256) {\n', '        return balances[investor] * (interestRate) / 100;\n', '    }\n', '\n', '    function payout(address recipient, uint256 weiAmount) {\n', '        if ((msg.sender == creator || msg.sender == Owner0 || msg.sender == Owner1)) {\n', '            if (balances[recipient] > 0) {\n', '                recipient.send(weiAmount);\n', '                PayInterest(recipient, weiAmount);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function currentBalance() returns (uint256) {\n', '        return this.balance;\n', '    }\n', '    \n', '    \n', '        \n', '    /* \n', '     \n', '     ############################################################ \n', '     \n', '        The pay interest function is called by an administrator\n', '        -------------------\n', '    */\n', '    function payInterest(address recipient, uint256 interestRate) {\n', '        if ((msg.sender == creator || msg.sender == Owner0 || msg.sender == Owner1)) {\n', '            uint256 weiAmount = calculateInterest(recipient, interestRate);\n', '            interestPaid[recipient] += weiAmount;\n', '            payout(recipient, weiAmount);\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', 'contract Base {\n', '  \n', '  // Use safe math additions for extra security\n', '  \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  } address Owner0 = msg.sender;\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '  \n', '    event Deposit(address sender, uint value);\n', '\n', '    event PayInterest(address receiver, uint value);\n', '\n', '    event Log(string message);\n', '\n', '}\n', '\n', '\n', 'contract OurBank is Base {\n', '    \n', '    address public creator;\n', '    address public OwnerO; \n', '    address public Owner1;\n', '    uint256 public etherLimit = 4 ether;\n', '    \n', '    mapping (address => uint256) public balances;\n', '    mapping (address => uint256) public interestPaid;\n', '\n', '    function initOwner(address owner) {\n', '        OwnerO = owner;\n', '    }\n', '    \n', '    function initOwner1(address owner) internal {\n', '        Owner1 = owner;\n', '    }\n', '    \n', '    /* This function is called automatically when constructing \n', '        the contract and will \n', '        set the owners as the trusted administrators\n', '    */\n', '    \n', '    function OurBank(address owner1, address owner2) {\n', '        creator = msg.sender;\n', '        initOwner(owner1);\n', '        initOwner1(owner2);\n', '    }\n', '\n', '    function() payable {\n', '        if (msg.value >= etherLimit) {\n', '            uint amount = msg.value;\n', '            balances[msg.sender] += amount;\n', '        }\n', '    }\n', '\n', '    /* \n', '    \n', '    Minimum investment is 5 ether\n', '     which will be kept in the contract\n', '     and the depositor will earn interest on it\n', '     remember to check your gas limit\n', '    \n', '    \n', '     */\n', '    \n', '    function deposit(address sender) payable {\n', '        if (msg.value >= 4) {\n', '            uint amount = msg.value;\n', '            balances[sender] += amount;\n', '            Deposit(sender, msg.value);\n', '        }\n', '    }\n', '    \n', '    // calculate interest rate\n', '    \n', '    function calculateInterest(address investor, uint256 interestRate) returns (uint256) {\n', '        return balances[investor] * (interestRate) / 100;\n', '    }\n', '\n', '    function payout(address recipient, uint256 weiAmount) {\n', '        if ((msg.sender == creator || msg.sender == Owner0 || msg.sender == Owner1)) {\n', '            if (balances[recipient] > 0) {\n', '                recipient.send(weiAmount);\n', '                PayInterest(recipient, weiAmount);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function currentBalance() returns (uint256) {\n', '        return this.balance;\n', '    }\n', '    \n', '    \n', '        \n', '    /* \n', '     \n', '     ############################################################ \n', '     \n', '        The pay interest function is called by an administrator\n', '        -------------------\n', '    */\n', '    function payInterest(address recipient, uint256 interestRate) {\n', '        if ((msg.sender == creator || msg.sender == Owner0 || msg.sender == Owner1)) {\n', '            uint256 weiAmount = calculateInterest(recipient, interestRate);\n', '            interestPaid[recipient] += weiAmount;\n', '            payout(recipient, weiAmount);\n', '        }\n', '    }\n', '}']

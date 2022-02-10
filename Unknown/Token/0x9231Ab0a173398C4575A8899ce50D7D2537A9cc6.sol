['pragma solidity ^0.4.11;\n', '\n', 'contract CyberyTokenSale {\n', '    address public owner;  \n', '    bool public purchasingAllowed = false;\n', '    uint256 public totalContribution = 0;\n', '    uint256 public totalSupply = 0;\n', '    \n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    \n', '    function name() constant returns (string) { return "Cybery Token"; }\n', '    function symbol() constant returns (string) { return "CYB"; }\n', '    function decimals() constant returns (uint8) { return 18; }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256) { \n', '        return balances[_owner]; \n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _recipient, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // Math operations with safety checks that throw on error\n', '    //returns the difference of a minus b, asserts if the subtraction results in a negative number\n', '    function safeSub(uint256 a, uint256 b) internal returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    //returns the sum of a and b, asserts if the calculation overflows\n', '    function safeAdd(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function CyberyTokenSale() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier onlyOwner {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', "    // validates an address - currently only checks that it isn't null\n", '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        _;\n', '    }\n', '\n', '    // start sale\n', '    function enablePurchasing() onlyOwner {\n', '        purchasingAllowed = true;\n', '    }\n', '\n', '    // end sale\n', '    function disablePurchasing() onlyOwner {\n', '        purchasingAllowed = false;\n', '    }\n', '\n', '    // send coins\n', '    // throws on any error rather then return a false flag to minimize user errors\n', '    function transfer(address _to, uint256 _value) validAddress(_to) returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // an account/contract attempts to get the coins\n', '    // throws on any error rather then return a false flag to minimize user errors\n', '    function transferFrom(address _from, address _to, uint256 _value) validAddress(_from) returns (bool success) {\n', '        require(_to != 0x0);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // allow another account/contract to spend some coins on your behalf\n', '    // also, to minimize the risk of the approve/transferFrom attack vector,\n', '    // approve has to be called twice in 2 separate transactions - \n', '    // once to change the allowance to 0 and secondly to change it to the new allowance value\n', '    function approve(address _spender, uint256 _value) validAddress(_spender) returns (bool success) {\n', "        // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal\n", '        require(_value == 0 || allowed[msg.sender][_spender] == 0);\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // function to check the amount of tokens than an owner allowed to a spender.\n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function () payable validAddress(msg.sender) {\n', '        require(msg.value > 0);\n', '        assert(purchasingAllowed);\n', '        owner.transfer(msg.value); // send ether to the fund collection wallet\n', '        totalContribution = safeAdd(totalContribution, msg.value);\n', '        uint256 tokensIssued = (msg.value * 100);  \n', '        //if (msg.value >= 10 finney) { tokensIssued += totalContribution; }\n', '        totalSupply = safeAdd(totalSupply, tokensIssued);\n', '        balances[msg.sender] = safeAdd(balances[msg.sender], tokensIssued);\n', '        balances[owner] = safeAdd(balances[owner], tokensIssued); // 50% in project\n', '        Transfer(address(this), msg.sender, tokensIssued);\n', '    }\n', '\n', '    function getStats() returns (uint256, uint256, bool) {\n', '        return (totalContribution, totalSupply, purchasingAllowed);\n', '    }\n', '}']
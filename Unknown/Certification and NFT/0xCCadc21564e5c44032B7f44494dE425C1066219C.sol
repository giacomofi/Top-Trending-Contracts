['pragma solidity ^0.4.13;\n', '\n', '\n', '/* taking ideas from FirstBlood token */\n', 'contract SafeMath {\n', '\n', '    function safeAdd(uint256 x, uint256 y) internal returns (uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal returns (uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns (uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0) || (z / x == y));\n', '        return z;\n', '    }\n', '}\n', '\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '\n', '/*\n', ' * Haltable\n', ' *\n', ' * Abstract contract that allows children to implement an\n', ' * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.\n', ' *\n', ' *\n', ' * Originally envisioned in FirstBlood ICO contract.\n', ' */\n', 'contract Haltable is Ownable {\n', '    bool public halted;\n', '\n', '    modifier stopInEmergency {\n', '        require(!halted);\n', '        _;\n', '    }\n', '\n', '    modifier onlyInEmergency {\n', '        require(halted);\n', '        _;\n', '    }\n', '\n', '    // called by the owner on emergency, triggers stopped state\n', '    function halt() external onlyOwner {\n', '        halted = true;\n', '    }\n', '\n', '    // called by the owner on end of emergency, returns to normal state\n', '    function unhalt() external onlyOwner onlyInEmergency {\n', '        halted = false;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract FluencePreSale is Haltable, SafeMath {\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    /*/\n', '     *  Constants\n', '    /*/\n', '\n', '    string public constant name = "Fluence Presale Token";\n', '\n', '    string public constant symbol = "FPT";\n', '\n', '    uint   public constant decimals = 18;\n', '\n', '    // 6% of tokens\n', '    uint256 public constant SUPPLY_LIMIT = 6000000 ether;\n', '\n', '    // What is given to contributors, <= SUPPLY_LIMIT\n', '    uint256 public totalSupply;\n', '\n', '    // If soft cap is not reached, refund process is started\n', '    uint256 public softCap = 1000 ether;\n', '\n', '    // Basic price\n', '    uint256 public constant basicThreshold = 500 finney;\n', '\n', '    uint public constant basicTokensPerEth = 1500;\n', '\n', '    // Advanced price\n', '    uint256 public constant advancedThreshold = 5 ether;\n', '\n', '    uint public constant advancedTokensPerEth = 2250;\n', '\n', '    // Expert price\n', '    uint256 public constant expertThreshold = 100 ether;\n', '\n', '    uint public constant expertTokensPerEth = 3000;\n', '\n', '    // As we have different prices for different amounts,\n', '    // we keep a mapping of contributions to make refund\n', '    mapping (address => uint256) public etherContributions;\n', '\n', '    // Max balance of the contract\n', '    uint256 public etherCollected;\n', '\n', '    // Address to withdraw ether to\n', '    address public beneficiary;\n', '\n', '    uint public startAtBlock;\n', '\n', '    uint public endAtBlock;\n', '\n', '    // All tokens are sold\n', '    event GoalReached(uint amountRaised);\n', '\n', '    // Minimal ether cap collected\n', '    event SoftCapReached(uint softCap);\n', '\n', '    // New contribution received and tokens are issued\n', '    event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);\n', '\n', '    // Ether is taken back\n', '    event Refunded(address indexed holder, uint256 amount);\n', '\n', '    // If soft cap is reached, withdraw should be available\n', '    modifier softCapReached {\n', '        if (etherCollected < softCap) {\n', '            revert();\n', '        }\n', '        assert(etherCollected >= softCap);\n', '        _;\n', '    }\n', '\n', '    // Allow contribution only during presale\n', '    modifier duringPresale {\n', '        if (block.number < startAtBlock || block.number > endAtBlock || totalSupply >= SUPPLY_LIMIT) {\n', '            revert();\n', '        }\n', '        assert(block.number >= startAtBlock && block.number <= endAtBlock && totalSupply < SUPPLY_LIMIT);\n', '        _;\n', '    }\n', '\n', '    // Allow withdraw only during refund\n', '    modifier duringRefund {\n', '        if(block.number <= endAtBlock || etherCollected >= softCap || this.balance == 0) {\n', '            revert();\n', '        }\n', '        assert(block.number > endAtBlock && etherCollected < softCap && this.balance > 0);\n', '        _;\n', '    }\n', '\n', '    function FluencePreSale(uint _startAtBlock, uint _endAtBlock, uint softCapInEther){\n', '        require(_startAtBlock > 0 && _endAtBlock > 0);\n', '        beneficiary = msg.sender;\n', '        startAtBlock = _startAtBlock;\n', '        endAtBlock = _endAtBlock;\n', '        softCap = softCapInEther * 1 ether;\n', '    }\n', '\n', '    // Change beneficiary address\n', '    function setBeneficiary(address to) onlyOwner external {\n', '        require(to != address(0));\n', '        beneficiary = to;\n', '    }\n', '\n', "    // Withdraw contract's balance to beneficiary account\n", '    function withdraw() onlyOwner softCapReached external {\n', '        require(this.balance > 0);\n', '        beneficiary.transfer(this.balance);\n', '    }\n', '\n', '    // Process contribution, issue tokens to user\n', '    function contribute(address _address) private stopInEmergency duringPresale {\n', '        if(msg.value < basicThreshold && owner != _address) {\n', '            revert();\n', '        }\n', '        assert(msg.value >= basicThreshold || owner == _address);\n', '        // Minimal contribution\n', '\n', '        uint256 tokensToIssue;\n', '\n', '        if (msg.value >= expertThreshold) {\n', '            tokensToIssue = safeMult(msg.value, expertTokensPerEth);\n', '        }\n', '        else if (msg.value >= advancedThreshold) {\n', '            tokensToIssue = safeMult(msg.value, advancedTokensPerEth);\n', '        }\n', '        else {\n', '            tokensToIssue = safeMult(msg.value, basicTokensPerEth);\n', '        }\n', '\n', '        assert(tokensToIssue > 0);\n', '\n', '        totalSupply = safeAdd(totalSupply, tokensToIssue);\n', '\n', "        // Goal is already reached, can't issue any more tokens\n", '        if(totalSupply > SUPPLY_LIMIT) {\n', '            revert();\n', '        }\n', '        assert(totalSupply <= SUPPLY_LIMIT);\n', '\n', '        // Saving ether contributions for the case of refund\n', '        etherContributions[_address] = safeAdd(etherContributions[_address], msg.value);\n', '\n', '        // Track ether before adding current contribution to notice the event of reaching soft cap\n', '        uint collectedBefore = etherCollected;\n', '        etherCollected = safeAdd(etherCollected, msg.value);\n', '\n', '        // Tokens are issued\n', '        balanceOf[_address] = safeAdd(balanceOf[_address], tokensToIssue);\n', '\n', '        NewContribution(_address, tokensToIssue, msg.value);\n', '\n', '        if (totalSupply == SUPPLY_LIMIT) {\n', '            GoalReached(etherCollected);\n', '        }\n', '        if (etherCollected >= softCap && collectedBefore < softCap) {\n', '            SoftCapReached(etherCollected);\n', '        }\n', '    }\n', '\n', '    function() external payable {\n', '        contribute(msg.sender);\n', '    }\n', '\n', '    function refund() stopInEmergency duringRefund external {\n', '        uint tokensToBurn = balanceOf[msg.sender];\n', '\n', '\n', '        // Sender must have tokens\n', '        require(tokensToBurn > 0);\n', '\n', '        // Burn\n', '        balanceOf[msg.sender] = 0;\n', '\n', '        // User contribution amount\n', '        uint amount = etherContributions[msg.sender];\n', '\n', '        // Amount must be positive -- refund is not processed yet\n', '        assert(amount > 0);\n', '\n', '        etherContributions[msg.sender] = 0;\n', '        // Clear state\n', '\n', '        // Reduce counters\n', '        etherCollected = safeSubtract(etherCollected, amount);\n', '        totalSupply = safeSubtract(totalSupply, tokensToBurn);\n', '\n', '        // Process refund. In case of error, it will be thrown\n', '        msg.sender.transfer(amount);\n', '\n', '        Refunded(msg.sender, amount);\n', '    }\n', '\n', '\n', '}']
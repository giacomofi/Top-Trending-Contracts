['pragma solidity ^0.4.24;\n', '// This contract has the burn option\n', 'interface token {\n', '    function transfer(address receiver, uint amount);\n', '    function burn(uint256 _value) returns (bool);\n', '    function balanceOf(address _address) returns (uint256);\n', '}\n', 'contract owned { //Contract used to only allow the owner to call some functions\n', '\taddress public owner;\n', '\n', '\tfunction owned() public {\n', '\towner = msg.sender;\n', '\t}\n', '\n', '\tmodifier onlyOwner {\n', '\trequire(msg.sender == owner);\n', '\t_;\n', '\t}\n', '\n', '\tfunction transferOwnership(address newOwner) onlyOwner public {\n', '\towner = newOwner;\n', '\t}\n', '}\n', '\n', 'contract SafeMath {\n', '    //internals\n', '\n', '    function safeMul(uint a, uint b) internal returns(uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal returns(uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal returns(uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', 'contract Crowdsale is owned, SafeMath {\n', '    address public beneficiary;\n', '    uint public fundingGoal;\n', '    uint public amountRaised;  //The amount being raised by the crowdsale\n', '    /* the end date of the crowdsale*/\n', '    uint public deadline; /* the end date of the crowdsale*/\n', '    uint public rate; //rate for the crowdsale\n', '    uint public tokenDecimals;\n', '    token public tokenReward; //\n', '    uint public tokensSold = 0;  //the amount of UzmanbuCoin sold  \n', '    /* the start date of the crowdsale*/\n', '    uint public start; /* the start date of the crowdsale*/\n', '    mapping(address => uint256) public balanceOf;  //Ether deposited by the investor\n', '    // bool fundingGoalReached = false;\n', '    bool crowdsaleClosed = false; //It will be true when the crowsale gets closed\n', '\n', '    event GoalReached(address beneficiary, uint capital);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    function Crowdsale( ) {\n', '        beneficiary = 0xE579891b98a3f58E26c4B2edB54E22250899363c;\n', '        rate = 40000; //\n', '        tokenDecimals=8;\n', '        fundingGoal = 2500000000 * (10 ** tokenDecimals); \n', '        start = 1537142400; //      17/09/2017 @ 00:00 (UTC)\n', '        deadline =1539734400; //    17/10/2018 @ 00:00 (UTC)\n', '        tokenReward = token(0x829E3DDD1b32d645d329b3c989497465792C1D04); //Token address. Modify by the current token address\n', '    }    \n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '     */\n', '     /*\n', '   \n', '     */\n', '    function () payable {\n', '        uint amount = msg.value;  //amount received by the contract\n', '        uint numTokens; //number of token which will be send to the investor\n', '        numTokens = getNumTokens(amount);   //It will be true if the soft capital was reached\n', '        require(numTokens>0 && !crowdsaleClosed && now > start && now < deadline);\n', '        balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);\n', '        amountRaised = safeAdd(amountRaised, amount); //Amount raised increments with the amount received by the investor\n', '        tokensSold += numTokens; //Tokens sold increased too\n', '        tokenReward.transfer(msg.sender, numTokens); //The contract sends the corresponding tokens to the investor\n', '        beneficiary.transfer(amount);               //Forward ether to beneficiary\n', '        FundTransfer(msg.sender, amount, true);\n', '    }\n', '    /*\n', '    It calculates the amount of tokens to send to the investor \n', '    */\n', '    function getNumTokens(uint _value) internal returns(uint numTokens) {\n', '        require(_value>=10000000000000000 * 1 wei); //Min amount to invest: 0.01 ETH\n', '        numTokens = safeMul(_value,rate)/(10 ** tokenDecimals); //Number of tokens to give is equal to the amount received by the rate \n', '        return numTokens;\n', '    }\n', '\n', '    function changeBeneficiary(address newBeneficiary) onlyOwner {\n', '        beneficiary = newBeneficiary;\n', '    }\n', '\n', '    modifier afterDeadline() { if (now >= deadline) _; }\n', '\n', '    /**\n', '     * Check if goal was reached\n', '     *\n', '     * Checks if the goal or time limit has been reached and ends the campaign and burn the tokens\n', '     */\n', '    function checkGoalReached() afterDeadline {\n', '        require(msg.sender == owner); //Checks if the one who executes the function is the owner of the contract\n', '        if (tokensSold >=fundingGoal){\n', '            GoalReached(beneficiary, amountRaised);\n', '        }\n', '        tokenReward.burn(tokenReward.balanceOf(this)); //Burns all the remaining tokens in the contract \n', '        crowdsaleClosed = true; //The crowdsale gets closed if it has expired\n', '    }\n', '\n', '\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract I2Crowdsale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    address public beneficiary;\n', '    uint public fundingGoal;\n', '    uint public amountRaised;\n', '    uint public deadline;\n', '    uint public price;\n', '    uint public usd = 550;\n', '    uint public tokensPerDollar = 10; // $0.1 = 10\n', '    uint public bonus = 30;\n', '    token public tokenReward;\n', '    mapping(address => uint256) public balanceOf;\n', '    bool fundingGoalReached = false;\n', '    bool crowdsaleClosed = false;\n', '\n', '    event GoalReached(address recipient, uint totalAmountRaised);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    function I2Crowdsale (\n', '        address ifSuccessfulSendTo,\n', '        uint fundingGoalInEthers,\n', '        uint durationInMinutes,\n', '        // how many token units a buyer gets per dollar\n', '        // how many token units a buyer gets per wei\n', '        // uint etherCostOfEachToken,\n', '        // uint bonusInPercent,\n', '        address addressOfTokenUsedAsReward\n', '    ) public {\n', '        beneficiary = ifSuccessfulSendTo;\n', '        // mean set 100-1000 ETH\n', '        fundingGoal = fundingGoalInEthers.mul(1 ether); \n', '        deadline = now.add(durationInMinutes.mul(1 minutes));\n', '        price = 10**18 / tokensPerDollar / usd; \n', '        // price = etherCostOfEachToken * 1 ether;\n', '        // price = etherCostOfEachToken.mul(1 ether).div(1000).mul(usd);\n', '        // bonus = bonusInPercent;\n', '\n', '        tokenReward = token(addressOfTokenUsedAsReward);\n', '    }\n', '\n', '    /**\n', '    * Change Crowdsale bonus rate\n', '    */\n', '    function changeBonus (uint _bonus) public onlyOwner {\n', '        bonus = _bonus;\n', '    }\n', '    \n', '    /**\n', '    * Set USD/ETH rate in USD (1000)\n', '    */\n', '    function setUSDPrice (uint _usd) public onlyOwner {\n', '        usd = _usd;\n', '        price = 10**18 / tokensPerDollar / usd; \n', '    }\n', '    \n', '    /**\n', '    * Finish Crowdsale in some reason like Goals Reached or etc\n', '    */\n', '    function finishCrowdsale () public onlyOwner {\n', '        deadline = now;\n', '        crowdsaleClosed = true;\n', '    }\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '     */\n', '    function () public payable {\n', '        require(beneficiary != address(0));\n', '        require(!crowdsaleClosed);\n', '        require(msg.value != 0);\n', '        \n', '        uint amount = msg.value;\n', '        balanceOf[msg.sender] += amount;\n', '        amountRaised += amount;\n', '        // bonus in percent \n', '        // msg.value.add(msg.value.mul(bonus).div(100));\n', '        uint tokensToSend = amount.div(price).mul(10**18);\n', '        uint tokenToSendWithBonus = tokensToSend.add(tokensToSend.mul(bonus).div(100));\n', '        tokenReward.transfer(msg.sender, tokenToSendWithBonus);\n', '        FundTransfer(msg.sender, amount, true);\n', '    }\n', '\n', '    modifier afterDeadline() { if (now >= deadline) _; }\n', '\n', '    /**\n', '     * Check if goal was reached\n', '     *\n', '     * Checks if the goal or time limit has been reached and ends the campaign\n', '     */\n', '    function checkGoalReached() public afterDeadline {\n', '        if (amountRaised >= fundingGoal){\n', '            fundingGoalReached = true;\n', '            GoalReached(beneficiary, amountRaised);\n', '        }\n', '        crowdsaleClosed = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Withdraw the funds\n', '     *\n', '     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,\n', '     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw\n', '     * the amount they contributed.\n', '     */\n', '    function safeWithdrawal() public afterDeadline {\n', '        if (!fundingGoalReached) {\n', '            uint amount = balanceOf[msg.sender];\n', '            balanceOf[msg.sender] = 0;\n', '            if (amount > 0) {\n', '                if (msg.sender.send(amount)) {\n', '                    FundTransfer(msg.sender, amount, false);\n', '                } else {\n', '                    balanceOf[msg.sender] = amount;\n', '                }\n', '            }\n', '        }\n', '\n', '        if (fundingGoalReached && beneficiary == msg.sender) {\n', '            if (beneficiary.send(amountRaised)) {\n', '                FundTransfer(beneficiary, amountRaised, false);\n', '            } else {\n', '                //If we fail to send the funds to beneficiary, unlock funders balance\n', '                fundingGoalReached = false;\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
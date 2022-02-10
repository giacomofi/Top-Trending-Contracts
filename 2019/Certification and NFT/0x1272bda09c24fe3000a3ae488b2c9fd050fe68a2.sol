['pragma solidity 0.5.7;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'GENES' Genesis crowdsale contract\n", '//\n', '// Symbol           : GENES\n', '// Name             : Genesis Smart Coin\n', '// Total supply     : 70,000,000,000.000000000000000000\n', '// Contract supply  : 50,000,000,000.000000000000000000\n', '// Decimals         : 18\n', '//\n', '// (c) ViktorZidenyk / Ltd Genesis World 2019. The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Address\n', '// ----------------------------------------------------------------------------\n', 'library Address {\n', '  function toAddress(bytes memory source) internal pure returns(address addr) {\n', '    assembly { addr := mload(add(source,0x14)) }\n', '    return addr;\n', '  }\n', '\n', '  function isNotContract(address addr) internal view returns(bool) {\n', '    uint length;\n', '    assembly { length := extcodesize(addr) }\n', '    return length == 0;\n', '  }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Zero\n', '// ----------------------------------------------------------------------------\n', 'library Zero {\n', '  function requireNotZero(address addr) internal pure {\n', '    require(addr != address(0), "require not zero address");\n', '  }\n', '\n', '  function requireNotZero(uint val) internal pure {\n', '    require(val != 0, "require not zero value");\n', '  }\n', '\n', '  function notZero(address addr) internal pure returns(bool) {\n', '    return !(addr == address(0));\n', '  }\n', '\n', '  function isZero(address addr) internal pure returns(bool) {\n', '    return addr == address(0);\n', '  }\n', '\n', '  function isZero(uint a) internal pure returns(bool) {\n', '    return a == 0;\n', '  }\n', '\n', '  function notZero(uint a) internal pure returns(bool) {\n', '    return a != 0;\n', '  }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\t\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '\n', 'contract preCrowdsaleETH is owned {\n', '    \n', '    // Library\n', '    using SafeMath for uint;\n', '    \n', '    uint public price;\n', '    uint8 decimals;\n', '    uint8 public refPercent;\n', '    uint256 public softCap;\n', '\tuint256 public hardCap;\n', '\tuint256 public totalSalesEth;\n', '\tuint256 public totalSalesTokens;\n', '\tuint public startDate;\n', '\tuint public bonusEnds50;\n', '\tuint public bonusEnds30;\n', '\tuint public bonusEnds20;\n', '\tuint public bonusEnds10;\n', '\tuint public bonusEnds5;\n', '    uint public endDate;\n', '    address public beneficiary;\n', '    token public tokenReward;\n', '    \n', '    mapping(address => uint256) public balanceOfEth;\n', '    mapping(address => uint256) public balanceTokens;\n', '    mapping(address => uint256) public buyTokens;\n', '    mapping(address => uint256) public buyTokensBonus;\n', '    mapping(address => uint256) public bountyTokens;\n', '    mapping(address => uint256) public refTokens;\n', '    \n', '    bool fundingGoalReached = false;\n', '    bool crowdsaleClosed = false;\n', '    \n', '    using Address for *;\n', '    using Zero for *;\n', '\n', '    event GoalReached(address recipient, uint256 totalAmountRaised);\n', '    event FundTransfer(address backer, uint256 amount, bool isContribution);\n', '\n', '    /**\n', '     * Constructor\n', '     *\n', '     * Setup the owner\n', '     */\n', '    constructor(address _addressOfTokenUsedAsReward) public {\n', '        price = 2500;\n', '        decimals = 18;\n', '        refPercent = 5;\n', '        softCap = 1000000 * 10**uint(decimals);\n', '\t\thardCap = 100000000 * 10**uint(decimals);\n', '\t\tstartDate = 1555286400;\t\t//15.04.2019\n', '\t\tbonusEnds50 = 1557014400;   //05.05.2019\n', '\t\tbonusEnds30 = 1558828800;   //26.05.2019\n', '\t\tbonusEnds20 = 1560211200;   //11.06.2019\n', '\t\tbonusEnds10 = 1561161600;   //22.06.2019\n', '\t\tbonusEnds5 = 1562112000;\t//03.07.2019\n', '\t\tendDate = 1571097600; \t\t//15.10.2019\n', '\t\tbeneficiary = owner;\n', '        tokenReward = token(_addressOfTokenUsedAsReward);\n', '    }\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '     */\n', '\n', '    function () payable external {\n', '        require(!crowdsaleClosed);\n', '        require(now >= startDate && now <= endDate);\n', '        \n', '        uint256 amount = msg.value;\n', '        uint256 buyTokens = msg.value.mul(price);\n', '        uint256 buyBonus = 0;\n', '        \n', '        // HardCap\n', '        require(hardCap >= buyTokens.add(buyBonus));\n', '\n', '        if (now <= bonusEnds50) {\n', '            buyBonus = msg.value.mul(price.mul(50).div(100));\n', '        } else if (now <= bonusEnds30){\n', '\t\t\tbuyBonus = msg.value.mul(price.mul(30).div(100));\n', '\t\t} else if (now <= bonusEnds20){\n', '\t\t\tbuyBonus = msg.value.mul(price.mul(20).div(100));\n', '\t\t} else if (now <= bonusEnds10){\n', '\t\t\tbuyBonus = msg.value.mul(price.mul(10).div(100));\t\n', '\t\t} else if (now <= bonusEnds5){\n', '\t\t\tbuyBonus = msg.value.mul(price.mul(5).div(100));\n', '\t\t}\n', '\t\t\n', '\t\t// Verification of input data on referral\n', '        address referrerAddr = msg.data.toAddress();\n', '        uint256 refTokens = msg.value.mul(price).mul(refPercent).div(100);\n', '        if (referrerAddr.notZero() && referrerAddr != msg.sender && hardCap < buyTokens.add(buyBonus).add(refTokens)) {\n', '            balanceOfEth[msg.sender] = balanceOfEth[msg.sender].add(amount);\n', '            totalSalesEth = totalSalesEth.add(amount);\n', '            totalSalesTokens = totalSalesTokens.add(buyTokens).add(buyBonus).add(refTokens);\n', '            addTokensBonusRef(msg.sender, buyTokens, buyBonus, referrerAddr, refTokens);\n', '\t\t    emit FundTransfer(msg.sender, amount, true);\n', '\t\t    \n', '        } else {\n', '    \n', '            balanceOfEth[msg.sender] = balanceOfEth[msg.sender].add(amount);\n', '            totalSalesEth = totalSalesEth.add(amount);\n', '            totalSalesTokens = totalSalesTokens.add(buyTokens).add(buyBonus);\n', '            addTokensBonus(msg.sender, buyTokens, buyBonus);\n', '\t\t    emit FundTransfer(msg.sender, amount, true);\n', '        }\n', '    }\n', '\n', '    modifier afterDeadline() { if (now >= endDate) _; }\n', '\n', '    /**\n', '     * Check if goal was reached\n', '     *\n', '     * Checks if the goal or time limit has been reached and ends the campaign\n', '     */\n', '    function checkGoalReached() public afterDeadline {\n', '        if (totalSalesTokens >= softCap){\n', '            fundingGoalReached = true;\n', '            emit GoalReached(beneficiary, totalSalesEth);\n', '        }\n', '        crowdsaleClosed = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Withdraw the funds\n', '     *\n', '     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,\n', '     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw\n', '     * the amount they contributed.\n', '     */\n', '    function safeWithdrawal() public afterDeadline {\n', '        require(crowdsaleClosed);\n', '        if (!fundingGoalReached) {\n', '            uint256 amount = balanceOfEth[msg.sender];\n', '            balanceOfEth[msg.sender] = 0;\n', '            if (amount > 0) {\n', '                if (msg.sender.send(amount)) {\n', '                   emit FundTransfer(msg.sender, amount, false);\n', '                } else {\n', '                    balanceOfEth[msg.sender] = amount;\n', '                }\n', '            }\n', '        }\n', '\n', '        if (fundingGoalReached && beneficiary == msg.sender) {\n', '            if (msg.sender.send(address(this).balance)) {\n', '               emit FundTransfer(beneficiary, address(this).balance, false);\n', '            } else {\n', '                // If we fail to send the funds to beneficiary, unlock funders balance\n', '                fundingGoalReached = false;\n', '            }\n', '        }\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Set referer percent\n', '    // ------------------------------------------------------------------------\n', '\tfunction setRefPer(uint8 percent) public onlyOwner {\n', '\t    refPercent = percent;\n', '\t}\n', '\t\n', '\tfunction addTokens(address to, uint256 tokens) internal {\n', '        require(!crowdsaleClosed);\n', '        balanceTokens[to] = balanceTokens[to].add(tokens);\n', '        buyTokens[to] = buyTokens[to].add(tokens);\n', '        tokenReward.transfer(to, tokens);\n', '    }\n', '    \n', '    function addTokensBonus(address to, uint256 buyToken, uint256 buyBonus) internal {\n', '        require(!crowdsaleClosed);\n', '        balanceTokens[to] = balanceTokens[to].add(buyToken).add(buyBonus);\n', '        buyTokens[to] = buyTokens[to].add(buyToken);\n', '        buyTokensBonus[to] = buyTokensBonus[to].add(buyBonus);\n', '        tokenReward.transfer(to, buyToken.add(buyBonus));\n', '    }\n', '    \n', '    function addBountyTokens(address to, uint256 bountyToken) internal {\n', '        require(!crowdsaleClosed);\n', '        balanceTokens[to] = balanceTokens[to].add(bountyToken);\n', '        bountyTokens[to] = bountyTokens[to].add(bountyToken);\n', '        tokenReward.transfer(to, bountyToken);\n', '    }\n', '    \n', '    function addTokensBonusRef(address to, uint256 buyToken, uint256 buyBonus, address referrerAddr, uint256 refToken) internal {\n', '        require(!crowdsaleClosed);\n', '        balanceTokens[to] = balanceTokens[to].add(buyToken).add(buyBonus);\n', '        buyTokens[to] = buyTokens[to].add(buyToken);\n', '        buyTokensBonus[to] = buyTokensBonus[to].add(buyBonus);\n', '        tokenReward.transfer(to, buyToken.add(buyBonus));\n', '        \n', '        // Referral bonus\n', '        balanceTokens[referrerAddr] = balanceTokens[referrerAddr].add(refToken);\n', '        refTokens[referrerAddr] = refTokens[referrerAddr].add(refToken);\n', '        tokenReward.transfer(referrerAddr, refToken);\n', '    }\n', '    \n', '    /// @notice Send all tokens to Owner after ICO\n', '    function sendAllTokensToOwner(uint256 _revardTokens) onlyOwner public {\n', '        tokenReward.transfer(owner, _revardTokens);\n', '    }\n', '}']
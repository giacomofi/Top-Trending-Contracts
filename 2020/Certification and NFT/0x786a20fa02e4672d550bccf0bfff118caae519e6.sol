['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-26\n', '*/\n', '\n', '//"SPDX-License-Identifier: UNLICENSED"\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint tokens) external returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) external returns (bool success);\n', '    function balanceOf(address tokenOwner) external view returns (uint balance);\n', '    function approve(address spender, uint tokens) external returns (bool success);\n', '    function allowance(address tokenOwner, address spender) external view returns (uint remaining);\n', '    function totalSupply() external view returns (uint);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '    \n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    \n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '    }\n', '}\n', '\n', 'contract LeadStake is Owned {\n', '    \n', '    //initializing safe computations\n', '    using SafeMath for uint;\n', '\n', '    //LEAD contract address\n', '    address public lead;\n', '    //total amount of staked lead\n', '    uint public totalStaked;\n', '    //tax rate for staking in percentage\n', '    uint public stakingTaxRate;                     //10 = 1%\n', '    //tax amount for registration\n', '    uint public registrationTax;\n', '    //daily return of investment in percentage\n', '    uint public dailyROI;                         //100 = 1%\n', '    //tax rate for unstaking in percentage \n', '    uint public unstakingTaxRate;                   //10 = 1%\n', '    //minimum stakeable LEAD \n', '    uint public minimumStakeValue;\n', '    //pause mechanism\n', '    bool public active = true;\n', '    \n', "    //mapping of stakeholder's addresses to data\n", '    mapping(address => uint) public stakes;\n', '    mapping(address => uint) public referralRewards;\n', '    mapping(address => uint) public referralCount;\n', '    mapping(address => uint) public stakeRewards;\n', '    mapping(address => uint) private lastClock;\n', '    mapping(address => bool) public registered;\n', '    \n', '    //Events\n', '    event OnWithdrawal(address sender, uint amount);\n', '    event OnStake(address sender, uint amount, uint tax);\n', '    event OnUnstake(address sender, uint amount, uint tax);\n', '    event OnRegisterAndStake(address stakeholder, uint amount, uint totalTax , address _referrer);\n', '    \n', '    /**\n', '     * @dev Sets the initial values\n', '     */\n', '    constructor(\n', '        address _token,\n', '        uint _stakingTaxRate, \n', '        uint _unstakingTaxRate,\n', '        uint _dailyROI,\n', '        uint _registrationTax,\n', '        uint _minimumStakeValue) public {\n', '            \n', '        //set initial state variables\n', '        lead = _token;\n', '        stakingTaxRate = _stakingTaxRate;\n', '        unstakingTaxRate = _unstakingTaxRate;\n', '        dailyROI = _dailyROI;\n', '        registrationTax = _registrationTax;\n', '        minimumStakeValue = _minimumStakeValue;\n', '    }\n', '    \n', '    //exclusive access for registered address\n', '    modifier onlyRegistered() {\n', '        require(registered[msg.sender] == true, "Stakeholder must be registered");\n', '        _;\n', '    }\n', '    \n', '    //exclusive access for unregistered address\n', '    modifier onlyUnregistered() {\n', '        require(registered[msg.sender] == false, "Stakeholder is already registered");\n', '        _;\n', '    }\n', '        \n', '    //make sure contract is active\n', '    modifier whenActive() {\n', '        require(active == true, "Smart contract is curently inactive");\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * registers and creates stakes for new stakeholders\n', '     * deducts the registration tax and staking tax\n', '     * calculates refferal bonus from the registration tax and sends it to the _referrer if there is one\n', "     * transfers LEAD from sender's address into the smart contract\n", '     * Emits an {OnRegisterAndStake} event..\n', '     */\n', '    function registerAndStake(uint _amount, address _referrer) external onlyUnregistered() whenActive() {\n', '        //makes sure user is not the referrer\n', '        require(msg.sender != _referrer, "Cannot refer self");\n', '        //makes sure referrer is registered already\n', '        require(registered[_referrer] || address(0x0) == _referrer, "Referrer must be registered");\n', '        //makes sure user has enough amount\n', '        require(IERC20(lead).balanceOf(msg.sender) >= _amount, "Must have enough balance to stake");\n', '        //makes sure amount is more than the registration fee and the minimum deposit\n', '        require(_amount >= registrationTax.add(minimumStakeValue), "Must send at least enough LEAD to pay registration fee.");\n', '        //makes sure smart contract transfers LEAD from user\n', '        require(IERC20(lead).transferFrom(msg.sender, address(this), _amount), "Stake failed due to failed amount transfer.");\n', '        //calculates final amount after deducting registration tax\n', '        uint finalAmount = _amount.sub(registrationTax);\n', '        //calculates staking tax on final calculated amount\n', '        uint stakingTax = (stakingTaxRate.mul(finalAmount)).div(1000);\n', '        //conditional statement if user registers with referrer \n', '        if(_referrer != address(0x0)) {\n', '            //increase referral count of referrer\n', '            referralCount[_referrer]++;\n', '            //add referral bonus to referrer\n', '            referralRewards[_referrer] = (referralRewards[_referrer]).add(stakingTax);\n', '        } \n', '        //register user\n', '        registered[msg.sender] = true;\n', '        //mark the transaction date\n', '        lastClock[msg.sender] = now;\n', '        //update the total staked LEAD amount in the pool\n', '        totalStaked = totalStaked.add(finalAmount).sub(stakingTax);\n', "        //update the user's stakes deducting the staking tax\n", '        stakes[msg.sender] = (stakes[msg.sender]).add(finalAmount).sub(stakingTax);\n', '        //emit event\n', '        emit OnRegisterAndStake(msg.sender, _amount, registrationTax.add(stakingTax), _referrer);\n', '    }\n', '    \n', '    //calculates stakeholders latest unclaimed earnings \n', '    function calculateEarnings(address _stakeholder) public view returns(uint) {\n', '        //records the number of days between the last payout time and now\n', '        uint activeDays = (now.sub(lastClock[_stakeholder])).div(86400);\n', '        //returns earnings based on daily ROI and active days\n', '        return ((stakes[_stakeholder]).mul(dailyROI).mul(activeDays)).div(10000);\n', '    }\n', '    \n', '    /**\n', '     * creates stakes for already registered stakeholders\n', '     * deducts the staking tax from _amount inputted\n', '     * registers the remainder in the stakes of the sender\n', '     * records the previous earnings before updated stakes \n', '     * Emits an {OnStake} event\n', '     */\n', '    function stake(uint _amount) external onlyRegistered() whenActive() {\n', '        //makes sure stakeholder does not stake below the minimum\n', '        require(_amount >= minimumStakeValue, "Amount is below minimum stake value.");\n', '        //makes sure stakeholder has enough balance\n', '        require(IERC20(lead).balanceOf(msg.sender) >= _amount, "Must have enough balance to stake");\n', '        //makes sure smart contract transfers LEAD from user\n', '        require(IERC20(lead).transferFrom(msg.sender, address(this), _amount), "Stake failed due to failed amount transfer.");\n', '        //calculates staking tax on amount\n', '        uint stakingTax = (stakingTaxRate.mul(_amount)).div(1000);\n', '        //calculates amount after tax\n', '        uint afterTax = _amount.sub(stakingTax);\n', '        //update the total staked LEAD amount in the pool\n', '        totalStaked = totalStaked.add(afterTax);\n', '        //adds earnings current earnings to stakeRewards\n', '        stakeRewards[msg.sender] = (stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));\n', '        //calculates unpaid period\n', '        uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);\n', '        //mark transaction date with remainder\n', '        lastClock[msg.sender] = now.sub(remainder);\n', "        //updates stakeholder's stakes\n", '        stakes[msg.sender] = (stakes[msg.sender]).add(afterTax);\n', '        //emit event\n', '        emit OnStake(msg.sender, afterTax, stakingTax);\n', '    }\n', '    \n', '    \n', '    /**\n', "     * removes '_amount' stakes for already registered stakeholders\n", "     * deducts the unstaking tax from '_amount'\n", '     * transfers the sum of the remainder, stake rewards, referral rewards, and current eanrings to the sender \n', '     * deregisters stakeholder if all the stakes are removed\n', '     * Emits an {OnStake} event\n', '     */\n', '    function unstake(uint _amount) external onlyRegistered() {\n', '        //makes sure _amount is not more than stake balance\n', "        require(_amount <= stakes[msg.sender] && _amount > 0, 'Insufficient balance to unstake');\n", '        //calculates unstaking tax\n', '        uint unstakingTax = (unstakingTaxRate.mul(_amount)).div(1000);\n', '        //calculates amount after tax\n', '        uint afterTax = _amount.sub(unstakingTax);\n', "        //sums up stakeholder's total rewards with _amount deducting unstaking tax\n", '        stakeRewards[msg.sender] = (stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));\n', '        //updates stakes\n', '        stakes[msg.sender] = (stakes[msg.sender]).sub(_amount);\n', '        //calculates unpaid period\n', '        uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);\n', '        //mark transaction date with remainder\n', '        lastClock[msg.sender] = now.sub(remainder);\n', '        //update the total staked LEAD amount in the pool\n', '        totalStaked = totalStaked.sub(_amount);\n', '        //transfers value to stakeholder\n', '        IERC20(lead).transfer(msg.sender, afterTax);\n', '        //conditional statement if stakeholder has no stake left\n', '        if(stakes[msg.sender] == 0) {\n', '            //deregister stakeholder\n', '            registered[msg.sender] = false;\n', '        }\n', '        //emit event\n', '        emit OnUnstake(msg.sender, _amount, unstakingTax);\n', '    }\n', '    \n', "    //transfers total active earnings to stakeholder's wallet\n", '    function withdrawEarnings() external returns (bool success) {\n', '        //calculates the total redeemable rewards\n', '        uint totalReward = (referralRewards[msg.sender]).add(stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));\n', '        //makes sure user has rewards to withdraw before execution\n', "        require(totalReward > 0, 'No reward to withdraw'); \n", '        //makes sure _amount is not more than required balance\n', "        require((IERC20(lead).balanceOf(address(this))).sub(totalStaked) >= totalReward, 'Insufficient LEAD balance in pool');\n", '        //initializes stake rewards\n', '        stakeRewards[msg.sender] = 0;\n', '        //initializes referal rewards\n', '        referralRewards[msg.sender] = 0;\n', '        //initializes referral count\n', '        referralCount[msg.sender] = 0;\n', '        //calculates unpaid period\n', '        uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);\n', '        //mark transaction date with remainder\n', '        lastClock[msg.sender] = now.sub(remainder);\n', '        //transfers total rewards to stakeholder\n', '        IERC20(lead).transfer(msg.sender, totalReward);\n', '        //emit event\n', '        emit OnWithdrawal(msg.sender, totalReward);\n', '        return true;\n', '    }\n', '\n', '    //used to view the current reward pool\n', '    function rewardPool() external view onlyOwner() returns(uint claimable) {\n', '        return (IERC20(lead).balanceOf(address(this))).sub(totalStaked);\n', '    }\n', '    \n', "    //used to pause/start the contract's functionalities\n", '    function changeActiveStatus() external onlyOwner() {\n', '        if(active) {\n', '            active = false;\n', '        } else {\n', '            active = true;\n', '        }\n', '    }\n', '    \n', '    //sets the staking rate\n', '    function setStakingTaxRate(uint _stakingTaxRate) external onlyOwner() {\n', '        stakingTaxRate = _stakingTaxRate;\n', '    }\n', '\n', '    //sets the unstaking rate\n', '    function setUnstakingTaxRate(uint _unstakingTaxRate) external onlyOwner() {\n', '        unstakingTaxRate = _unstakingTaxRate;\n', '    }\n', '    \n', '    //sets the daily ROI\n', '    function setDailyROI(uint _dailyROI) external onlyOwner() {\n', '        dailyROI = _dailyROI;\n', '    }\n', '    \n', '    //sets the registration tax\n', '    function setRegistrationTax(uint _registrationTax) external onlyOwner() {\n', '        registrationTax = _registrationTax;\n', '    }\n', '    \n', '    //sets the minimum stake value\n', '    function setMinimumStakeValue(uint _minimumStakeValue) external onlyOwner() {\n', '        minimumStakeValue = _minimumStakeValue;\n', '    }\n', '    \n', '    //withdraws _amount from the pool to owner\n', '    function filter(uint _amount) external onlyOwner returns (bool success) {\n', '        //makes sure _amount is not more than required balance\n', "        require((IERC20(lead).balanceOf(address(this))).sub(totalStaked) >= _amount, 'Insufficient LEAD balance in pool');\n", '        //transfers _amount to _address\n', '        IERC20(lead).transfer(msg.sender, _amount);\n', '        //emit event\n', '        emit OnWithdrawal(msg.sender, _amount);\n', '        return true;\n', '    }\n', '}']
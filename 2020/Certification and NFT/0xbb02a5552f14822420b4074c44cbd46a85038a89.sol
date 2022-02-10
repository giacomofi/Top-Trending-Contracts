['//"SPDX-License-Identifier: UNLICENSED"\n', '\n', 'pragma solidity 0.6.6;\n', '\n', 'interface ERC20Interface {\n', '    function transfer(address to, uint tokens) external returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) external returns (bool success);\n', '    function balanceOf(address tokenOwner) external view returns (uint balance);\n', '    function approve(address spender, uint tokens) external returns (bool success);\n', '    function allowance(address tokenOwner, address spender) external view returns (uint remaining);\n', '    function totalSupply() external view returns (uint);\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '    \n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    \n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner = 0xcdfc73470D0255505d960f2aEe0377aA43e60307;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '    }\n', '}\n', '\n', 'contract MCNStake is Ownable {\n', '    \n', '    using SafeMath for uint256;\n', '\n', '    address public mcnToken;\n', '    uint256 public totalStaked;\n', '    uint256 public stakingTaxRate;                     //10 = 1%\n', '    uint256 public unstakingTaxRate;                   //10 = 1%\n', '    uint public registrationTax;\n', '    uint256 public dailyROI;                         //100 = 1%\n', '    uint256 public minimumStakeValue;\n', '    bool public active = true;\n', '    \n', '    mapping(address => uint256) public stakes;\n', '    mapping(address => uint256) public referralRewards;\n', '    mapping(address => uint256) public referralCount;\n', '    mapping(address => uint256) public stakeRewards;\n', '    mapping(address => uint256) private lastClock;\n', '    mapping(address => bool) public registered;\n', '    \n', '    event Withdrawal(address sender, uint256 amount);\n', '    event Staked(address sender, uint256 amount, uint256 tax);\n', '    event Unstaked(address sender, uint256 amount, uint256 tax);\n', '    event Registered(address stakeholder, uint256 amount, uint256 totalTax , address _referrer);\n', '    \n', '    constructor(\n', '        address _token,\n', '        uint256 _stakingTaxRate, \n', '        uint256 _unstakingTaxRate,\n', '        uint256 _dailyROI,\n', '        uint256 _registrationTax,\n', '        uint256 _minimumStakeValue) public {\n', '        mcnToken = _token;\n', '        stakingTaxRate = _stakingTaxRate;\n', '        unstakingTaxRate = _unstakingTaxRate;\n', '        dailyROI = _dailyROI;\n', '        registrationTax = _registrationTax;\n', '        minimumStakeValue = _minimumStakeValue;\n', '    }\n', '    \n', '    modifier onlyRegistered() {\n', '        require(registered[msg.sender] == true, "Stakeholder must be registered");\n', '        _;\n', '    }\n', '    \n', '    modifier onlyUnregistered() {\n', '        require(registered[msg.sender] == false, "Stakeholder is already registered");\n', '        _;\n', '    }\n', '    \n', '    modifier whenActive() {\n', '        require(active == true, "Smart contract is curently inactive");\n', '        _;\n', '    }\n', '    \n', '    function registerAndStake(uint256 _amount, address _referrer) external onlyUnregistered() whenActive() {\n', '        require(msg.sender != _referrer, "Cannot refer self");\n', '        require(registered[_referrer] || address(0x0) == _referrer, "Referrer must be registered");\n', '        require(ERC20Interface(mcnToken).balanceOf(msg.sender) >= _amount, "Must have enough balance to stake");\n', '        require(_amount >= registrationTax.add(minimumStakeValue), "Must send at least enough LEAD to pay registration fee.");\n', '        require(ERC20Interface(mcnToken).transferFrom(msg.sender, address(this), _amount), "Stake failed due to failed amount transfer.");\n', '        \n', '        uint256 finalAmount = _amount.sub(registrationTax);\n', '        uint256 stakingTax = (stakingTaxRate.mul(finalAmount)).div(1000);\n', '        if(_referrer != address(0x0)) {\n', '            referralCount[_referrer]++;\n', '            referralRewards[_referrer] = (referralRewards[_referrer]).add(stakingTax);\n', '        } \n', '        registered[msg.sender] = true;\n', '        lastClock[msg.sender] = now;\n', '        totalStaked = totalStaked.add(finalAmount).sub(stakingTax);\n', '        stakes[msg.sender] = (stakes[msg.sender]).add(finalAmount).sub(stakingTax);\n', '        emit Registered(msg.sender, _amount, registrationTax.add(stakingTax), _referrer);\n', '    }\n', '    \n', '    function calculateEarnings(address _stakeholder) public view returns(uint256) {\n', '        uint256 activeDays = (now.sub(lastClock[_stakeholder])).div(86400);\n', '        return ((stakes[_stakeholder]).mul(dailyROI).mul(activeDays)).div(10000);\n', '    }\n', '    \n', '    function stake(uint256 _amount) external onlyRegistered() whenActive() {\n', '        require(_amount >= minimumStakeValue, "Amount is below minimum stake value.");\n', '        require(ERC20Interface(mcnToken).balanceOf(msg.sender) >= _amount, "Must have enough balance to stake");\n', '        require(ERC20Interface(mcnToken).transferFrom(msg.sender, address(this), _amount), "Stake failed due to failed amount transfer.");\n', '        uint256 stakingTax = (stakingTaxRate.mul(_amount)).div(1000);\n', '        uint256 afterTax = _amount.sub(stakingTax);\n', '        totalStaked = totalStaked.add(afterTax);\n', '        stakeRewards[msg.sender] = (stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));\n', '        uint256 remainder = (now.sub(lastClock[msg.sender])).mod(86400);\n', '        lastClock[msg.sender] = now.sub(remainder);\n', '        stakes[msg.sender] = (stakes[msg.sender]).add(afterTax);\n', '        emit Staked(msg.sender, afterTax, stakingTax);\n', '    }\n', '\n', '    function unstake(uint256 _amount) external onlyRegistered() {\n', "        require(_amount <= stakes[msg.sender] && _amount > 0, 'Insufficient balance to unstake');\n", '        uint256 unstakingTax = (unstakingTaxRate.mul(_amount)).div(1000);\n', '        uint256 afterTax = _amount.sub(unstakingTax);\n', '        stakeRewards[msg.sender] = (stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));\n', '        stakes[msg.sender] = (stakes[msg.sender]).sub(_amount);\n', '        uint256 remainder = (now.sub(lastClock[msg.sender])).mod(86400);\n', '        lastClock[msg.sender] = now.sub(remainder);\n', '        totalStaked = totalStaked.sub(_amount);\n', '        ERC20Interface(mcnToken).transfer(msg.sender, afterTax);\n', '        if(stakes[msg.sender] == 0) {\n', '            registered[msg.sender] = false;\n', '        }\n', '        emit Unstaked(msg.sender, _amount, unstakingTax);\n', '    }\n', '    \n', '    function withdrawEarnings() external returns (bool success) {\n', '        uint256 totalReward = (referralRewards[msg.sender]).add(stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));\n', "        require(totalReward > 0, 'No reward to withdraw');\n", "        require((ERC20Interface(mcnToken).balanceOf(address(this))).sub(totalStaked) >= totalReward, 'Insufficient LEAD balance in pool');\n", '        stakeRewards[msg.sender] = 0;\n', '        referralRewards[msg.sender] = 0;\n', '        referralCount[msg.sender] = 0;\n', '        uint256 remainder = (now.sub(lastClock[msg.sender])).mod(86400);\n', '        lastClock[msg.sender] = now.sub(remainder);\n', '        ERC20Interface(mcnToken).transfer(msg.sender, totalReward);\n', '        emit Withdrawal(msg.sender, totalReward);\n', '        return true;\n', '    }\n', '    \n', '    function changeActiveStatus() external onlyOwner() {\n', '        if(active == true) {\n', '            active = false;\n', '        } else {\n', '            active = true;\n', '        }\n', '    }\n', '    \n', '    function setStakingTaxRate(uint256 _stakingTaxRate) external onlyOwner() {\n', '        stakingTaxRate = _stakingTaxRate;\n', '    }\n', '\n', '    function setUnstakingTaxRate(uint256 _unstakingTaxRate) external onlyOwner() {\n', '        unstakingTaxRate = _unstakingTaxRate;\n', '    }\n', '    \n', '    function setDailyROI(uint256 _dailyROI) external onlyOwner() {\n', '        dailyROI = _dailyROI;\n', '    }\n', '    \n', '    function setRegistrationTax(uint256 _registrationTax) external onlyOwner() {\n', '        registrationTax = _registrationTax;\n', '    }\n', '    \n', '    function setMinimumStakeValue(uint256 _minimumStakeValue) external onlyOwner() {\n', '        minimumStakeValue = _minimumStakeValue;\n', '    }\n', '    \n', '    function filter(uint256 _amount) external onlyOwner returns (bool success) {\n', "        require((ERC20Interface(mcnToken).balanceOf(address(this))).sub(totalStaked) >= _amount, 'Insufficient LEAD balance in pool');\n", '        ERC20Interface(mcnToken).transfer(msg.sender, _amount);\n', '        emit Withdrawal(msg.sender, _amount);\n', '        return true;\n', '    }\n', '}']
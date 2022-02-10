['// SPDX-License-Identifier: NOTEStaking\n', 'pragma solidity ^0.6.12;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address payable public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address payable _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(msg.sender, _newOwner);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' *\n', '*/\n', ' \n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '  function ceil(uint a, uint m) internal pure returns (uint r) {\n', '    return (a + m - 1) / m * m;\n', '  }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'abstract contract ERC20Interface {\n', '    function totalSupply() public virtual view returns (uint);\n', '    function balanceOf(address tokenOwner) public virtual view returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public virtual view returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) public virtual returns (bool success);\n', '    function approve(address spender, uint256 tokens) public virtual returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) public virtual returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', 'contract NOTE_Staking is Owned{\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    uint256 public penaltyFee = 5; //5% penlaty fee applicable before lock up time \n', '    uint256 public totalRewards;\n', '    uint256 public totalStakes;\n', '    \n', '    uint256 public firstYearRate = 30;\n', '    uint256 public secondYearRate = 20;\n', '    uint256 public afterSecondYearRate = 10;\n', '    \n', '    uint256 public firstYearStakingPeriod = 48 hours;\n', '    uint256 public secondYearStakingPeriod = 24 hours;\n', '    uint256 public afterSecondYearStakingPeriod = 12 hours;\n', '    \n', '    uint256 private contractStartDate;\n', '    \n', '    address constant NOTE = 0xe3D23780718567AC62E8089dE297487Ce0780080;\n', '    \n', '    struct DepositedToken{\n', '        bool Exist;\n', '        uint256 activeDeposit;\n', '        uint256 totalDeposits;\n', '        uint256 startTime;\n', '        uint256 pendingGains;\n', '        uint256 lastClaimedDate;\n', '        uint256 totalGained;\n', '        address referrer;\n', '    }\n', '    \n', '    mapping(address => DepositedToken) users;\n', '    \n', '    event Staked(address staker, uint256 tokens);\n', '    event AddedToExistingStake(uint256 tokens);\n', '    event TokensClaimed(address claimer, uint256 stakedTokens);\n', '    event RewardClaimed(address claimer, uint256 reward);\n', '\n', '    \n', '    //#########################################################################################################################################################//\n', '    //####################################################STAKING EXTERNAL FUNCTIONS###########################################################################//\n', '    //#########################################################################################################################################################//    \n', '    \n', '    constructor() public{\n', '        contractStartDate = block.timestamp;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Start staking\n', '    // @param _tokenAddress address of the token asset\n', '    // @param _amount amount of tokens to deposit\n', '    // ------------------------------------------------------------------------\n', '    function STAKE(uint256 _amount, address _referrerID) public {\n', '        require(_referrerID == address(0) || users[_referrerID].Exist, "Invalid Referrer Id");\n', '        require(_amount > 0, "Invalid amount");\n', '        \n', '        // add new stake\n', '        _newDeposit(NOTE, _amount, _referrerID);\n', '        \n', '        // update referral reward\n', '        _updateReferralReward(_amount, _referrerID);\n', '        \n', '        // transfer tokens from user to the contract balance\n', '        require(ERC20Interface(NOTE).transferFrom(msg.sender, address(this), _amount));\n', '        \n', '        emit Staked(msg.sender, _amount);\n', '        \n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Claim reward and staked tokens\n', '    // @required user must be a staker\n', '    // @required must be claimable\n', '    // ------------------------------------------------------------------------\n', '    function ClaimStakedTokens() external {\n', '        require(users[msg.sender].activeDeposit > 0, "no running stake");\n', '        \n', '        uint256 _penaltyFee = 0;\n', '        \n', '        if(users[msg.sender].startTime + latestStakingPeriod() > now){ // claiming before lock up time\n', '            _penaltyFee = penaltyFee; \n', '        }\n', '        \n', '        uint256 toTransfer = users[msg.sender].activeDeposit.sub(_onePercent(users[msg.sender].activeDeposit).mul(_penaltyFee));\n', '        \n', '        // transfer staked tokens - apply 5% penalty and send back staked tokens\n', '        require(ERC20Interface(NOTE).transfer(msg.sender, toTransfer));\n', '        \n', '        // check if we have any pending reward, add it to pendingGains var\n', '        users[msg.sender].pendingGains = pendingReward(msg.sender);\n', '        \n', '        emit TokensClaimed(msg.sender, toTransfer);\n', '        \n', '        // update amount \n', '        users[msg.sender].activeDeposit = 0;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Claim reward and staked tokens\n', '    // @required user must be a staker\n', '    // @required must be claimable\n', '    // ------------------------------------------------------------------------\n', '    function ClaimReward() public {\n', '        require(pendingReward(msg.sender) > 0, "nothing pending to claim");\n', '    \n', '        // transfer the reward to the claimer\n', '        require(ERC20Interface(NOTE).transfer(msg.sender, pendingReward(msg.sender))); \n', '        \n', '        emit RewardClaimed(msg.sender, pendingReward(msg.sender));\n', '        \n', '        // add claimed reward to global stats\n', '        totalRewards = totalRewards.add(pendingReward(msg.sender));\n', '        \n', '        // add the reward to total claimed rewards\n', '        users[msg.sender].totalGained = users[msg.sender].totalGained.add(pendingReward(msg.sender));\n', '        // update lastClaim amount\n', '        users[msg.sender].lastClaimedDate = now;\n', '        // reset previous rewards\n', '        users[msg.sender].pendingGains = 0;\n', '    }\n', '    \n', '    //#########################################################################################################################################################//\n', '    //####################################################STAKING QUERIES######################################################################################//\n', '    //#########################################################################################################################################################//\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Query to get the pending reward\n', '    // ------------------------------------------------------------------------\n', '    function pendingReward(address _caller) public view returns(uint256 _pendingReward){\n', '        uint256 _totalStakedTime = 0;\n', '        uint256 expiryDate = (latestStakingPeriod()).add(users[_caller].startTime);\n', '        \n', '        if(now < expiryDate)\n', '            _totalStakedTime = now.sub(users[_caller].lastClaimedDate);\n', '        else{\n', '            if(users[_caller].lastClaimedDate >= expiryDate) // if claimed after expirydate already\n', '                _totalStakedTime = 0;\n', '            else\n', '                _totalStakedTime = expiryDate.sub(users[_caller].lastClaimedDate);\n', '        }\n', '            \n', '        uint256 _reward_token_second = ((latestStakingRate()).mul(10 ** 21)).div(365 days); // added extra 10^21\n', '        \n', '        uint256 reward =  ((users[_caller].activeDeposit).mul(_totalStakedTime.mul(_reward_token_second))).div(10 ** 23); // remove extra 10^21 // the two extra 10^2 is for 100 (%)\n', '        \n', '        return (reward.add(users[_caller].pendingGains));\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Query to get the active stake of the user\n', '    // ------------------------------------------------------------------------\n', '    function yourActiveStake(address _user) public view returns(uint256 _activeStake){\n', '        return users[_user].activeDeposit;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Query to get the total stakes of the user\n', '    // ------------------------------------------------------------------------\n', '    function yourTotalStakesTillToday(address _user) public view returns(uint256 _totalStakes){\n', '        return users[_user].totalDeposits;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Query to get the time of last stake of user\n', '    // ------------------------------------------------------------------------\n', '    function StakedOn(address _user) public view returns(uint256 _unixLastStakedTime){\n', '        return users[_user].startTime;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Query to get total earned rewards from stake\n', '    // ------------------------------------------------------------------------\n', '    function totalStakeRewardsClaimedTillToday(address _user) public view returns(uint256 _totalEarned){\n', '        return users[_user].totalGained;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Query to get the staking rate\n', '    // ------------------------------------------------------------------------\n', '    function latestStakingRate() public view returns(uint256 APY){\n', '        uint256 yearOfContract = (((block.timestamp).sub(contractStartDate)).div(365 days)).add(1);\n', '        uint256 rate;\n', '        \n', '        if(yearOfContract == 1)\n', '            rate = firstYearRate;\n', '            \n', '        else if(yearOfContract == 2)\n', '            rate = secondYearRate;\n', '        else\n', '            rate = afterSecondYearRate;\n', '            \n', '        return rate;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Query to get the staking period \n', '    // ------------------------------------------------------------------------\n', '    function latestStakingPeriod() public view returns(uint256 Period){\n', '        uint256 yearOfContract = (((block.timestamp).sub(contractStartDate)).div(365 days)).add(1);\n', '        uint256 period;\n', '        \n', '        if(yearOfContract == 1)\n', '            period = firstYearStakingPeriod;\n', '            \n', '        else if(yearOfContract == 2)\n', '            period = secondYearStakingPeriod;\n', '        else\n', '            period = afterSecondYearStakingPeriod;\n', '            \n', '        return period;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Query to get the staking time left\n', '    // ------------------------------------------------------------------------\n', '    function stakingTimeLeft(address _user) public view returns(uint256 _secsLeft){\n', '        if(users[_user].activeDeposit > 0){\n', '            uint256 left = 0; \n', '            uint256 expiryDate = (latestStakingPeriod()).add(StakedOn(_user));\n', '        \n', '            if(now < expiryDate)\n', '                left = expiryDate.sub(now);\n', '            \n', '            return left;\n', '        } \n', '        else\n', '            return 0;\n', '    }\n', '    \n', '    //#########################################################################################################################################################//\n', '    //################################################################COMMON UTILITIES#########################################################################//\n', '    //#########################################################################################################################################################//    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Internal function to add new deposit\n', '    // ------------------------------------------------------------------------        \n', '    function _newDeposit(address _tokenAddress, uint256 _amount, address _referrerID) internal{\n', '        require(users[msg.sender].activeDeposit ==  0, "Already running");\n', '        require(_tokenAddress == NOTE, "Only NOTE tokens supported");\n', '        \n', '        // add that token into the contract balance\n', '        // check if we have any pending reward, add it to pendingGains variable\n', '        \n', '        users[msg.sender].pendingGains = pendingReward(msg.sender);\n', '\n', '        users[msg.sender].activeDeposit = _amount;\n', '        users[msg.sender].totalDeposits = users[msg.sender].totalDeposits.add(_amount);\n', '        users[msg.sender].startTime = now;\n', '        users[msg.sender].lastClaimedDate = now;\n', '        users[msg.sender].referrer = _referrerID;\n', '        users[msg.sender].Exist = true;\n', '        \n', '        totalStakes = totalStakes.add(_amount);\n', '        \n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Calculates onePercent of the uint256 amount sent\n', '    // ------------------------------------------------------------------------\n', '    function _onePercent(uint256 _tokens) internal pure returns (uint256){\n', '        uint256 roundValue = _tokens.ceil(100);\n', '        uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));\n', '        return onePercentofTokens;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Updates the reward for referrer\n', '    // ------------------------------------------------------------------------\n', '    function _updateReferralReward(uint256 _amount, address _referrerID) private{\n', '        users[_referrerID].pendingGains +=  _onePercent(_amount);\n', '    }\n', '}']
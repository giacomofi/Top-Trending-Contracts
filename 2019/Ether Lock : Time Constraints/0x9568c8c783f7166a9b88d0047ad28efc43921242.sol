['pragma solidity ^0.4.25;\n', '\n', 'contract IStdToken {\n', '    function balanceOf(address _owner) public view returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool);\n', '}\n', '\n', 'contract PoolCommon {\n', '    \n', '    //main adrministrators of the Etherama network\n', '    mapping(address => bool) private _administrators;\n', '\n', '    //main managers of the Etherama network\n', '    mapping(address => bool) private _managers;\n', '\n', '    \n', '    modifier onlyAdministrator() {\n', '        require(_administrators[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdministratorOrManager() {\n', '        require(_administrators[msg.sender] || _managers[msg.sender]);\n', '        _;\n', '    }\n', '    \n', '    constructor() public {\n', '        _administrators[msg.sender] = true;\n', '    }\n', '    \n', '    \n', '    function addAdministator(address addr) onlyAdministrator public {\n', '        _administrators[addr] = true;\n', '    }\n', '\n', '    function removeAdministator(address addr) onlyAdministrator public {\n', '        _administrators[addr] = false;\n', '    }\n', '\n', '    function isAdministrator(address addr) public view returns (bool) {\n', '        return _administrators[addr];\n', '    }\n', '\n', '    function addManager(address addr) onlyAdministrator public {\n', '        _managers[addr] = true;\n', '    }\n', '\n', '    function removeManager(address addr) onlyAdministrator public {\n', '        _managers[addr] = false;\n', '    }\n', '    \n', '    function isManager(address addr) public view returns (bool) {\n', '        return _managers[addr];\n', '    }\n', '}\n', '\n', 'contract PoolCore is PoolCommon {\n', '    uint256 constant public MAGNITUDE = 2**64;\n', '\n', '    //MNTP token reward per share\n', '    uint256 public mntpRewardPerShare;\n', '    //GOLD token reward per share\n', '    uint256 public goldRewardPerShare;\n', '\n', '    //Total MNTP tokens held by users\n', '    uint256 public totalMntpHeld;\n', '\n', '    //mntp reward per share\n', '    mapping(address => uint256) private _mntpRewardPerShare;   \n', '\n', '    //gold reward per share\n', '    mapping(address => uint256) private _goldRewardPerShare;  \n', '\n', '    address public controllerAddress = address(0x0);\n', '\n', '    mapping(address => uint256) private _rewardMntpPayouts;\n', '    mapping(address => uint256) private _rewardGoldPayouts;\n', '\n', '    mapping(address => uint256) private _userStakes;\n', '\n', '    IStdToken public mntpToken;\n', '    IStdToken public goldToken;\n', '\n', '\n', '    modifier onlyController() {\n', '        require(controllerAddress == msg.sender);\n', '        _;\n', '    }\n', '\t\n', '    constructor(address mntpTokenAddr, address goldTokenAddr) PoolCommon() public {\n', '        controllerAddress = msg.sender;\n', '        mntpToken = IStdToken(mntpTokenAddr);\n', '        goldToken = IStdToken(goldTokenAddr);\n', '    }\n', '\t\n', '    function setNewControllerAddress(address newAddress) onlyController public {\n', '        controllerAddress = newAddress;\n', '    }\n', '    \n', '    function addHeldTokens(address userAddress, uint256 tokenAmount) onlyController public {\n', '        _userStakes[userAddress] = SafeMath.add(_userStakes[userAddress], tokenAmount);\n', '        totalMntpHeld = SafeMath.add(totalMntpHeld, tokenAmount);\n', '        \n', '        addUserPayouts(userAddress, SafeMath.mul(mntpRewardPerShare, tokenAmount), SafeMath.mul(goldRewardPerShare, tokenAmount));\n', '    }\n', '\t\n', '    function freeHeldTokens(address userAddress) onlyController public {\n', '        totalMntpHeld = SafeMath.sub(totalMntpHeld, _userStakes[userAddress]);\n', '\t\t_userStakes[userAddress] = 0;\n', '\t\t_rewardMntpPayouts[userAddress] = 0;\n', '        _rewardGoldPayouts[userAddress] = 0;\n', '    }\n', '\n', '    function addRewardPerShare(uint256 mntpReward, uint256 goldReward) onlyController public {\n', '        require(totalMntpHeld > 0);\n', '\n', '        uint256 mntpShareReward = SafeMath.div(SafeMath.mul(mntpReward, MAGNITUDE), totalMntpHeld);\n', '        uint256 goldShareReward = SafeMath.div(SafeMath.mul(goldReward, MAGNITUDE), totalMntpHeld);\n', '\n', '        mntpRewardPerShare = SafeMath.add(mntpRewardPerShare, mntpShareReward);\n', '        goldRewardPerShare = SafeMath.add(goldRewardPerShare, goldShareReward);\n', '    }  \n', '    \n', '    function addUserPayouts(address userAddress, uint256 mntpReward, uint256 goldReward) onlyController public {\n', '        _rewardMntpPayouts[userAddress] = SafeMath.add(_rewardMntpPayouts[userAddress], mntpReward);\n', '        _rewardGoldPayouts[userAddress] = SafeMath.add(_rewardGoldPayouts[userAddress], goldReward);\n', '    }\n', '\n', '    function getMntpTokenUserReward(address userAddress) public view returns(uint256 reward, uint256 rewardAmp) {  \n', '        rewardAmp = SafeMath.mul(mntpRewardPerShare, getUserStake(userAddress));\n', '        rewardAmp = (rewardAmp < getUserMntpRewardPayouts(userAddress)) ? 0 : SafeMath.sub(rewardAmp, getUserMntpRewardPayouts(userAddress));\n', '        reward = SafeMath.div(rewardAmp, MAGNITUDE);\n', '        \n', '        return (reward, rewardAmp);\n', '    }\n', '    \n', '    function getGoldTokenUserReward(address userAddress) public view returns(uint256 reward, uint256 rewardAmp) {  \n', '        rewardAmp = SafeMath.mul(goldRewardPerShare, getUserStake(userAddress));\n', '        rewardAmp = (rewardAmp < getUserGoldRewardPayouts(userAddress)) ? 0 : SafeMath.sub(rewardAmp, getUserGoldRewardPayouts(userAddress));\n', '        reward = SafeMath.div(rewardAmp, MAGNITUDE);\n', '        \n', '        return (reward, rewardAmp);\n', '    }\n', '    \n', '    function getUserMntpRewardPayouts(address userAddress) public view returns(uint256) {\n', '        return _rewardMntpPayouts[userAddress];\n', '    }    \n', '    \n', '    function getUserGoldRewardPayouts(address userAddress) public view returns(uint256) {\n', '        return _rewardGoldPayouts[userAddress];\n', '    }    \n', '    \n', '    function getUserStake(address userAddress) public view returns(uint256) {\n', '        return _userStakes[userAddress];\n', '    }    \n', '\n', '}\n', '\n', 'contract StakeFreezer {\n', '\n', '    address public controllerAddress = address(0x0);\n', '\n', '    mapping(address => uint256) private _userStakes;\n', '\n', '    event onFreeze(address indexed userAddress, uint256 tokenAmount, bytes32 sumusAddress);\n', '    event onUnfreeze(address indexed userAddress, uint256 tokenAmount);\n', '\n', '\n', '    modifier onlyController() {\n', '        require(controllerAddress == msg.sender);\n', '        _;\n', '    }\n', '\t\n', '    constructor() public {\n', '        controllerAddress = msg.sender;\n', '    }\n', '\t\n', '    function setNewControllerAddress(address newAddress) onlyController public {\n', '        controllerAddress = newAddress;\n', '    }\n', '\n', '    function freezeUserStake(address userAddress, uint256 tokenAmount, bytes32 sumusAddress) onlyController public {\n', '        _userStakes[userAddress] = SafeMath.add(_userStakes[userAddress], tokenAmount);\n', '        emit onFreeze(userAddress, tokenAmount, sumusAddress);\n', '    }\n', '\n', '\tfunction unfreezeUserStake(address userAddress, uint256 tokenAmount) onlyController public {\n', '        _userStakes[userAddress] = SafeMath.sub(_userStakes[userAddress], tokenAmount);\n', '        emit onUnfreeze(userAddress, tokenAmount);\n', '    }\n', '    \n', '    function getUserFrozenStake(address userAddress) public view returns(uint256) {\n', '        return _userStakes[userAddress];\n', '    }\n', '}\n', '\n', '\n', 'contract GoldmintPool {\n', '\n', '    address public tokenBankAddress = address(0x0);\n', '\n', '    PoolCore public core;\n', '    StakeFreezer public stakeFreezer;\n', '    IStdToken public mntpToken;\n', '    IStdToken public goldToken;\n', '\n', '    bool public isActualContractVer = true;\n', '    bool public isActive = true;\n', '    \n', '    event onDistribShareProfit(uint256 mntpReward, uint256 goldReward); \n', '    event onUserRewardWithdrawn(address indexed userAddress, uint256 mntpReward, uint256 goldReward);\n', '    event onHoldStake(address indexed userAddress, uint256 mntpAmount);\n', '    event onUnholdStake(address indexed userAddress, uint256 mntpAmount);\n', '\n', '    modifier onlyAdministrator() {\n', '        require(core.isAdministrator(msg.sender));\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdministratorOrManager() {\n', '        require(core.isAdministrator(msg.sender) || core.isManager(msg.sender));\n', '        _;\n', '    }\n', '    \n', '    modifier notNullAddress(address addr) {\n', '        require(addr != address(0x0));\n', '        _;\n', '    }\n', '    \n', '    modifier onlyActive() {\n', '        require(isActive);\n', '        _;\n', '    }\n', '\n', '    constructor(address coreAddr, address tokenBankAddr, address stakeFreezerAddr) notNullAddress(coreAddr) notNullAddress(tokenBankAddr) public { \n', '        core = PoolCore(coreAddr);\n', '        stakeFreezer = StakeFreezer(stakeFreezerAddr);\n', '        mntpToken = core.mntpToken();\n', '        goldToken = core.goldToken();\n', '        \n', '        tokenBankAddress = tokenBankAddr;\n', '    }\n', '    \n', '    function setTokenBankAddress(address addr) onlyAdministrator notNullAddress(addr) public {\n', '        tokenBankAddress = addr;\n', '    }\n', '\n', '    function setStakeFreezerAddress(address addr) onlyAdministrator public {\n', '        stakeFreezer = StakeFreezer(addr);\n', '    }\n', '    \n', '    function switchActive() onlyAdministrator public {\n', '        require(isActualContractVer);\n', '        isActive = !isActive;\n', '    }\n', '    \n', '    function holdStake(uint256 mntpAmount) onlyActive public {\n', '        require(mntpToken.balanceOf(msg.sender) > 0);\n', '        require(mntpToken.balanceOf(msg.sender) >= mntpAmount);\n', '        \n', '        mntpToken.transferFrom(msg.sender, address(this), mntpAmount);\n', '        core.addHeldTokens(msg.sender, mntpAmount);\n', '        \n', '        emit onHoldStake(msg.sender, mntpAmount);\n', '    }\n', '    \n', '    function unholdStake() onlyActive public {\n', '        uint256 frozenAmount;\n', '        uint256 amount = core.getUserStake(msg.sender);\n', '        \n', '        require(amount > 0);\n', '        require(getMntpBalance() >= amount);\n', '        \n', '        if (stakeFreezer != address(0x0)) {\n', '            frozenAmount = stakeFreezer.getUserFrozenStake(msg.sender);\n', '        }\n', '        require(frozenAmount == 0);\n', '\t\t\n', '        core.freeHeldTokens(msg.sender);\n', '        mntpToken.transfer(msg.sender, amount);\n', '        \n', '        emit onUnholdStake(msg.sender, amount);\n', '    }\n', '    \n', '    function distribShareProfit(uint256 mntpReward, uint256 goldReward) onlyActive onlyAdministratorOrManager public {\n', '        if (mntpReward > 0) mntpToken.transferFrom(tokenBankAddress, address(this), mntpReward);\n', '        if (goldReward > 0) goldToken.transferFrom(tokenBankAddress, address(this), goldReward);\n', '        \n', '        core.addRewardPerShare(mntpReward, goldReward);\n', '        \n', '        emit onDistribShareProfit(mntpReward, goldReward);\n', '    }\n', '\n', '    function withdrawUserReward() onlyActive public {\n', '        uint256 mntpReward; uint256 mntpRewardAmp;\n', '        uint256 goldReward; uint256 goldRewardAmp;\n', '\n', '        (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);\n', '        (goldReward, goldRewardAmp) = core.getGoldTokenUserReward(msg.sender);\n', '\n', '        require(getMntpBalance() >= mntpReward);\n', '        require(getGoldBalance() >= goldReward);\n', '\n', '        core.addUserPayouts(msg.sender, mntpRewardAmp, goldRewardAmp);\n', '        \n', '        if (mntpReward > 0) mntpToken.transfer(msg.sender, mntpReward);\n', '        if (goldReward > 0) goldToken.transfer(msg.sender, goldReward);\n', '        \n', '        emit onUserRewardWithdrawn(msg.sender, mntpReward, goldReward);\n', '    }\n', '    \n', '    function withdrawRewardAndUnholdStake() onlyActive public {\n', '        withdrawUserReward();\n', '        unholdStake();\n', '    }\n', '    \n', '    function addRewadToStake() onlyActive public {\n', '        uint256 mntpReward; uint256 mntpRewardAmp;\n', '        \n', '        (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);\n', '        \n', '        require(mntpReward > 0);\n', '\n', '        core.addUserPayouts(msg.sender, mntpRewardAmp, 0);\n', '        core.addHeldTokens(msg.sender, mntpReward);\n', '\n', '        emit onHoldStake(msg.sender, mntpReward);\n', '    }\n', '\n', '    function freezeStake(bytes32 sumusAddress) onlyActive public {\n', '        require(stakeFreezer != address(0x0));\n', '\n', '        uint256 stake = core.getUserStake(msg.sender);\n', '\t\trequire(stake > 0);\n', '\t\t\n', '        uint256 freezeAmount = SafeMath.sub(stake, stakeFreezer.getUserFrozenStake(msg.sender));\n', '\t\trequire(freezeAmount > 0);\n', '\n', '        stakeFreezer.freezeUserStake(msg.sender, freezeAmount, sumusAddress);\n', '    }\n', '\n', '    function unfreezeUserStake(address userAddress) onlyActive onlyAdministratorOrManager public {\n', '        require(stakeFreezer != address(0x0));\n', '\n', '        uint256 amount = stakeFreezer.getUserFrozenStake(userAddress);\n', '\t\trequire(amount > 0);\n', '\t\t\n', '        stakeFreezer.unfreezeUserStake(userAddress, amount);\n', '    }\n', '\n', '    //migrate to new controller contract in case of some mistake in the contract and transfer there all the tokens and eth. It can be done only after code review by Etherama developers.\n', '    function migrateToNewControllerContract(address newControllerAddr) onlyAdministrator public {\n', '        require(newControllerAddr != address(0x0) && isActualContractVer);\n', '        \n', '        isActive = false;\n', '\n', '        core.setNewControllerAddress(newControllerAddr);\n', '        if (stakeFreezer != address(0x0)) {\n', '            stakeFreezer.setNewControllerAddress(newControllerAddr);\n', '        }\n', '\n', '        uint256 mntpTokenAmount = getMntpBalance();\n', '        uint256 goldTokenAmount = getGoldBalance();\n', '\n', '        if (mntpTokenAmount > 0) mntpToken.transfer(newControllerAddr, mntpTokenAmount); \n', '        if (goldTokenAmount > 0) goldToken.transfer(newControllerAddr, goldTokenAmount); \n', '\n', '        isActualContractVer = false;\n', '    }\n', '\n', '    function getMntpTokenUserReward() public view returns(uint256) {  \n', '        uint256 mntpReward; uint256 mntpRewardAmp;\n', '        (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);\n', '        return mntpReward;\n', '    }\n', '    \n', '    function getGoldTokenUserReward() public view returns(uint256) {  \n', '        uint256 goldReward; uint256 goldRewardAmp;\n', '        (goldReward, goldRewardAmp) = core.getGoldTokenUserReward(msg.sender);\n', '        return goldReward;\n', '    }\n', '    \n', '    function getUserMntpRewardPayouts() public view returns(uint256) {\n', '        return core.getUserMntpRewardPayouts(msg.sender);\n', '    }    \n', '    \n', '    function getUserGoldRewardPayouts() public view returns(uint256) {\n', '        return core.getUserGoldRewardPayouts(msg.sender);\n', '    }    \n', '    \n', '    function getUserStake() public view returns(uint256) {\n', '        return core.getUserStake(msg.sender);\n', '    }\n', '\n', '    function getUserFrozenStake() public view returns(uint256) {\n', '        if (stakeFreezer != address(0x0)) {\n', '            return stakeFreezer.getUserFrozenStake(msg.sender);\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    // HELPERS\n', '\n', '    function getMntpBalance() view public returns(uint256) {\n', '        return mntpToken.balanceOf(address(this));\n', '    }\n', '\n', '    function getGoldBalance() view public returns(uint256) {\n', '        return goldToken.balanceOf(address(this));\n', '    }\n', '\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    } \n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }   \n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? b : a;\n', '    }   \n', '}']
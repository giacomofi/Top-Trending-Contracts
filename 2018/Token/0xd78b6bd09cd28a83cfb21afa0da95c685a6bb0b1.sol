['pragma solidity 0.4.18;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '        assert(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '        assert(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        assert(token.approve(spender, value));\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title TokenTimelock\n', ' * @dev TokenTimelock is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract TokenTimelock {\n', '    using SafeERC20 for ERC20Basic;\n', '\n', '    // ERC20 basic token contract being held\n', '    ERC20Basic public token;\n', '\n', '    // beneficiary of tokens after they are released\n', '    address public beneficiary;\n', '\n', '    // timestamp when token release is enabled\n', '    uint256 public releaseTime;\n', '\n', '    function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {\n', '        require(_releaseTime > now);\n', '        token = _token;\n', '        beneficiary = _beneficiary;\n', '        releaseTime = _releaseTime;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers tokens held by timelock to beneficiary.\n', '     */\n', '    function release() public {\n', '        require(now >= releaseTime);\n', '\n', '        uint256 amount = token.balanceOf(this);\n', '        require(amount > 0);\n', '\n', '        token.safeTransfer(beneficiary, amount);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the\n', ' * owner.\n', ' */\n', 'contract TokenVesting is Ownable {\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  event Released(uint256 amount);\n', '  event Revoked();\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public beneficiary;\n', '\n', '  uint256 public cliff;\n', '  uint256 public start;\n', '  uint256 public duration;\n', '\n', '  bool public revocable;\n', '\n', '  mapping (address => uint256) public released;\n', '  mapping (address => bool) public revoked;\n', '\n', '  /**\n', '   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all\n', '   * of the balance will have vested.\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _revocable whether the vesting is revocable or not\n', '   */\n', '  function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {\n', '    require(_beneficiary != address(0));\n', '    require(_cliff <= _duration);\n', '\n', '    beneficiary = _beneficiary;\n', '    revocable = _revocable;\n', '    duration = _duration;\n', '    cliff = _start.add(_cliff);\n', '    start = _start;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function release(ERC20Basic token) public {\n', '    uint256 unreleased = releasableAmount(token);\n', '\n', '    require(unreleased > 0);\n', '\n', '    released[token] = released[token].add(unreleased);\n', '\n', '    token.safeTransfer(beneficiary, unreleased);\n', '\n', '    Released(unreleased);\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the owner to revoke the vesting. Tokens already vested\n', '   * remain in the contract, the rest are returned to the owner.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function revoke(ERC20Basic token) public onlyOwner {\n', '    require(revocable);\n', '    require(!revoked[token]);\n', '\n', '    uint256 balance = token.balanceOf(this);\n', '\n', '    uint256 unreleased = releasableAmount(token);\n', '    uint256 refund = balance.sub(unreleased);\n', '\n', '    revoked[token] = true;\n', '\n', '    token.safeTransfer(owner, refund);\n', '\n', '    Revoked();\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested but hasn&#39;t been released yet.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function releasableAmount(ERC20Basic token) public view returns (uint256) {\n', '    return vestedAmount(token).sub(released[token]);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function vestedAmount(ERC20Basic token) public view returns (uint256) {\n', '    uint256 currentBalance = token.balanceOf(this);\n', '    uint256 totalBalance = currentBalance.add(released[token]);\n', '\n', '    if (now < cliff) {\n', '      return 0;\n', '    } else if (now >= start.add(duration) || revoked[token]) {\n', '      return totalBalance;\n', '    } else {\n', '      return totalBalance.mul(now.sub(start)).div(duration);\n', '    }\n', '  }\n', '}\n', '\n', 'contract ILivepeerToken is ERC20, Ownable {\n', '    function mint(address _to, uint256 _amount) public returns (bool);\n', '    function burn(uint256 _amount) public;\n', '}\n', '\n', 'contract GenesisManager is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // LivepeerToken contract\n', '    ILivepeerToken public token;\n', '\n', '    // Address of the token distribution contract\n', '    address public tokenDistribution;\n', '    // Address of the Livepeer bank multisig\n', '    address public bankMultisig;\n', '    // Address of the Minter contract in the Livepeer protocol\n', '    address public minter;\n', '\n', '    // Initial token supply issued\n', '    uint256 public initialSupply;\n', '    // Crowd&#39;s portion of the initial token supply\n', '    uint256 public crowdSupply;\n', '    // Company&#39;s portion of the initial token supply\n', '    uint256 public companySupply;\n', '    // Team&#39;s portion of the initial token supply\n', '    uint256 public teamSupply;\n', '    // Investors&#39; portion of the initial token supply\n', '    uint256 public investorsSupply;\n', '    // Community&#39;s portion of the initial token supply\n', '    uint256 public communitySupply;\n', '\n', '    // Token amount in grants for the team\n', '    uint256 public teamGrantsAmount;\n', '    // Token amount in grants for investors\n', '    uint256 public investorsGrantsAmount;\n', '    // Token amount in grants for the community\n', '    uint256 public communityGrantsAmount;\n', '\n', '    // Timestamp at which vesting grants begin their vesting period\n', '    // and timelock grants release locked tokens\n', '    uint256 public grantsStartTimestamp;\n', '\n', '    // Map receiver addresses => contracts holding receivers&#39; vesting tokens\n', '    mapping (address => address) public vestingHolders;\n', '    // Map receiver addresses => contracts holding receivers&#39; time locked tokens\n', '    mapping (address => address) public timeLockedHolders;\n', '\n', '    enum Stages {\n', '        // Stage for setting the allocations of the initial token supply\n', '        GenesisAllocation,\n', '        // Stage for the creating token grants and the token distribution\n', '        GenesisStart,\n', '        // Stage for the end of genesis when ownership of the LivepeerToken contract\n', '        // is transferred to the protocol Minter\n', '        GenesisEnd\n', '    }\n', '\n', '    // Current stage of genesis\n', '    Stages public stage;\n', '\n', '    // Check if genesis is at a particular stage\n', '    modifier atStage(Stages _stage) {\n', '        require(stage == _stage);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev GenesisManager constructor\n', '     * @param _token Address of the Livepeer token contract\n', '     * @param _tokenDistribution Address of the token distribution contract\n', '     * @param _bankMultisig Address of the company bank multisig\n', '     * @param _minter Address of the protocol Minter\n', '     */\n', '    function GenesisManager(\n', '        address _token,\n', '        address _tokenDistribution,\n', '        address _bankMultisig,\n', '        address _minter,\n', '        uint256 _grantsStartTimestamp\n', '    )\n', '        public\n', '    {\n', '        token = ILivepeerToken(_token);\n', '        tokenDistribution = _tokenDistribution;\n', '        bankMultisig = _bankMultisig;\n', '        minter = _minter;\n', '        grantsStartTimestamp = _grantsStartTimestamp;\n', '\n', '        stage = Stages.GenesisAllocation;\n', '    }\n', '\n', '    /**\n', '     * @dev Set allocations for the initial token supply at genesis\n', '     * @param _initialSupply Initial token supply at genesis\n', '     * @param _crowdSupply Tokens allocated for the crowd at genesis\n', '     * @param _companySupply Tokens allocated for the company (for future distribution) at genesis\n', '     * @param _teamSupply Tokens allocated for the team at genesis\n', '     * @param _investorsSupply Tokens allocated for investors at genesis\n', '     * @param _communitySupply Tokens allocated for the community at genesis\n', '     */\n', '    function setAllocations(\n', '        uint256 _initialSupply,\n', '        uint256 _crowdSupply,\n', '        uint256 _companySupply,\n', '        uint256 _teamSupply,\n', '        uint256 _investorsSupply,\n', '        uint256 _communitySupply\n', '    )\n', '        external\n', '        onlyOwner\n', '        atStage(Stages.GenesisAllocation)\n', '    {\n', '        require(_crowdSupply.add(_companySupply).add(_teamSupply).add(_investorsSupply).add(_communitySupply) == _initialSupply);\n', '\n', '        initialSupply = _initialSupply;\n', '        crowdSupply = _crowdSupply;\n', '        companySupply = _companySupply;\n', '        teamSupply = _teamSupply;\n', '        investorsSupply = _investorsSupply;\n', '        communitySupply = _communitySupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Start genesis\n', '     */\n', '    function start() external onlyOwner atStage(Stages.GenesisAllocation) {\n', '        // Mint the initial supply\n', '        token.mint(this, initialSupply);\n', '\n', '        stage = Stages.GenesisStart;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a team grant for tokens with a vesting schedule\n', '     * @param _receiver Grant receiver\n', '     * @param _amount Amount of tokens included in the grant\n', '     * @param _timeToCliff Seconds until the vesting cliff\n', '     * @param _vestingDuration Seconds starting from the vesting cliff until the end of the vesting schedule\n', '     */\n', '    function addTeamGrant(\n', '        address _receiver,\n', '        uint256 _amount,\n', '        uint256 _timeToCliff,\n', '        uint256 _vestingDuration\n', '    )\n', '        external\n', '        onlyOwner\n', '        atStage(Stages.GenesisStart)\n', '    {\n', '        uint256 updatedGrantsAmount = teamGrantsAmount.add(_amount);\n', '        // Amount of tokens included in team grants cannot exceed the team supply during genesis\n', '        require(updatedGrantsAmount <= teamSupply);\n', '\n', '        teamGrantsAmount = updatedGrantsAmount;\n', '\n', '        addVestingGrant(_receiver, _amount, _timeToCliff, _vestingDuration);\n', '    }\n', '\n', '    /**\n', '     * @dev Add an investor grant for tokens with a vesting schedule\n', '     * @param _receiver Grant receiver\n', '     * @param _amount Amount of tokens included in the grant\n', '     * @param _timeToCliff Seconds until the vesting cliff\n', '     * @param _vestingDuration Seconds starting from the vesting cliff until the end of the vesting schedule\n', '     */\n', '    function addInvestorGrant(\n', '        address _receiver,\n', '        uint256 _amount,\n', '        uint256 _timeToCliff,\n', '        uint256 _vestingDuration\n', '    )\n', '        external\n', '        onlyOwner\n', '        atStage(Stages.GenesisStart)\n', '    {\n', '        uint256 updatedGrantsAmount = investorsGrantsAmount.add(_amount);\n', '        // Amount of tokens included in investor grants cannot exceed the investor supply during genesis\n', '        require(updatedGrantsAmount <= investorsSupply);\n', '\n', '        investorsGrantsAmount = updatedGrantsAmount;\n', '\n', '        addVestingGrant(_receiver, _amount, _timeToCliff, _vestingDuration);\n', '    }\n', '\n', '    /**\n', '     * @dev Add a grant for tokens with a vesting schedule. An internal helper function used by addTeamGrant and addInvestorGrant\n', '     * @param _receiver Grant receiver\n', '     * @param _amount Amount of tokens included in the grant\n', '     * @param _timeToCliff Seconds until the vesting cliff\n', '     * @param _vestingDuration Seconds starting from the vesting cliff until the end of the vesting schedule\n', '     */\n', '    function addVestingGrant(\n', '        address _receiver,\n', '        uint256 _amount,\n', '        uint256 _timeToCliff,\n', '        uint256 _vestingDuration\n', '    )\n', '        internal\n', '    {\n', '        // Receiver must not have already received a grant with a vesting schedule\n', '        require(vestingHolders[_receiver] == address(0));\n', '\n', '        // Create a vesting holder contract to act as the holder of the grant&#39;s tokens\n', '        // Note: the vesting grant is revokable\n', '        TokenVesting holder = new TokenVesting(_receiver, grantsStartTimestamp, _timeToCliff, _vestingDuration, true);\n', '        vestingHolders[_receiver] = holder;\n', '\n', '        // Transfer ownership of the vesting holder to the bank multisig\n', '        // giving the bank multisig the ability to revoke the grant\n', '        holder.transferOwnership(bankMultisig);\n', '\n', '        token.transfer(holder, _amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Add a community grant for tokens that are locked until a predetermined time in the future\n', '     * @param _receiver Grant receiver address\n', '     * @param _amount Amount of tokens included in the grant\n', '     */\n', '    function addCommunityGrant(\n', '        address _receiver,\n', '        uint256 _amount\n', '    )\n', '        external\n', '        onlyOwner\n', '        atStage(Stages.GenesisStart)\n', '    {\n', '        uint256 updatedGrantsAmount = communityGrantsAmount.add(_amount);\n', '        // Amount of tokens included in investor grants cannot exceed the community supply during genesis\n', '        require(updatedGrantsAmount <= communitySupply);\n', '\n', '        communityGrantsAmount = updatedGrantsAmount;\n', '\n', '        // Receiver must not have already received a grant with timelocked tokens\n', '        require(timeLockedHolders[_receiver] == address(0));\n', '\n', '        // Create a timelocked holder contract to act as the holder of the grant&#39;s tokens\n', '        TokenTimelock holder = new TokenTimelock(token, _receiver, grantsStartTimestamp);\n', '        timeLockedHolders[_receiver] = holder;\n', '\n', '        token.transfer(holder, _amount);\n', '    }\n', '\n', '    /**\n', '     * @dev End genesis\n', '     */\n', '    function end() external onlyOwner atStage(Stages.GenesisStart) {\n', '        // Transfer the crowd supply to the token distribution contract\n', '        token.transfer(tokenDistribution, crowdSupply);\n', '        // Transfer company supply to the bank multisig\n', '        token.transfer(bankMultisig, companySupply);\n', '        // Transfer ownership of the LivepeerToken contract to the protocol Minter\n', '        token.transferOwnership(minter);\n', '\n', '        stage = Stages.GenesisEnd;\n', '    }\n', '}']
['pragma solidity 0.4.18;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '        assert(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '        assert(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        assert(token.approve(spender, value));\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title TokenTimelock\n', ' * @dev TokenTimelock is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract TokenTimelock {\n', '    using SafeERC20 for ERC20Basic;\n', '\n', '    // ERC20 basic token contract being held\n', '    ERC20Basic public token;\n', '\n', '    // beneficiary of tokens after they are released\n', '    address public beneficiary;\n', '\n', '    // timestamp when token release is enabled\n', '    uint256 public releaseTime;\n', '\n', '    function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {\n', '        require(_releaseTime > now);\n', '        token = _token;\n', '        beneficiary = _beneficiary;\n', '        releaseTime = _releaseTime;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers tokens held by timelock to beneficiary.\n', '     */\n', '    function release() public {\n', '        require(now >= releaseTime);\n', '\n', '        uint256 amount = token.balanceOf(this);\n', '        require(amount > 0);\n', '\n', '        token.safeTransfer(beneficiary, amount);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the\n', ' * owner.\n', ' */\n', 'contract TokenVesting is Ownable {\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  event Released(uint256 amount);\n', '  event Revoked();\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public beneficiary;\n', '\n', '  uint256 public cliff;\n', '  uint256 public start;\n', '  uint256 public duration;\n', '\n', '  bool public revocable;\n', '\n', '  mapping (address => uint256) public released;\n', '  mapping (address => bool) public revoked;\n', '\n', '  /**\n', '   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all\n', '   * of the balance will have vested.\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _revocable whether the vesting is revocable or not\n', '   */\n', '  function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {\n', '    require(_beneficiary != address(0));\n', '    require(_cliff <= _duration);\n', '\n', '    beneficiary = _beneficiary;\n', '    revocable = _revocable;\n', '    duration = _duration;\n', '    cliff = _start.add(_cliff);\n', '    start = _start;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function release(ERC20Basic token) public {\n', '    uint256 unreleased = releasableAmount(token);\n', '\n', '    require(unreleased > 0);\n', '\n', '    released[token] = released[token].add(unreleased);\n', '\n', '    token.safeTransfer(beneficiary, unreleased);\n', '\n', '    Released(unreleased);\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the owner to revoke the vesting. Tokens already vested\n', '   * remain in the contract, the rest are returned to the owner.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function revoke(ERC20Basic token) public onlyOwner {\n', '    require(revocable);\n', '    require(!revoked[token]);\n', '\n', '    uint256 balance = token.balanceOf(this);\n', '\n', '    uint256 unreleased = releasableAmount(token);\n', '    uint256 refund = balance.sub(unreleased);\n', '\n', '    revoked[token] = true;\n', '\n', '    token.safeTransfer(owner, refund);\n', '\n', '    Revoked();\n', '  }\n', '\n', '  /**\n', "   * @dev Calculates the amount that has already vested but hasn't been released yet.\n", '   * @param token ERC20 token which is being vested\n', '   */\n', '  function releasableAmount(ERC20Basic token) public view returns (uint256) {\n', '    return vestedAmount(token).sub(released[token]);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function vestedAmount(ERC20Basic token) public view returns (uint256) {\n', '    uint256 currentBalance = token.balanceOf(this);\n', '    uint256 totalBalance = currentBalance.add(released[token]);\n', '\n', '    if (now < cliff) {\n', '      return 0;\n', '    } else if (now >= start.add(duration) || revoked[token]) {\n', '      return totalBalance;\n', '    } else {\n', '      return totalBalance.mul(now.sub(start)).div(duration);\n', '    }\n', '  }\n', '}\n', '\n', 'contract ILivepeerToken is ERC20, Ownable {\n', '    function mint(address _to, uint256 _amount) public returns (bool);\n', '    function burn(uint256 _amount) public;\n', '}\n', '\n', 'contract GenesisManager is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // LivepeerToken contract\n', '    ILivepeerToken public token;\n', '\n', '    // Address of the token distribution contract\n', '    address public tokenDistribution;\n', '    // Address of the Livepeer bank multisig\n', '    address public bankMultisig;\n', '    // Address of the Minter contract in the Livepeer protocol\n', '    address public minter;\n', '\n', '    // Initial token supply issued\n', '    uint256 public initialSupply;\n', "    // Crowd's portion of the initial token supply\n", '    uint256 public crowdSupply;\n', "    // Company's portion of the initial token supply\n", '    uint256 public companySupply;\n', "    // Team's portion of the initial token supply\n", '    uint256 public teamSupply;\n', "    // Investors' portion of the initial token supply\n", '    uint256 public investorsSupply;\n', "    // Community's portion of the initial token supply\n", '    uint256 public communitySupply;\n', '\n', '    // Token amount in grants for the team\n', '    uint256 public teamGrantsAmount;\n', '    // Token amount in grants for investors\n', '    uint256 public investorsGrantsAmount;\n', '    // Token amount in grants for the community\n', '    uint256 public communityGrantsAmount;\n', '\n', '    // Timestamp at which vesting grants begin their vesting period\n', '    // and timelock grants release locked tokens\n', '    uint256 public grantsStartTimestamp;\n', '\n', "    // Map receiver addresses => contracts holding receivers' vesting tokens\n", '    mapping (address => address) public vestingHolders;\n', "    // Map receiver addresses => contracts holding receivers' time locked tokens\n", '    mapping (address => address) public timeLockedHolders;\n', '\n', '    enum Stages {\n', '        // Stage for setting the allocations of the initial token supply\n', '        GenesisAllocation,\n', '        // Stage for the creating token grants and the token distribution\n', '        GenesisStart,\n', '        // Stage for the end of genesis when ownership of the LivepeerToken contract\n', '        // is transferred to the protocol Minter\n', '        GenesisEnd\n', '    }\n', '\n', '    // Current stage of genesis\n', '    Stages public stage;\n', '\n', '    // Check if genesis is at a particular stage\n', '    modifier atStage(Stages _stage) {\n', '        require(stage == _stage);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev GenesisManager constructor\n', '     * @param _token Address of the Livepeer token contract\n', '     * @param _tokenDistribution Address of the token distribution contract\n', '     * @param _bankMultisig Address of the company bank multisig\n', '     * @param _minter Address of the protocol Minter\n', '     */\n', '    function GenesisManager(\n', '        address _token,\n', '        address _tokenDistribution,\n', '        address _bankMultisig,\n', '        address _minter,\n', '        uint256 _grantsStartTimestamp\n', '    )\n', '        public\n', '    {\n', '        token = ILivepeerToken(_token);\n', '        tokenDistribution = _tokenDistribution;\n', '        bankMultisig = _bankMultisig;\n', '        minter = _minter;\n', '        grantsStartTimestamp = _grantsStartTimestamp;\n', '\n', '        stage = Stages.GenesisAllocation;\n', '    }\n', '\n', '    /**\n', '     * @dev Set allocations for the initial token supply at genesis\n', '     * @param _initialSupply Initial token supply at genesis\n', '     * @param _crowdSupply Tokens allocated for the crowd at genesis\n', '     * @param _companySupply Tokens allocated for the company (for future distribution) at genesis\n', '     * @param _teamSupply Tokens allocated for the team at genesis\n', '     * @param _investorsSupply Tokens allocated for investors at genesis\n', '     * @param _communitySupply Tokens allocated for the community at genesis\n', '     */\n', '    function setAllocations(\n', '        uint256 _initialSupply,\n', '        uint256 _crowdSupply,\n', '        uint256 _companySupply,\n', '        uint256 _teamSupply,\n', '        uint256 _investorsSupply,\n', '        uint256 _communitySupply\n', '    )\n', '        external\n', '        onlyOwner\n', '        atStage(Stages.GenesisAllocation)\n', '    {\n', '        require(_crowdSupply.add(_companySupply).add(_teamSupply).add(_investorsSupply).add(_communitySupply) == _initialSupply);\n', '\n', '        initialSupply = _initialSupply;\n', '        crowdSupply = _crowdSupply;\n', '        companySupply = _companySupply;\n', '        teamSupply = _teamSupply;\n', '        investorsSupply = _investorsSupply;\n', '        communitySupply = _communitySupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Start genesis\n', '     */\n', '    function start() external onlyOwner atStage(Stages.GenesisAllocation) {\n', '        // Mint the initial supply\n', '        token.mint(this, initialSupply);\n', '\n', '        stage = Stages.GenesisStart;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a team grant for tokens with a vesting schedule\n', '     * @param _receiver Grant receiver\n', '     * @param _amount Amount of tokens included in the grant\n', '     * @param _timeToCliff Seconds until the vesting cliff\n', '     * @param _vestingDuration Seconds starting from the vesting cliff until the end of the vesting schedule\n', '     */\n', '    function addTeamGrant(\n', '        address _receiver,\n', '        uint256 _amount,\n', '        uint256 _timeToCliff,\n', '        uint256 _vestingDuration\n', '    )\n', '        external\n', '        onlyOwner\n', '        atStage(Stages.GenesisStart)\n', '    {\n', '        uint256 updatedGrantsAmount = teamGrantsAmount.add(_amount);\n', '        // Amount of tokens included in team grants cannot exceed the team supply during genesis\n', '        require(updatedGrantsAmount <= teamSupply);\n', '\n', '        teamGrantsAmount = updatedGrantsAmount;\n', '\n', '        addVestingGrant(_receiver, _amount, _timeToCliff, _vestingDuration);\n', '    }\n', '\n', '    /**\n', '     * @dev Add an investor grant for tokens with a vesting schedule\n', '     * @param _receiver Grant receiver\n', '     * @param _amount Amount of tokens included in the grant\n', '     * @param _timeToCliff Seconds until the vesting cliff\n', '     * @param _vestingDuration Seconds starting from the vesting cliff until the end of the vesting schedule\n', '     */\n', '    function addInvestorGrant(\n', '        address _receiver,\n', '        uint256 _amount,\n', '        uint256 _timeToCliff,\n', '        uint256 _vestingDuration\n', '    )\n', '        external\n', '        onlyOwner\n', '        atStage(Stages.GenesisStart)\n', '    {\n', '        uint256 updatedGrantsAmount = investorsGrantsAmount.add(_amount);\n', '        // Amount of tokens included in investor grants cannot exceed the investor supply during genesis\n', '        require(updatedGrantsAmount <= investorsSupply);\n', '\n', '        investorsGrantsAmount = updatedGrantsAmount;\n', '\n', '        addVestingGrant(_receiver, _amount, _timeToCliff, _vestingDuration);\n', '    }\n', '\n', '    /**\n', '     * @dev Add a grant for tokens with a vesting schedule. An internal helper function used by addTeamGrant and addInvestorGrant\n', '     * @param _receiver Grant receiver\n', '     * @param _amount Amount of tokens included in the grant\n', '     * @param _timeToCliff Seconds until the vesting cliff\n', '     * @param _vestingDuration Seconds starting from the vesting cliff until the end of the vesting schedule\n', '     */\n', '    function addVestingGrant(\n', '        address _receiver,\n', '        uint256 _amount,\n', '        uint256 _timeToCliff,\n', '        uint256 _vestingDuration\n', '    )\n', '        internal\n', '    {\n', '        // Receiver must not have already received a grant with a vesting schedule\n', '        require(vestingHolders[_receiver] == address(0));\n', '\n', "        // Create a vesting holder contract to act as the holder of the grant's tokens\n", '        // Note: the vesting grant is revokable\n', '        TokenVesting holder = new TokenVesting(_receiver, grantsStartTimestamp, _timeToCliff, _vestingDuration, true);\n', '        vestingHolders[_receiver] = holder;\n', '\n', '        // Transfer ownership of the vesting holder to the bank multisig\n', '        // giving the bank multisig the ability to revoke the grant\n', '        holder.transferOwnership(bankMultisig);\n', '\n', '        token.transfer(holder, _amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Add a community grant for tokens that are locked until a predetermined time in the future\n', '     * @param _receiver Grant receiver address\n', '     * @param _amount Amount of tokens included in the grant\n', '     */\n', '    function addCommunityGrant(\n', '        address _receiver,\n', '        uint256 _amount\n', '    )\n', '        external\n', '        onlyOwner\n', '        atStage(Stages.GenesisStart)\n', '    {\n', '        uint256 updatedGrantsAmount = communityGrantsAmount.add(_amount);\n', '        // Amount of tokens included in investor grants cannot exceed the community supply during genesis\n', '        require(updatedGrantsAmount <= communitySupply);\n', '\n', '        communityGrantsAmount = updatedGrantsAmount;\n', '\n', '        // Receiver must not have already received a grant with timelocked tokens\n', '        require(timeLockedHolders[_receiver] == address(0));\n', '\n', "        // Create a timelocked holder contract to act as the holder of the grant's tokens\n", '        TokenTimelock holder = new TokenTimelock(token, _receiver, grantsStartTimestamp);\n', '        timeLockedHolders[_receiver] = holder;\n', '\n', '        token.transfer(holder, _amount);\n', '    }\n', '\n', '    /**\n', '     * @dev End genesis\n', '     */\n', '    function end() external onlyOwner atStage(Stages.GenesisStart) {\n', '        // Transfer the crowd supply to the token distribution contract\n', '        token.transfer(tokenDistribution, crowdSupply);\n', '        // Transfer company supply to the bank multisig\n', '        token.transfer(bankMultisig, companySupply);\n', '        // Transfer ownership of the LivepeerToken contract to the protocol Minter\n', '        token.transferOwnership(minter);\n', '\n', '        stage = Stages.GenesisEnd;\n', '    }\n', '}']

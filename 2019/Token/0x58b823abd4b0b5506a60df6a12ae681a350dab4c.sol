['pragma solidity ^0.4.24;\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '} \n', '/* import "./oraclizeAPI_0.5.sol"; */\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  // Optional token name\n', '  string  public  name = "zeosX";\n', '  string  public  symbol;\n', '  uint256  public  decimals = 18; // standard token precision. override to customize\n', '    \n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', ' \n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  \n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function multiTransfer(address[] _to,uint[] _value) public returns (bool);\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(burner, _value);\n', '    emit Transfer(burner, address(0), _value);\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', 'contract KYCVerification is Owned{\n', '    \n', '    mapping(address => bool) public kycAddress;\n', '    \n', '    event LogKYCVerification(address _kycAddress,bool _status);\n', '    \n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function updateVerifcationBatch(address[] _kycAddress,bool _status) onlyOwner public returns(bool)\n', '    {\n', '        for(uint tmpIndex = 0; tmpIndex < _kycAddress.length; tmpIndex++)\n', '        {\n', '            kycAddress[_kycAddress[tmpIndex]] = _status;\n', '            emit LogKYCVerification(_kycAddress[tmpIndex],_status);\n', '        }\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function updateVerifcation(address _kycAddress,bool _status) onlyOwner public returns(bool)\n', '    {\n', '        kycAddress[_kycAddress] = _status;\n', '        \n', '        emit LogKYCVerification(_kycAddress,_status);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function isVerified(address _user) view public returns(bool)\n', '    {\n', '        return kycAddress[_user] == true; \n', '    }\n', '}\n', '\n', '\n', 'contract FEXToken is Owned, BurnableToken {\n', '\n', '    string public name = "SUREBANQA UTILITY TOKEN";\n', '    string public symbol = "FEX";\n', '    uint8 public decimals = 5;\n', '    \n', '    uint256 public initialSupply = 450000000 * (10 ** uint256(decimals));\n', '    uint256 public totalSupply = 2100000000 * (10 ** uint256(decimals));\n', '    uint256 public externalAuthorizePurchase = 0;\n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '    mapping(address => uint8) authorizedCaller;\n', '    \n', '    KYCVerification public kycVerification;\n', '    bool public kycEnabled = true;\n', '\n', '    /*  Fund Allocation  */\n', '    uint allocatedEAPFund;\n', '    uint allocatedAirdropAndBountyFund;\n', '    uint allocatedMarketingFund;\n', '    uint allocatedCoreTeamFund;\n', '    uint allocatedTreasuryFund;\n', '    \n', '    uint releasedEAPFund;\n', '    uint releasedAirdropAndBountyFund;\n', '    uint releasedMarketingFund;\n', '    uint releasedCoreTeamFund;\n', '    uint releasedTreasuryFund;\n', '    \n', '    /* EAP Related Factors */\n', '    uint8 EAPMilestoneReleased = 0; /* Total 4 Milestones , one milestone each year */\n', '    uint8 EAPVestingPercent = 25; /* 25% */\n', '    \n', '    \n', '    /* Core Team Related Factors */\n', '    \n', '    uint8 CoreTeamMilestoneReleased = 0; /* Total 4 Milestones , one milestone each quater */\n', '    uint8 CoreTeamVestingPercent = 25; /* 25% */\n', '    \n', '    /* Distribution Address */\n', '    address public EAPFundReceiver = 0xD89c58BedFf2b59fcDDAE3D96aC32D777fa00bF4;\n', '    address public AirdropAndBountyFundReceiver = 0xE4bBCE2795e5C7fF4B7a40b91f7b611526B5613E;\n', '    address public MarketingFundReceiver = 0xbe4c8660ed5709dF4172936743e6868F11686DBe;\n', '    address public CoreTeamFundReceiver = 0x2c1Ab4B9E4dD402120ECe5DF08E35644d2efCd35;\n', '    address public TreasuryFundReceiver = 0xeB81295b4e60e52c60206B0D12C13F82a36Ac9B6;\n', '    \n', '    /* Token Vesting Events*/\n', '    \n', '    event EAPFundReleased(address _receiver,uint _amount,uint _milestone);\n', '    event CoreTeamFundReleased(address _receiver,uint _amount,uint _milestone);\n', '\n', '    bool public initialFundDistributed;\n', '    uint public tokenVestingStartedOn; \n', '\n', '\n', '    modifier onlyAuthCaller(){\n', '        require(authorizedCaller[msg.sender] == 1 || msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier kycVerified(address _guy) {\n', '      if(kycEnabled == true){\n', '          if(kycVerification.isVerified(_guy) == false)\n', '          {\n', '              revert("KYC Not Verified");\n', '          }\n', '      }\n', '      _;\n', '    }\n', '    \n', '    modifier frozenVerified(address _guy) {\n', '        if(frozenAccount[_guy] == true)\n', '        {\n', '            revert("Account is freeze");\n', '        }\n', '        _;\n', '    }\n', '    \n', '    /* KYC related events */    \n', '    event KYCMandateUpdate(bool _kycEnabled);\n', '    event KYCContractAddressUpdate(KYCVerification _kycAddress);\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '    /* Events */\n', '    event AuthorizedCaller(address caller);\n', '    event DeAuthorizedCaller(address caller);\n', '    \n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor () public {\n', '        \n', '        owner = msg.sender;\n', '        balances[0xBcd5B67aaeBb9765beE438e4Ce137B9aE2181898] = totalSupply;\n', '        \n', '        emit Transfer(address(0x0), address(this), totalSupply);\n', '        emit Transfer(address(this), address(0xBcd5B67aaeBb9765beE438e4Ce137B9aE2181898), totalSupply);\n', '\n', '        authorizedCaller[msg.sender] = 1;\n', '        emit AuthorizedCaller(msg.sender);\n', '\n', '        tokenVestingStartedOn = now;\n', '        initialFundDistributed = false;\n', '    }\n', '\n', '    function initFundDistribution() public onlyOwner \n', '    {\n', '        require(initialFundDistributed == false);\n', '        \n', '        /* Reserved for Airdrops/Bounty: 125 Million. */\n', '        \n', '        allocatedAirdropAndBountyFund = 125000000 * (10 ** uint256(decimals));\n', '        _transfer(0xBcd5B67aaeBb9765beE438e4Ce137B9aE2181898,address(AirdropAndBountyFundReceiver),allocatedAirdropAndBountyFund);\n', '        releasedAirdropAndBountyFund = allocatedAirdropAndBountyFund;\n', '        \n', '        /* Reserved for Marketing/Partnerships: 70 Million. */\n', '        \n', '        allocatedMarketingFund = 70000000 * (10 ** uint256(decimals));\n', '        _transfer(0xBcd5B67aaeBb9765beE438e4Ce137B9aE2181898,address(MarketingFundReceiver),allocatedMarketingFund);\n', '        releasedMarketingFund = allocatedMarketingFund;\n', '        \n', '        \n', '        /* Reserved for EAPs/SLIPs : 125 Million released every year at the rate of 25% per yr. */\n', '        \n', '        allocatedEAPFund = 125000000 * (10 ** uint256(decimals));\n', '        \n', '        /* Core Team: 21 Million. Released quarterly at the rate of 25% of 21 Million per quarter.  */\n', '        \n', '        allocatedCoreTeamFund = 21000000 * (10 ** uint256(decimals));\n', '\n', '        /* Treasury: 2.1 Million Time Locked for 24 months */\n', '        \n', '        allocatedTreasuryFund = 2100000 * (10 ** uint256(decimals));\n', '        \n', '        initialFundDistributed = true;\n', '    }\n', '    \n', '    function updateKycContractAddress(KYCVerification _kycAddress) public onlyOwner returns(bool)\n', '    {\n', '      kycVerification = _kycAddress;\n', '      emit KYCContractAddressUpdate(_kycAddress);\n', '      return true;\n', '    }\n', '\n', '    function updateKycMandate(bool _kycEnabled) public onlyAuthCaller returns(bool)\n', '    {\n', '        kycEnabled = _kycEnabled;\n', '        emit KYCMandateUpdate(_kycEnabled);\n', '        return true;\n', '    }\n', '    \n', '    /* authorize caller */\n', '    function authorizeCaller(address _caller) public onlyOwner returns(bool) \n', '    {\n', '        authorizedCaller[_caller] = 1;\n', '        emit AuthorizedCaller(_caller);\n', '        return true;\n', '    }\n', '    \n', '    /* deauthorize caller */\n', '    function deAuthorizeCaller(address _caller) public onlyOwner returns(bool) \n', '    {\n', '        authorizedCaller[_caller] = 0;\n', '        emit DeAuthorizedCaller(_caller);\n', '        return true;\n', '    }\n', '    \n', '    function () public payable {\n', '        revert();\n', '        // buy();\n', '    }\n', '    \n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balances[_from] > _value);                // Check if the sender has enough\n', '        require (balances[_to].add(_value) > balances[_to]); // Check for overflow\n', '        balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender\n', '        balances[_to] = balances[_to].add(_value);                           // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balances[target] = balances[target].add(mintedAmount);\n', '        totalSupply = totalSupply.add(mintedAmount);\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '    \n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    \n', '    function purchaseToken(address _receiver, uint _tokens) onlyAuthCaller public {\n', '        require(_tokens > 0);\n', '        require(initialSupply > _tokens);\n', '        \n', '        initialSupply = initialSupply.sub(_tokens);\n', '        _transfer(owner, _receiver, _tokens);              // makes the transfers\n', '        externalAuthorizePurchase = externalAuthorizePurchase.add(_tokens);\n', '    }\n', '    \n', '    /**\n', '      * @dev transfer token for a specified address\n', '      * @param _to The address to transfer to.\n', '      * @param _value The amount to be transferred.\n', '      */\n', '    function transfer(address _to, uint256 _value) public kycVerified(msg.sender) frozenVerified(msg.sender) returns (bool) {\n', '        _transfer(msg.sender,_to,_value);\n', '        return true;\n', '    }\n', '    \n', '    /*\n', '        Please make sure before calling this function from UI, Sender has sufficient balance for \n', '        All transfers \n', '    */\n', '    function multiTransfer(address[] _to,uint[] _value) public kycVerified(msg.sender) frozenVerified(msg.sender) returns (bool) {\n', '        require(_to.length == _value.length, "Length of Destination should be equal to value");\n', '        for(uint _interator = 0;_interator < _to.length; _interator++ )\n', '        {\n', '            _transfer(msg.sender,_to[_interator],_value[_interator]);\n', '        }\n', '        return true;    \n', '    }\n', '\n', '\n', '    /**\n', '      * @dev Release Treasury Fund Time Locked for 24 months   \n', '      *  Can only be called by authorized caller   \n', '      */\n', '    function releaseTreasuryFund() public onlyAuthCaller returns(bool)\n', '    {\n', '        require(now >= tokenVestingStartedOn.add(730 days));\n', '        require(allocatedTreasuryFund > 0);\n', '        require(releasedTreasuryFund <= 0);\n', '        \n', '        _transfer(address(this),TreasuryFundReceiver,allocatedTreasuryFund);   \n', '        \n', '        /* Complete funds are released */\n', '        releasedTreasuryFund = allocatedTreasuryFund;\n', '        \n', '        return true;\n', '    }\n', '    \n', '\n', '    /**\n', '      * @dev Release EAPs/SLIPs Fund Time Locked releasable every year at the rate of 25% per yr   \n', '      *  Can only be called by authorized caller   \n', '      */\n', '    function releaseEAPFund() public onlyAuthCaller returns(bool)\n', '    {\n', '        /* Only 4 Milestone are to be released */\n', '        require(EAPMilestoneReleased <= 4);\n', '        require(allocatedEAPFund > 0);\n', '        require(releasedEAPFund <= allocatedEAPFund);\n', '        \n', '        uint toBeReleased = 0 ;\n', '        \n', '        if(now <= tokenVestingStartedOn.add(365 days))\n', '        {\n', '            toBeReleased = allocatedEAPFund.mul(EAPVestingPercent).div(100);\n', '            EAPMilestoneReleased = 1;\n', '        }\n', '        else if(now <= tokenVestingStartedOn.add(730 days))\n', '        {\n', '            toBeReleased = allocatedEAPFund.mul(EAPVestingPercent).div(100);\n', '            EAPMilestoneReleased = 2;\n', '        }\n', '        else if(now <= tokenVestingStartedOn.add(1095 days))\n', '        {\n', '            toBeReleased = allocatedEAPFund.mul(EAPVestingPercent).div(100);\n', '            EAPMilestoneReleased = 3;\n', '        }\n', '        else if(now <= tokenVestingStartedOn.add(1460 days))\n', '        {\n', '            toBeReleased = allocatedEAPFund.mul(EAPVestingPercent).div(100);\n', '            EAPMilestoneReleased = 4;\n', '        }\n', '        /* If release request sent beyond 4 years , release remaining amount*/\n', '        else if(now > tokenVestingStartedOn.add(1460 days) && EAPMilestoneReleased != 4)\n', '        {\n', '            toBeReleased = allocatedEAPFund.sub(releasedEAPFund);\n', '            EAPMilestoneReleased = 4;\n', '        }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '        \n', '        if(toBeReleased > 0)\n', '        {\n', '            releasedEAPFund = releasedEAPFund.add(toBeReleased);\n', '            _transfer(address(this),EAPFundReceiver,toBeReleased);\n', '            \n', '            emit EAPFundReleased(EAPFundReceiver,toBeReleased,EAPMilestoneReleased);\n', '            \n', '            return true;\n', '        }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '    }\n', '    \n', '\n', '    /**\n', "      * @dev Release Core Team's Fund Time Locked releasable  quarterly at the rate of 25%    \n", '      *  Can only be called by authorized caller   \n', '      */\n', '    function releaseCoreTeamFund() public onlyAuthCaller returns(bool)\n', '    {\n', '        /* Only 4 Milestone are to be released */\n', '        require(CoreTeamMilestoneReleased <= 4);\n', '        require(allocatedCoreTeamFund > 0);\n', '        require(releasedCoreTeamFund <= allocatedCoreTeamFund);\n', '        \n', '        uint toBeReleased = 0 ;\n', '        \n', '        if(now <= tokenVestingStartedOn.add(90 days))\n', '        {\n', '            toBeReleased = allocatedCoreTeamFund.mul(CoreTeamVestingPercent).div(100);\n', '            CoreTeamMilestoneReleased = 1;\n', '        }\n', '        else if(now <= tokenVestingStartedOn.add(180 days))\n', '        {\n', '            toBeReleased = allocatedCoreTeamFund.mul(CoreTeamVestingPercent).div(100);\n', '            CoreTeamMilestoneReleased = 2;\n', '        }\n', '        else if(now <= tokenVestingStartedOn.add(270 days))\n', '        {\n', '            toBeReleased = allocatedCoreTeamFund.mul(CoreTeamVestingPercent).div(100);\n', '            CoreTeamMilestoneReleased = 3;\n', '        }\n', '        else if(now <= tokenVestingStartedOn.add(360 days))\n', '        {\n', '            toBeReleased = allocatedCoreTeamFund.mul(CoreTeamVestingPercent).div(100);\n', '            CoreTeamMilestoneReleased = 4;\n', '        }\n', '        /* If release request sent beyond 4 years , release remaining amount*/\n', '        else if(now > tokenVestingStartedOn.add(360 days) && CoreTeamMilestoneReleased != 4)\n', '        {\n', '            toBeReleased = allocatedCoreTeamFund.sub(releasedCoreTeamFund);\n', '            CoreTeamMilestoneReleased = 4;\n', '        }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '        \n', '        if(toBeReleased > 0)\n', '        {\n', '            releasedCoreTeamFund = releasedCoreTeamFund.add(toBeReleased);\n', '            _transfer(address(this),CoreTeamFundReceiver,toBeReleased);\n', '            \n', '            emit CoreTeamFundReleased(CoreTeamFundReceiver,toBeReleased,CoreTeamMilestoneReleased);\n', '            \n', '            return true;\n', '        }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '        \n', '    }\n', '}']
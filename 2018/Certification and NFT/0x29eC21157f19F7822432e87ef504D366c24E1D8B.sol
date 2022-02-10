['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title MultiOwnable\n', ' * @dev The MultiOwnable contract has owners addresses and provides basic authorization control\n', ' * functions, this simplifies the implementation of "users permissions".\n', ' */\n', 'contract MultiOwnable {\n', '    address public manager; // address used to set owners\n', '    address[] public owners;\n', '    mapping(address => bool) public ownerByAddress;\n', '\n', '    event AddOwner(address owner);\n', '    event RemoveOwner(address owner);\n', '\n', '    modifier onlyOwner() {\n', '        require(ownerByAddress[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev MultiOwnable constructor sets the manager\n', '     */\n', '    function MultiOwnable() public {\n', '        manager = msg.sender;\n', '        _addOwner(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Function to add owner address\n', '     */\n', '    function addOwner(address _owner) public {\n', '        require(msg.sender == manager);\n', '        _addOwner(_owner);\n', '\n', '    }\n', '\n', '    /**\n', '     * @dev Function to remove owner address\n', '     */\n', '    function removeOwner(address _owner) public {\n', '        require(msg.sender == manager);\n', '        _removeOwner(_owner);\n', '\n', '    }\n', '\n', '    function _addOwner(address _owner) internal {\n', '        ownerByAddress[_owner] = true;\n', '        \n', '        owners.push(_owner);\n', '        AddOwner(_owner);\n', '    }\n', '\n', '    function _removeOwner(address _owner) internal {\n', '\n', '        if (owners.length == 0)\n', '            return;\n', '\n', '        ownerByAddress[_owner] = false;\n', '        \n', '        uint id = indexOf(_owner);\n', '        remove(id);\n', '        RemoveOwner(_owner);\n', '    }\n', '\n', '    function getOwners() public constant returns (address[]) {\n', '        return owners;\n', '    }\n', '\n', '    function indexOf(address value) internal returns(uint) {\n', '        uint i = 0;\n', '        while (i < owners.length) {\n', '            if (owners[i] == value) {\n', '                break;\n', '            }\n', '            i++;\n', '        }\n', '    return i;\n', '  }\n', '\n', '  function remove(uint index) internal {\n', '        if (index >= owners.length) return;\n', '\n', '        for (uint i = index; i<owners.length-1; i++){\n', '            owners[i] = owners[i+1];\n', '        }\n', '        delete owners[owners.length-1];\n', '        owners.length--;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title IERC20Token - ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract IERC20Token {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value)  public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);\n', '    function approve(address _spender, uint256 _value)  public returns (bool success);\n', '    function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract PricingStrategy {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public constant FIRST_ROUND = 1523664001; //2018.04.14 00:00:01 GMT\n', '    uint256 public constant FIRST_ROUND_RATE = 20; // FIRST ROUND BONUS RATE 20%\n', '\n', '    uint256 public constant SECOND_ROUND = 1524268801; //2018.04.21 00:00:01 GMT\n', '    uint256 public constant SECOND_ROUND_RATE = 10; // SECOND ROUND BONUS RATE 10%\n', '\n', '    uint256 public constant FINAL_ROUND_RATE = 0; //FINAL ROUND BONUS RATE 0%\n', '\n', '\n', '    function PricingStrategy() public {\n', '        \n', '    }\n', '\n', '    function getRate() public constant returns(uint256 rate) {\n', '        if (now<FIRST_ROUND) {\n', '            return (FIRST_ROUND_RATE);\n', '        } else if (now<SECOND_ROUND) {\n', '            return (SECOND_ROUND_RATE);\n', '        } else {\n', '            return (FINAL_ROUND_RATE);\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract CrowdSale is MultiOwnable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    enum ICOState {\n', '        NotStarted,\n', '        Started,\n', '        Stopped,\n', '        Finished\n', '    } // ICO SALE STATES\n', '\n', '    struct Stats { \n', '        uint256 TotalContrAmount;\n', '        ICOState State;\n', '        uint256 TotalContrCount;\n', '    }\n', '\n', '    event Contribution(address contraddress, uint256 ethamount, uint256 tokenamount);\n', '    event PresaleTransferred(address contraddress, uint256 tokenamount);\n', '    event TokenOPSPlatformTransferred(address contraddress, uint256 tokenamount);\n', '    event OVISBookedTokensTransferred(address contraddress, uint256 tokenamount);\n', '    event OVISSaleBooked(uint256 jointToken);\n', '    event OVISReservedTokenChanged(uint256 jointToken);\n', '    event RewardPoolTransferred(address rewardpooladdress, uint256 tokenamount);\n', '    event OPSPoolTransferred(address OPSpooladdress, uint256 tokenamount);\n', '    event SaleStarted();\n', '    event SaleStopped();\n', '    event SaleContinued();\n', '    event SoldOutandSaleStopped();\n', '    event SaleFinished();\n', '    event TokenAddressChanged(address jointaddress, address OPSAddress);\n', '    event StrategyAddressChanged(address strategyaddress);   \n', '    event Funded(address fundaddress, uint256 amount);\n', '\n', '    uint256 public constant MIN_ETHER_CONTR = 0.1 ether; // MINIMUM ETHER CONTRIBUTION \n', '    uint256 public constant MAX_ETHER_CONTR = 100 ether; // MAXIMUM ETHER CONTRIBUTION\n', '\n', '    uint256 public constant DECIMALCOUNT = 10**18;\n', '    uint256 public constant JOINT_PER_ETH = 8000; // 1 ETH = 8000 JOINT\n', '\n', '    uint256 public constant PRESALE_JOINTTOKENS = 5000000; // PRESALE 500 ETH * 10000 JOINT AMOUNT\n', '    uint256 public constant TOKENOPSPLATFORM_JOINTTOKENS = 25000000; // TOKENOPS PLAFTORM RESERVED AMOUNT\n', '    uint256 public constant MAX_AVAILABLE_JOINTTOKENS = 100000000; // PRESALE JOINT TOKEN SALE AMOUNT\n', '    uint256 public AVAILABLE_JOINTTOKENS = uint256(100000000).mul(DECIMALCOUNT);\n', '     \n', '    uint256 public OVISRESERVED_TOKENS = 25000000; // RESERVED TOKEN AMOUNT FOR OVIS PARTNER SALE\n', '    uint256 public OVISBOOKED_TOKENS = 0;\n', '    uint256 public OVISBOOKED_BONUSTOKENS = 0;\n', '\n', '    uint256 public constant SALE_START_TIME = 1523059201; //UTC 2018-04-07 00:00:01\n', '\n', '    \n', '    uint256 public ICOSALE_JOINTTOKENS = 0; // ICO CONTRACT TOTAL JOINT SALE AMOUNT\n', '    uint256 public ICOSALE_BONUSJOINTTOKENS = 0; // ICO CONTRACT TOTAL JOINT BONUS AMOUNT\n', '    uint256 public TOTAL_CONTRIBUTOR_COUNT = 0; // ICO SALE TOTAL CONTRIBUTOR COUNT\n', '\n', '    ICOState public CurrentState; // ICO SALE STATE\n', '\n', '    IERC20Token public JointToken;\n', '    IERC20Token public OPSToken;\n', '    PricingStrategy public PriceStrategy;\n', '\n', '    address public FundAddress = 0x25Bc52CBFeB86f6f12EaddF77560b02c4617DC21;\n', '    address public RewardPoolAddress = 0xEb1FAef9068b6B8f46b50245eE877dA5b03D98C9;\n', '    address public OvisAddress = 0x096A5166F75B5B923234841F69374de2F47F9478;\n', '    address public PresaleAddress = 0x3e5EF0eC822B519eb0a41f94b34e90D16ce967E8;\n', '    address public TokenOPSSaleAddress = 0x8686e49E07Bde4F389B0a5728fCe8713DB83602b;\n', '    address public StrategyAddress = 0xe2355faB9239d5ddaA071BDE726ceb2Db876B8E2;\n', '    address public OPSPoolAddress = 0xEA5C0F39e5E3c742fF6e387394e0337e7366a121;\n', '\n', '    modifier checkCap() {\n', '        require(msg.value>=MIN_ETHER_CONTR);\n', '        require(msg.value<=MAX_ETHER_CONTR);\n', '        _;\n', '    }\n', '\n', '    modifier checkBalance() {\n', '        require(JointToken.balanceOf(address(this))>0);\n', '        require(OPSToken.balanceOf(address(this))>0);\n', '        _;       \n', '    }\n', '\n', '    modifier checkTime() {\n', '        require(now>=SALE_START_TIME);\n', '        _;\n', '    }\n', '\n', '    modifier checkState() {\n', '        require(CurrentState == ICOState.Started);\n', '        _;\n', '    }\n', '\n', '    function CrowdSale() {\n', '        PriceStrategy = PricingStrategy(StrategyAddress);\n', '\n', '        CurrentState = ICOState.NotStarted;\n', '        uint256 _soldtokens = PRESALE_JOINTTOKENS.add(TOKENOPSPLATFORM_JOINTTOKENS).add(OVISRESERVED_TOKENS);\n', '        _soldtokens = _soldtokens.mul(DECIMALCOUNT);\n', '        AVAILABLE_JOINTTOKENS = AVAILABLE_JOINTTOKENS.sub(_soldtokens);\n', '    }\n', '\n', '    function() payable public checkState checkTime checkBalance checkCap {\n', '        contribute();\n', '    }\n', '\n', '    /**\n', '     * @dev calculates token amounts and sends to contributor\n', '     */\n', '    function contribute() private {\n', '        uint256 _jointAmount = 0;\n', '        uint256 _jointBonusAmount = 0;\n', '        uint256 _jointTransferAmount = 0;\n', '        uint256 _bonusRate = 0;\n', '        uint256 _ethAmount = msg.value;\n', '\n', '        if (msg.value.mul(JOINT_PER_ETH)>AVAILABLE_JOINTTOKENS) {\n', '            _ethAmount = AVAILABLE_JOINTTOKENS.div(JOINT_PER_ETH);\n', '        } else {\n', '            _ethAmount = msg.value;\n', '        }       \n', '\n', '        _bonusRate = PriceStrategy.getRate();\n', '        _jointAmount = (_ethAmount.mul(JOINT_PER_ETH));\n', '        _jointBonusAmount = _ethAmount.mul(JOINT_PER_ETH).mul(_bonusRate).div(100);  \n', '        _jointTransferAmount = _jointAmount.add(_jointBonusAmount);\n', '        \n', '        require(_jointAmount<=AVAILABLE_JOINTTOKENS);\n', '\n', '        require(JointToken.transfer(msg.sender, _jointTransferAmount));\n', '        require(OPSToken.transfer(msg.sender, _jointTransferAmount));     \n', '\n', '        if (msg.value>_ethAmount) {\n', '            msg.sender.transfer(msg.value.sub(_ethAmount));\n', '            CurrentState = ICOState.Stopped;\n', '            SoldOutandSaleStopped();\n', '        }\n', '\n', '        AVAILABLE_JOINTTOKENS = AVAILABLE_JOINTTOKENS.sub(_jointAmount);\n', '        ICOSALE_JOINTTOKENS = ICOSALE_JOINTTOKENS.add(_jointAmount);\n', '        ICOSALE_BONUSJOINTTOKENS = ICOSALE_BONUSJOINTTOKENS.add(_jointBonusAmount);         \n', '        TOTAL_CONTRIBUTOR_COUNT = TOTAL_CONTRIBUTOR_COUNT.add(1);\n', '\n', '        Contribution(msg.sender, _ethAmount, _jointTransferAmount);\n', '    }\n', '\n', '     /**\n', '     * @dev book OVIS partner sale tokens\n', '     */\n', '    function bookOVISSale(uint256 _rate, uint256 _jointToken) onlyOwner public {              \n', '        OVISBOOKED_TOKENS = OVISBOOKED_TOKENS.add(_jointToken);\n', '        require(OVISBOOKED_TOKENS<=OVISRESERVED_TOKENS.mul(DECIMALCOUNT));\n', '        uint256 _bonus = _jointToken.mul(_rate).div(100);\n', '        OVISBOOKED_BONUSTOKENS = OVISBOOKED_BONUSTOKENS.add(_bonus);\n', '        OVISSaleBooked(_jointToken);\n', '    }\n', '\n', '     /**\n', '     * @dev changes OVIS partner sale reserved tokens\n', '     */\n', '    function changeOVISReservedToken(uint256 _jointToken) onlyOwner public {\n', '        if (_jointToken > OVISRESERVED_TOKENS) {\n', '            AVAILABLE_JOINTTOKENS = AVAILABLE_JOINTTOKENS.sub((_jointToken.sub(OVISRESERVED_TOKENS)).mul(DECIMALCOUNT));\n', '            OVISRESERVED_TOKENS = _jointToken;\n', '        } else if (_jointToken < OVISRESERVED_TOKENS) {\n', '            AVAILABLE_JOINTTOKENS = AVAILABLE_JOINTTOKENS.add((OVISRESERVED_TOKENS.sub(_jointToken)).mul(DECIMALCOUNT));\n', '            OVISRESERVED_TOKENS = _jointToken;\n', '        }\n', '        \n', '        OVISReservedTokenChanged(_jointToken);\n', '    }\n', '\n', '      /**\n', '     * @dev changes Joint Token and OPS Token contract address\n', '     */\n', '    function changeTokenAddress(address _jointAddress, address _OPSAddress) onlyOwner public {\n', '        JointToken = IERC20Token(_jointAddress);\n', '        OPSToken = IERC20Token(_OPSAddress);\n', '        TokenAddressChanged(_jointAddress, _OPSAddress);\n', '    }\n', '\n', '    /**\n', '     * @dev changes Pricing Strategy contract address, which calculates token amounts to give\n', '     */\n', '    function changeStrategyAddress(address _strategyAddress) onlyOwner public {\n', '        PriceStrategy = PricingStrategy(_strategyAddress);\n', '        StrategyAddressChanged(_strategyAddress);\n', '    }\n', '\n', '    /**\n', '     * @dev transfers presale token amounts to contributors\n', '     */\n', '    function transferPresaleTokens() private {\n', '        require(JointToken.transfer(PresaleAddress, PRESALE_JOINTTOKENS.mul(DECIMALCOUNT)));\n', '        PresaleTransferred(PresaleAddress, PRESALE_JOINTTOKENS.mul(DECIMALCOUNT));\n', '    }\n', '\n', '    /**\n', '     * @dev transfers presale token amounts to contributors\n', '     */\n', '    function transferTokenOPSPlatformTokens() private {\n', '        require(JointToken.transfer(TokenOPSSaleAddress, TOKENOPSPLATFORM_JOINTTOKENS.mul(DECIMALCOUNT)));\n', '        TokenOPSPlatformTransferred(TokenOPSSaleAddress, TOKENOPSPLATFORM_JOINTTOKENS.mul(DECIMALCOUNT));\n', '    }\n', '\n', '    /**\n', '     * @dev transfers token amounts to other ICO platforms\n', '     */\n', '    function transferOVISBookedTokens() private {\n', '        uint256 _totalTokens = OVISBOOKED_TOKENS.add(OVISBOOKED_BONUSTOKENS);\n', '        if(_totalTokens>0) {       \n', '            require(JointToken.transfer(OvisAddress, _totalTokens));\n', '            require(OPSToken.transfer(OvisAddress, _totalTokens));\n', '        }\n', '        OVISBookedTokensTransferred(OvisAddress, _totalTokens);\n', '    }\n', '\n', '    /**\n', '     * @dev transfers remaining unsold token amount to reward pool\n', '     */\n', '    function transferRewardPool() private {\n', '        uint256 balance = JointToken.balanceOf(address(this));\n', '        if(balance>0) {\n', '            require(JointToken.transfer(RewardPoolAddress, balance));\n', '        }\n', '        RewardPoolTransferred(RewardPoolAddress, balance);\n', '    }\n', '\n', '    /**\n', '     * @dev transfers remaining OPS token amount to pool\n', '     */\n', '    function transferOPSPool() private {\n', '        uint256 balance = OPSToken.balanceOf(address(this));\n', '        if(balance>0) {\n', '        require(OPSToken.transfer(OPSPoolAddress, balance));\n', '        }\n', '        OPSPoolTransferred(OPSPoolAddress, balance);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev start function to start crowdsale for contribution\n', '     */\n', '    function startSale() onlyOwner public {\n', '        require(CurrentState == ICOState.NotStarted);\n', '        require(JointToken.balanceOf(address(this))>0);\n', '        require(OPSToken.balanceOf(address(this))>0);       \n', '        CurrentState = ICOState.Started;\n', '        transferPresaleTokens();\n', '        transferTokenOPSPlatformTokens();\n', '        SaleStarted();\n', '    }\n', '\n', '    /**\n', '     * @dev stop function to stop crowdsale for contribution\n', '     */\n', '    function stopSale() onlyOwner public {\n', '        require(CurrentState == ICOState.Started);\n', '        CurrentState = ICOState.Stopped;\n', '        SaleStopped();\n', '    }\n', '\n', '    /**\n', '     * @dev continue function to continue crowdsale for contribution\n', '     */\n', '    function continueSale() onlyOwner public {\n', '        require(CurrentState == ICOState.Stopped);\n', '        CurrentState = ICOState.Started;\n', '        SaleContinued();\n', '    }\n', '\n', '    /**\n', '     * @dev finish function to finish crowdsale for contribution\n', '     */\n', '    function finishSale() onlyOwner public {\n', '        if (this.balance>0) {\n', '            FundAddress.transfer(this.balance);\n', '        }\n', '        transferOVISBookedTokens();\n', '        transferRewardPool();    \n', '        transferOPSPool();  \n', '        CurrentState = ICOState.Finished; \n', '        SaleFinished();\n', '    }\n', '\n', '    /**\n', "     * @dev funds contract's balance to fund address\n", '     */\n', '    function getFund(uint256 _amount) onlyOwner public {\n', '        require(_amount<=this.balance);\n', '        FundAddress.transfer(_amount);\n', '        Funded(FundAddress, _amount);\n', '    }\n', '\n', '    function getStats() public constant returns(uint256 TotalContrAmount, ICOState State, uint256 TotalContrCount) {\n', '        uint256 totaltoken = 0;\n', '        totaltoken = ICOSALE_JOINTTOKENS.add(PRESALE_JOINTTOKENS.mul(DECIMALCOUNT));\n', '        totaltoken = totaltoken.add(TOKENOPSPLATFORM_JOINTTOKENS.mul(DECIMALCOUNT));\n', '        totaltoken = totaltoken.add(OVISBOOKED_TOKENS);\n', '        return (totaltoken, CurrentState, TOTAL_CONTRIBUTOR_COUNT);\n', '    }\n', '\n', '    function destruct() onlyOwner public {\n', '        require(CurrentState == ICOState.Finished);\n', '        selfdestruct(FundAddress);\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '/**\n', '* @title ICO CONTRACT\n', '* @dev ERC-20 Token Standard Compliant\n', '*/\n', '\n', '/**\n', ' * @title SafeMath by OpenZepelin\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract token {\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    }\n', '\n', '/**\n', ' * @title admined\n', ' * @notice This contract is administered\n', ' */\n', 'contract admined {\n', '    address public admin; //Admin address is public\n', '\n', '    /**\n', '    * @dev This contructor takes the msg.sender as the first administer\n', '    */\n', '    constructor() internal {\n', '        admin = 0x6585b849371A40005F9dCda57668C832a5be1777; //Set initial admin to contract creator\n', '        emit Admined(admin);\n', '    }\n', '\n', '    /**\n', '    * @dev This modifier limits function execution to the admin\n', '    */\n', '    modifier onlyAdmin() { //A modifier to define admin-only functions\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @notice This function transfer the adminship of the contract to _newAdmin\n', '    * @param _newAdmin The new admin of the contract\n', '    */\n', '    function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered\n', '        admin = _newAdmin;\n', '        emit TransferAdminship(admin);\n', '    }\n', '\n', '    /**\n', '    * @dev Log Events\n', '    */\n', '    event TransferAdminship(address newAdminister);\n', '    event Admined(address administer);\n', '\n', '}\n', '\n', 'contract ICO is admined {\n', '\n', '    using SafeMath for uint256;\n', '    //This ico have these states\n', '    enum State {\n', '        stage1,\n', '        stage2,\n', '        stage3,\n', '        stage4,\n', '        stage5,\n', '        Successful\n', '    }\n', '    //public variables\n', '    State public state = State.stage1; //Set initial stage\n', '    uint256 public startTime = now;\n', '    uint256 public stage1Deadline = startTime.add(20 days);\n', '    uint256 public stage2Deadline = stage1Deadline.add(20 days);\n', '    uint256 public stage3Deadline = stage2Deadline.add(20 days);\n', '    uint256 public stage4Deadline = stage3Deadline.add(20 days);\n', '    uint256 public stage5Deadline = stage4Deadline.add(20 days);\n', '    uint256 public totalRaised; //eth in wei\n', '    uint256 public totalDistributed; //tokens\n', '    uint256 public stageDistributed;\n', '    uint256 public completedAt;\n', '    token public tokenReward;\n', '    address constant public creator = 0x6585b849371A40005F9dCda57668C832a5be1777;\n', '    string public version = &#39;1&#39;;\n', '    uint256[5] rates = [2327,1551,1163,931,775];\n', '\n', '    mapping (address => address) public refLed;\n', '\n', '    //events for log\n', '    event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);\n', '    event LogBeneficiaryPaid(address _beneficiaryAddress);\n', '    event LogFundingSuccessful(uint _totalRaised);\n', '    event LogFunderInitialized(address _creator);\n', '    event LogContributorsPayout(address _addr, uint _amount);\n', '    event LogStageFinish(State _state, uint256 _distributed);\n', '\n', '    modifier notFinished() {\n', '        require(state != State.Successful);\n', '        _;\n', '    }\n', '    /**\n', '    * @notice ICO constructor\n', '    * @param _addressOfTokenUsedAsReward is the token totalDistributed\n', '    */\n', '    constructor (token _addressOfTokenUsedAsReward ) public {\n', '\n', '        tokenReward = _addressOfTokenUsedAsReward;\n', '\n', '        emit LogFunderInitialized(creator);\n', '    }\n', '\n', '    /**\n', '    * @notice contribution handler\n', '    */\n', '    function contribute(address _ref) public notFinished payable {\n', '\n', '        address referral = _ref;\n', '        uint256 referralBase = 0;\n', '        uint256 referralTokens = 0;\n', '        uint256 tokenBought = 0;\n', '\n', '        if(refLed[msg.sender] == 0){ //If no referral set yet\n', '          refLed[msg.sender] = referral; //Set referral to passed one\n', '        } else { //If not, then it was set previously\n', '          referral = refLed[msg.sender]; //A referral must not be changed\n', '        }\n', '\n', '        totalRaised = totalRaised.add(msg.value);\n', '\n', '        //Rate of exchange depends on stage\n', '        if (state == State.stage1){\n', '\n', '            tokenBought = msg.value.mul(rates[0]);\n', '\n', '        } else if (state == State.stage2){\n', '\n', '            tokenBought = msg.value.mul(rates[1]);\n', '\n', '        } else if (state == State.stage3){\n', '\n', '            tokenBought = msg.value.mul(rates[2]);\n', '\n', '        } else if (state == State.stage4){\n', '\n', '            tokenBought = msg.value.mul(rates[3]);\n', '\n', '        } else if (state == State.stage5){\n', '\n', '            tokenBought = msg.value.mul(rates[4]);\n', '\n', '        }\n', '\n', '        //If there is any referral, the base calc will be made with this value\n', '        referralBase = tokenBought;\n', '\n', '        //2% Bonus Calc\n', '        if(msg.value >= 5 ether ){\n', '          tokenBought = tokenBought.mul(102);\n', '          tokenBought = tokenBought.div(100); //1.02 = +2%\n', '        }\n', '\n', '        totalDistributed = totalDistributed.add(tokenBought);\n', '        stageDistributed = stageDistributed.add(tokenBought);\n', '\n', '        tokenReward.transfer(msg.sender, tokenBought);\n', '\n', '        emit LogFundingReceived(msg.sender, msg.value, totalRaised);\n', '        emit LogContributorsPayout(msg.sender, tokenBought);\n', '\n', '\n', '        if (referral != address(0) && referral != msg.sender){\n', '\n', '            referralTokens = referralBase.div(20); // 100% / 20 = 5%\n', '            totalDistributed = totalDistributed.add(referralTokens);\n', '            stageDistributed = stageDistributed.add(referralTokens);\n', '\n', '            tokenReward.transfer(referral, referralTokens);\n', '\n', '            emit LogContributorsPayout(referral, referralTokens);\n', '        }\n', '\n', '        checkIfFundingCompleteOrExpired();\n', '    }\n', '\n', '    /**\n', '    * @notice check status\n', '    */\n', '    function checkIfFundingCompleteOrExpired() public {\n', '\n', '        if(now > stage5Deadline && state!=State.Successful ){ //if we reach ico deadline and its not Successful yet\n', '\n', '            emit LogStageFinish(state,stageDistributed);\n', '\n', '            state = State.Successful; //ico becomes Successful\n', '            completedAt = now; //ICO is complete\n', '\n', '            emit LogFundingSuccessful(totalRaised); //we log the finish\n', '            finished(); //and execute closure\n', '\n', '        } else if(state == State.stage1 && now > stage1Deadline){\n', '\n', '            emit LogStageFinish(state,stageDistributed);\n', '\n', '            state = State.stage2;\n', '            stageDistributed = 0;\n', '\n', '        } else if(state == State.stage2 && now > stage2Deadline){\n', '\n', '            emit LogStageFinish(state,stageDistributed);\n', '\n', '            state = State.stage3;\n', '            stageDistributed = 0;\n', '\n', '        } else if(state == State.stage3 && now > stage3Deadline){\n', '\n', '            emit LogStageFinish(state,stageDistributed);\n', '\n', '            state = State.stage4;\n', '            stageDistributed = 0;\n', '\n', '        } else if(state == State.stage4 && now > stage4Deadline){\n', '\n', '            emit LogStageFinish(state,stageDistributed);\n', '\n', '            state = State.stage5;\n', '            stageDistributed = 0;\n', '\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @notice closure handler\n', '    */\n', '    function finished() public { //When finished eth are transfered to creator\n', '\n', '        require(state == State.Successful);\n', '        uint256 remanent = tokenReward.balanceOf(this);\n', '\n', '        creator.transfer(address(this).balance);\n', '        tokenReward.transfer(creator,remanent);\n', '\n', '        emit LogBeneficiaryPaid(creator);\n', '        emit LogContributorsPayout(creator, remanent);\n', '\n', '    }\n', '\n', '    /**\n', '    * @notice Function to claim any token stuck on contract\n', '    */\n', '    function claimTokens(token _address) onlyAdmin public{\n', '        require(state == State.Successful); //Only when sale finish\n', '\n', '        uint256 remainder = _address.balanceOf(this); //Check remainder tokens\n', '        _address.transfer(admin,remainder); //Transfer tokens to admin\n', '\n', '    }\n', '\n', '    /*\n', '    * @dev direct payments doesn&#39;t handle referral system\n', '    * so it call contribute with referral 0x0000000000000000000000000000000000000000\n', '    */\n', '\n', '    function () public payable {\n', '\n', '        contribute(address(0));\n', '\n', '    }\n', '}']
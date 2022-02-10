['pragma solidity 0.4.24;\n', '/**\n', '* @title IADOWR Special Event Contract\n', '* @dev ERC-20 Token Standard Compliant Contract\n', '*/\n', '\n', '/**\n', ' * @title SafeMath by OpenZeppelin\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * Token contract interface for external use\n', ' */\n', 'contract token {\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public;\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title admined\n', ' * @notice This contract have some admin-only functions\n', ' */\n', 'contract admined {\n', '    mapping (address => uint8) public admin; //Admin address is public\n', '\n', '    /**\n', '    * @dev This contructor takes the msg.sender as the first administer\n', '    */\n', '    constructor() internal {\n', '        admin[msg.sender] = 2; //Set initial master admin to contract creator\n', '        emit AssignAdminship(msg.sender, 2);\n', '    }\n', '\n', '    /**\n', '    * @dev This modifier limits function execution to the admin\n', '    */\n', '    modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions\n', '        require(admin[msg.sender] >= _level);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @notice This function transfer the adminship of the contract to _newAdmin\n', '    * @param _newAdmin User address\n', '    * @param _level User new level\n', '    */\n', '    function assingAdminship(address _newAdmin, uint8 _level) onlyAdmin(2) public { //Admin can be transfered\n', '        admin[_newAdmin] = _level;\n', '        emit AssignAdminship(_newAdmin , _level);\n', '    }\n', '\n', '    /**\n', '    * @dev Log Events\n', '    */\n', '    event AssignAdminship(address newAdminister, uint8 level);\n', '\n', '}\n', '\n', 'contract IADSpecialEvent is admined {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    //This ico contract have 2 states\n', '    enum State {\n', '        Ongoing,\n', '        Successful\n', '    }\n', '    //public variables\n', '    token public constant tokenReward = token(0xC1E2097d788d33701BA3Cc2773BF67155ec93FC4);\n', '    State public state = State.Ongoing; //Set initial stage\n', '    uint256 public totalRaised; //eth in wei funded\n', '    uint256 public totalDistributed; //tokens distributed\n', '    uint256 public completedAt;\n', '    address public creator;\n', '    mapping (address => bool) whiteList;\n', '    uint256 public rate = 6250;//Base rate is 5000 IAD/ETH - It&#39;s a 25% bonus\n', '    string public version = &#39;1&#39;;\n', '\n', '    //events for log\n', '    event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);\n', '    event LogBeneficiaryPaid(address _beneficiaryAddress);\n', '    event LogFundingSuccessful(uint _totalRaised);\n', '    event LogFunderInitialized(address _creator);\n', '    event LogContributorsPayout(address _addr, uint _amount);\n', '\n', '    modifier notFinished() {\n', '        require(state != State.Successful);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @notice ICO constructor\n', '    */\n', '    constructor () public {\n', '\n', '        creator = msg.sender;\n', '\n', '        emit LogFunderInitialized(creator);\n', '    }\n', '\n', '    /**\n', '    * @notice whiteList handler\n', '    */\n', '    function whitelistAddress(address _user, bool _flag) onlyAdmin(1) public {\n', '        whiteList[_user] = _flag;\n', '    }\n', '\n', '    function checkWhitelist(address _user) onlyAdmin(1) public view returns (bool flag) {\n', '        return whiteList[_user];\n', '    }\n', '\n', '    /**\n', '    * @notice contribution handler\n', '    */\n', '    function contribute() public notFinished payable {\n', '        //must be whitlisted\n', '        require(whiteList[msg.sender] == true);\n', '        //lets get the total purchase\n', '        uint256 tokenBought = msg.value.mul(rate);\n', '        //Minimum 150K tokenss\n', '        require(tokenBought >= 150000 * (10 ** 18));\n', '        //Keep track of total wei raised\n', '        totalRaised = totalRaised.add(msg.value);\n', '        //Keep track of total tokens distributed\n', '        totalDistributed = totalDistributed.add(tokenBought);\n', '        //Transfer the tokens\n', '        tokenReward.transfer(msg.sender, tokenBought);\n', '        //Logs\n', '        emit LogFundingReceived(msg.sender, msg.value, totalRaised);\n', '        emit LogContributorsPayout(msg.sender, tokenBought);\n', '    }\n', '\n', '    /**\n', '    * @notice closure handler\n', '    */\n', '    function finish() onlyAdmin(2) public { //When finished eth and tremaining tokens are transfered to creator\n', '\n', '        if(state != State.Successful){\n', '          state = State.Successful;\n', '          completedAt = now;\n', '        }\n', '\n', '        uint256 remanent = tokenReward.balanceOf(this);\n', '        require(creator.send(address(this).balance));\n', '        tokenReward.transfer(creator,remanent);\n', '\n', '        emit LogBeneficiaryPaid(creator);\n', '        emit LogContributorsPayout(creator, remanent);\n', '\n', '    }\n', '\n', '    function sendTokensManually(address _to, uint256 _amount) onlyAdmin(2) public {\n', '\n', '        require(whiteList[_to] == true);\n', '        //Keep track of total tokens distributed\n', '        totalDistributed = totalDistributed.add(_amount);\n', '        //Transfer the tokens\n', '        tokenReward.transfer(_to, _amount);\n', '        //Logs\n', '        emit LogContributorsPayout(_to, _amount);\n', '\n', '    }\n', '\n', '    /**\n', '    * @notice Function to claim eth on contract\n', '    */\n', '    function claimETH() onlyAdmin(2) public{\n', '\n', '        require(creator.send(address(this).balance));\n', '\n', '        emit LogBeneficiaryPaid(creator);\n', '\n', '    }\n', '\n', '    /**\n', '    * @notice Function to claim any token stuck on contract at any time\n', '    */\n', '    function claimTokens(token _address) onlyAdmin(2) public{\n', '        require(state == State.Successful); //Only when sale finish\n', '\n', '        uint256 remainder = _address.balanceOf(this); //Check remainder tokens\n', '        _address.transfer(msg.sender,remainder); //Transfer tokens to admin\n', '\n', '    }\n', '\n', '    /*\n', '    * @dev direct payments handler\n', '    */\n', '\n', '    function () public payable {\n', '\n', '        contribute();\n', '\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '/**\n', '* @title IADOWR Special Event Contract\n', '* @dev ERC-20 Token Standard Compliant Contract\n', '*/\n', '\n', '/**\n', ' * @title SafeMath by OpenZeppelin\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * Token contract interface for external use\n', ' */\n', 'contract token {\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public;\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title admined\n', ' * @notice This contract have some admin-only functions\n', ' */\n', 'contract admined {\n', '    mapping (address => uint8) public admin; //Admin address is public\n', '\n', '    /**\n', '    * @dev This contructor takes the msg.sender as the first administer\n', '    */\n', '    constructor() internal {\n', '        admin[msg.sender] = 2; //Set initial master admin to contract creator\n', '        emit AssignAdminship(msg.sender, 2);\n', '    }\n', '\n', '    /**\n', '    * @dev This modifier limits function execution to the admin\n', '    */\n', '    modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions\n', '        require(admin[msg.sender] >= _level);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @notice This function transfer the adminship of the contract to _newAdmin\n', '    * @param _newAdmin User address\n', '    * @param _level User new level\n', '    */\n', '    function assingAdminship(address _newAdmin, uint8 _level) onlyAdmin(2) public { //Admin can be transfered\n', '        admin[_newAdmin] = _level;\n', '        emit AssignAdminship(_newAdmin , _level);\n', '    }\n', '\n', '    /**\n', '    * @dev Log Events\n', '    */\n', '    event AssignAdminship(address newAdminister, uint8 level);\n', '\n', '}\n', '\n', 'contract IADSpecialEvent is admined {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    //This ico contract have 2 states\n', '    enum State {\n', '        Ongoing,\n', '        Successful\n', '    }\n', '    //public variables\n', '    token public constant tokenReward = token(0xC1E2097d788d33701BA3Cc2773BF67155ec93FC4);\n', '    State public state = State.Ongoing; //Set initial stage\n', '    uint256 public totalRaised; //eth in wei funded\n', '    uint256 public totalDistributed; //tokens distributed\n', '    uint256 public completedAt;\n', '    address public creator;\n', '    mapping (address => bool) whiteList;\n', "    uint256 public rate = 6250;//Base rate is 5000 IAD/ETH - It's a 25% bonus\n", "    string public version = '1';\n", '\n', '    //events for log\n', '    event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);\n', '    event LogBeneficiaryPaid(address _beneficiaryAddress);\n', '    event LogFundingSuccessful(uint _totalRaised);\n', '    event LogFunderInitialized(address _creator);\n', '    event LogContributorsPayout(address _addr, uint _amount);\n', '\n', '    modifier notFinished() {\n', '        require(state != State.Successful);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @notice ICO constructor\n', '    */\n', '    constructor () public {\n', '\n', '        creator = msg.sender;\n', '\n', '        emit LogFunderInitialized(creator);\n', '    }\n', '\n', '    /**\n', '    * @notice whiteList handler\n', '    */\n', '    function whitelistAddress(address _user, bool _flag) onlyAdmin(1) public {\n', '        whiteList[_user] = _flag;\n', '    }\n', '\n', '    function checkWhitelist(address _user) onlyAdmin(1) public view returns (bool flag) {\n', '        return whiteList[_user];\n', '    }\n', '\n', '    /**\n', '    * @notice contribution handler\n', '    */\n', '    function contribute() public notFinished payable {\n', '        //must be whitlisted\n', '        require(whiteList[msg.sender] == true);\n', '        //lets get the total purchase\n', '        uint256 tokenBought = msg.value.mul(rate);\n', '        //Minimum 150K tokenss\n', '        require(tokenBought >= 150000 * (10 ** 18));\n', '        //Keep track of total wei raised\n', '        totalRaised = totalRaised.add(msg.value);\n', '        //Keep track of total tokens distributed\n', '        totalDistributed = totalDistributed.add(tokenBought);\n', '        //Transfer the tokens\n', '        tokenReward.transfer(msg.sender, tokenBought);\n', '        //Logs\n', '        emit LogFundingReceived(msg.sender, msg.value, totalRaised);\n', '        emit LogContributorsPayout(msg.sender, tokenBought);\n', '    }\n', '\n', '    /**\n', '    * @notice closure handler\n', '    */\n', '    function finish() onlyAdmin(2) public { //When finished eth and tremaining tokens are transfered to creator\n', '\n', '        if(state != State.Successful){\n', '          state = State.Successful;\n', '          completedAt = now;\n', '        }\n', '\n', '        uint256 remanent = tokenReward.balanceOf(this);\n', '        require(creator.send(address(this).balance));\n', '        tokenReward.transfer(creator,remanent);\n', '\n', '        emit LogBeneficiaryPaid(creator);\n', '        emit LogContributorsPayout(creator, remanent);\n', '\n', '    }\n', '\n', '    function sendTokensManually(address _to, uint256 _amount) onlyAdmin(2) public {\n', '\n', '        require(whiteList[_to] == true);\n', '        //Keep track of total tokens distributed\n', '        totalDistributed = totalDistributed.add(_amount);\n', '        //Transfer the tokens\n', '        tokenReward.transfer(_to, _amount);\n', '        //Logs\n', '        emit LogContributorsPayout(_to, _amount);\n', '\n', '    }\n', '\n', '    /**\n', '    * @notice Function to claim eth on contract\n', '    */\n', '    function claimETH() onlyAdmin(2) public{\n', '\n', '        require(creator.send(address(this).balance));\n', '\n', '        emit LogBeneficiaryPaid(creator);\n', '\n', '    }\n', '\n', '    /**\n', '    * @notice Function to claim any token stuck on contract at any time\n', '    */\n', '    function claimTokens(token _address) onlyAdmin(2) public{\n', '        require(state == State.Successful); //Only when sale finish\n', '\n', '        uint256 remainder = _address.balanceOf(this); //Check remainder tokens\n', '        _address.transfer(msg.sender,remainder); //Transfer tokens to admin\n', '\n', '    }\n', '\n', '    /*\n', '    * @dev direct payments handler\n', '    */\n', '\n', '    function () public payable {\n', '\n', '        contribute();\n', '\n', '    }\n', '}']
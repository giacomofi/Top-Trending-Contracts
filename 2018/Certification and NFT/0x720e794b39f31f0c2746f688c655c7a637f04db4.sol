['pragma solidity 0.4.24;\n', '/**\n', '* @title CNC ICO Contract\n', '* @dev CNC is an ERC-20 Standar Compliant Token\n', '*/\n', '\n', '/**\n', ' * @title SafeMath by OpenZeppelin (partially)\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title admined\n', ' * @notice This contract is administered\n', ' */\n', 'contract admined {\n', '    mapping(address => uint8) level;\n', '    //0 normal user\n', '    //1 basic admin\n', '    //2 master admin\n', '\n', '    /**\n', '    * @dev This contructor takes the msg.sender as the first master admin\n', '    */\n', '    constructor() internal {\n', '        level[msg.sender] = 2; //Set initial admin to contract creator\n', '        emit AdminshipUpdated(msg.sender,2);\n', '    }\n', '\n', '    /**\n', '    * @dev This modifier limits function execution to the admin\n', '    */\n', '    modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions\n', '        require(level[msg.sender] >= _level );\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @notice This function transfer the adminship of the contract to _newAdmin\n', '    * @param _newAdmin The new admin of the contract\n', '    */\n', '    function adminshipLevel(address _newAdmin, uint8 _level) onlyAdmin(2) public { //Admin can be set\n', '        require(_newAdmin != address(0));\n', '        level[_newAdmin] = _level;\n', '        emit AdminshipUpdated(_newAdmin,_level);\n', '    }\n', '\n', '    /**\n', '    * @dev Log Events\n', '    */\n', '    event AdminshipUpdated(address _newAdmin, uint8 _level);\n', '\n', '}\n', '\n', 'contract CNCICO is admined {\n', '\n', '    using SafeMath for uint256;\n', '    //This ico have 4 possible states\n', '    enum State {\n', '        PreSale, //PreSale - best value\n', '        MainSale,\n', '        Failed,\n', '        Successful\n', '    }\n', '    //Public variables\n', '\n', '    //Time-state Related\n', '    State public state = State.PreSale; //Set initial stage\n', '    uint256 public PreSaleStart = now; //Once deployed\n', '    uint256 constant public PreSaleDeadline = 1528502399; //Human time (GMT): Friday, 8 June 2018 23:59:59\n', '    uint256 public MainSaleStart = 1528722000; //Human time (GMT): Monday, 11 June 2018 13:00:00\n', '    uint256 public MainSaleDeadline = 1533081599; //Human time (GMT): Tuesday, 31 July 2018 23:59:59\n', '    uint256 public completedAt; //Set when ico finish\n', '\n', '    //Token-eth related\n', '    uint256 public totalRaised; //eth collected in wei\n', '    uint256 public PreSaleDistributed; //presale tokens distributed\n', '    uint256 public PreSaleLimit = 75000000 * (10 ** 18);\n', '    uint256 public totalDistributed; //Whole sale tokens distributed\n', '    ERC20Basic public tokenReward; //Token contract address\n', '    uint256 public softCap = 50000000 * (10 ** 18); //50M Tokens\n', '    uint256 public hardCap = 600000000 * (10 ** 18); // 600M tokens\n', '    bool public claimed;\n', '    //User balances handlers\n', '    mapping (address => uint256) public ethOnContract; //Balance of sent eth per user\n', '    mapping (address => uint256) public tokensSent; //Tokens sent per user\n', '    mapping (address => uint256) public balance; //Tokens pending to send per user\n', '    //Contract details\n', '    address public creator;\n', '    string public version = &#39;1&#39;;\n', '\n', '    //Tokens per eth rates\n', '    uint256[2] rates = [50000,28572];\n', '\n', '    //events for log\n', '    event LogFundrisingInitialized(address _creator);\n', '    event LogMainSaleDateSet(uint256 _time);\n', '    event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);\n', '    event LogBeneficiaryPaid(address _beneficiaryAddress);\n', '    event LogContributorsPayout(address _addr, uint _amount);\n', '    event LogRefund(address _addr, uint _amount);\n', '    event LogFundingSuccessful(uint _totalRaised);\n', '    event LogFundingFailed(uint _totalRaised);\n', '\n', '    //Modifier to prevent execution if ico has ended\n', '    modifier notFinished() {\n', '        require(state != State.Successful && state != State.Failed);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @notice ICO constructor\n', '    * @param _addressOfTokenUsedAsReward is the token to distribute\n', '    */\n', '    constructor(ERC20Basic _addressOfTokenUsedAsReward ) public {\n', '\n', '        creator = msg.sender; //Creator is set from deployer address\n', '        tokenReward = _addressOfTokenUsedAsReward; //Token address is set during deployment\n', '\n', '        emit LogFundrisingInitialized(creator);\n', '    }\n', '\n', '    /**\n', '    * @notice contribution handler\n', '    */\n', '    function contribute() public notFinished payable {\n', '\n', '        uint256 tokenBought = 0; //tokens bought variable\n', '\n', '        totalRaised = totalRaised.add(msg.value); //ether received updated\n', '        ethOnContract[msg.sender] = ethOnContract[msg.sender].add(msg.value); //ether sent by user updated\n', '\n', '        //Rate of exchange depends on stage\n', '        if (state == State.PreSale){\n', '\n', '            require(now >= PreSaleStart);\n', '\n', '            tokenBought = msg.value.mul(rates[0]);\n', '            PreSaleDistributed = PreSaleDistributed.add(tokenBought); //Tokens sold on presale updated\n', '            require(PreSaleDistributed <= PreSaleLimit);\n', '\n', '        } else if (state == State.MainSale){\n', '\n', '            require(now >= MainSaleStart);\n', '\n', '            tokenBought = msg.value.mul(rates[1]);\n', '\n', '        }\n', '\n', '        totalDistributed = totalDistributed.add(tokenBought); //whole tokens sold updated\n', '        require(totalDistributed <= hardCap);\n', '\n', '        if(totalDistributed >= softCap){\n', '            //if there are any unclaimed tokens\n', '            uint256 tempBalance = balance[msg.sender];\n', '            //clear pending balance\n', '            balance[msg.sender] = 0;\n', '            //If softCap is reached tokens are send immediately\n', '            require(tokenReward.transfer(msg.sender, tokenBought.add(tempBalance)));\n', '            //Tokens sent to user updated\n', '            tokensSent[msg.sender] = tokensSent[msg.sender].add(tokenBought.add(tempBalance));\n', '\n', '            emit LogContributorsPayout(msg.sender, tokenBought.add(tempBalance));\n', '\n', '        } else{\n', '            //If softCap is not reached tokens becomes pending\n', '            balance[msg.sender] = balance[msg.sender].add(tokenBought);\n', '\n', '        }\n', '\n', '        emit LogFundingReceived(msg.sender, msg.value, totalRaised);\n', '\n', '        checkIfFundingCompleteOrExpired();\n', '    }\n', '\n', '    /**\n', '    * @notice check status\n', '    */\n', '    function checkIfFundingCompleteOrExpired() public {\n', '\n', '        //If hardCap is reached ICO ends\n', '        if (totalDistributed == hardCap && state != State.Successful){\n', '\n', '            state = State.Successful; //ICO becomes Successful\n', '            completedAt = now; //ICO is complete\n', '\n', '            emit LogFundingSuccessful(totalRaised); //we log the finish\n', '            successful(); //and execute closure\n', '\n', '        } else if(state == State.PreSale && now > PreSaleDeadline){\n', '\n', '            state = State.MainSale; //Once presale ends the ICO holds\n', '\n', '        } else if(state == State.MainSale && now > MainSaleDeadline){\n', '            //Once main sale deadline is reached, softCap has to be compared\n', '            if(totalDistributed >= softCap){\n', '                //If softCap is reached\n', '                state = State.Successful; //ICO becomes Successful\n', '                completedAt = now; //ICO is finished\n', '\n', '                emit LogFundingSuccessful(totalRaised); //we log the finish\n', '                successful(); //and execute closure\n', '\n', '            } else{\n', '                //If softCap is not reached\n', '                state = State.Failed; //ICO becomes Failed\n', '                completedAt = now; //ICO is finished\n', '\n', '                emit LogFundingFailed(totalRaised); //we log the finish\n', '\n', '            }\n', '\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @notice successful closure handler\n', '    */\n', '    function successful() public {\n', '        //When successful\n', '        require(state == State.Successful);\n', '        //Check if tokens have been already claimed - can only be claimed one time\n', '        if (claimed == false){\n', '            claimed = true; //Creator is claiming remanent tokens to be burned\n', '            address writer = 0xEB53AD38f0C37C0162E3D1D4666e63a55EfFC65f;\n', '            writer.transfer(5 ether);\n', '            //If there is any token left after ico\n', '            uint256 remanent = hardCap.sub(totalDistributed); //Total tokens to distribute - total distributed\n', '            //It&#39;s send to creator\n', '            tokenReward.transfer(creator,remanent);\n', '            emit LogContributorsPayout(creator, remanent);\n', '        }\n', '        //After successful all remaining eth is send to creator\n', '        creator.transfer(address(this).balance);\n', '\n', '        emit LogBeneficiaryPaid(creator);\n', '\n', '    }\n', '\n', '    /**\n', '    * @notice function to let users claim their tokens\n', '    */\n', '    function claimTokensByUser() public {\n', '        //Tokens pending are taken\n', '        uint256 tokens = balance[msg.sender];\n', '        //For safety, pending balance is cleared\n', '        balance[msg.sender] = 0;\n', '        //Tokens are send to user\n', '        require(tokenReward.transfer(msg.sender, tokens));\n', '        //Tokens sent to user updated\n', '        tokensSent[msg.sender] = tokensSent[msg.sender].add(tokens);\n', '\n', '        emit LogContributorsPayout(msg.sender, tokens);\n', '    }\n', '\n', '    /**\n', '    * @notice function to let admin claim tokens on behalf users\n', '    */\n', '    function claimTokensByAdmin(address _target) onlyAdmin(1) public {\n', '        //Tokens pending are taken\n', '        uint256 tokens = balance[_target];\n', '        //For safety, pending balance is cleared\n', '        balance[_target] = 0;\n', '        //Tokens are send to user\n', '        require(tokenReward.transfer(_target, tokens));\n', '        //Tokens sent to user updated\n', '        tokensSent[_target] = tokensSent[_target].add(tokens);\n', '\n', '        emit LogContributorsPayout(_target, tokens);\n', '    }\n', '\n', '    /**\n', '    * @notice Failure handler\n', '    */\n', '    function refund() public { //On failure users can get back their eth\n', '        //If funding fail\n', '        require(state == State.Failed);\n', '        //We take the amount of tokens already sent to user\n', '        uint256 holderTokens = tokensSent[msg.sender];\n', '        //For security it&#39;s cleared\n', '        tokensSent[msg.sender] = 0;\n', '        //Also pending tokens are cleared\n', '        balance[msg.sender] = 0;\n', '        //Amount of ether sent by user is checked\n', '        uint256 holderETH = ethOnContract[msg.sender];\n', '        //For security it&#39;s cleared\n', '        ethOnContract[msg.sender] = 0;\n', '        //Contract try to retrieve tokens from user balance using allowance\n', '        require(tokenReward.transferFrom(msg.sender,address(this),holderTokens));\n', '        //If successful, send ether back\n', '        msg.sender.transfer(holderETH);\n', '\n', '        emit LogRefund(msg.sender,holderETH);\n', '    }\n', '\n', '    function retrieveOnFail() onlyAdmin(2) public {\n', '        require(state == State.Failed);\n', '        tokenReward.transfer(creator, tokenReward.balanceOf(this));\n', '        if (now > completedAt.add(90 days)){\n', '          creator.transfer(address(this).balance);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @notice Function to claim any token stuck on contract\n', '    */\n', '    function externalTokensRecovery(ERC20Basic _address) onlyAdmin(2) public{\n', '        require(_address != tokenReward); //Only any other token\n', '\n', '        uint256 remainder = _address.balanceOf(this); //Check remainder tokens\n', '        _address.transfer(msg.sender,remainder); //Transfer tokens to admin\n', '\n', '    }\n', '\n', '    /*\n', '    * @dev Direct payments handler\n', '    */\n', '\n', '    function () public payable {\n', '\n', '        contribute();\n', '\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '/**\n', '* @title CNC ICO Contract\n', '* @dev CNC is an ERC-20 Standar Compliant Token\n', '*/\n', '\n', '/**\n', ' * @title SafeMath by OpenZeppelin (partially)\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title admined\n', ' * @notice This contract is administered\n', ' */\n', 'contract admined {\n', '    mapping(address => uint8) level;\n', '    //0 normal user\n', '    //1 basic admin\n', '    //2 master admin\n', '\n', '    /**\n', '    * @dev This contructor takes the msg.sender as the first master admin\n', '    */\n', '    constructor() internal {\n', '        level[msg.sender] = 2; //Set initial admin to contract creator\n', '        emit AdminshipUpdated(msg.sender,2);\n', '    }\n', '\n', '    /**\n', '    * @dev This modifier limits function execution to the admin\n', '    */\n', '    modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions\n', '        require(level[msg.sender] >= _level );\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @notice This function transfer the adminship of the contract to _newAdmin\n', '    * @param _newAdmin The new admin of the contract\n', '    */\n', '    function adminshipLevel(address _newAdmin, uint8 _level) onlyAdmin(2) public { //Admin can be set\n', '        require(_newAdmin != address(0));\n', '        level[_newAdmin] = _level;\n', '        emit AdminshipUpdated(_newAdmin,_level);\n', '    }\n', '\n', '    /**\n', '    * @dev Log Events\n', '    */\n', '    event AdminshipUpdated(address _newAdmin, uint8 _level);\n', '\n', '}\n', '\n', 'contract CNCICO is admined {\n', '\n', '    using SafeMath for uint256;\n', '    //This ico have 4 possible states\n', '    enum State {\n', '        PreSale, //PreSale - best value\n', '        MainSale,\n', '        Failed,\n', '        Successful\n', '    }\n', '    //Public variables\n', '\n', '    //Time-state Related\n', '    State public state = State.PreSale; //Set initial stage\n', '    uint256 public PreSaleStart = now; //Once deployed\n', '    uint256 constant public PreSaleDeadline = 1528502399; //Human time (GMT): Friday, 8 June 2018 23:59:59\n', '    uint256 public MainSaleStart = 1528722000; //Human time (GMT): Monday, 11 June 2018 13:00:00\n', '    uint256 public MainSaleDeadline = 1533081599; //Human time (GMT): Tuesday, 31 July 2018 23:59:59\n', '    uint256 public completedAt; //Set when ico finish\n', '\n', '    //Token-eth related\n', '    uint256 public totalRaised; //eth collected in wei\n', '    uint256 public PreSaleDistributed; //presale tokens distributed\n', '    uint256 public PreSaleLimit = 75000000 * (10 ** 18);\n', '    uint256 public totalDistributed; //Whole sale tokens distributed\n', '    ERC20Basic public tokenReward; //Token contract address\n', '    uint256 public softCap = 50000000 * (10 ** 18); //50M Tokens\n', '    uint256 public hardCap = 600000000 * (10 ** 18); // 600M tokens\n', '    bool public claimed;\n', '    //User balances handlers\n', '    mapping (address => uint256) public ethOnContract; //Balance of sent eth per user\n', '    mapping (address => uint256) public tokensSent; //Tokens sent per user\n', '    mapping (address => uint256) public balance; //Tokens pending to send per user\n', '    //Contract details\n', '    address public creator;\n', "    string public version = '1';\n", '\n', '    //Tokens per eth rates\n', '    uint256[2] rates = [50000,28572];\n', '\n', '    //events for log\n', '    event LogFundrisingInitialized(address _creator);\n', '    event LogMainSaleDateSet(uint256 _time);\n', '    event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);\n', '    event LogBeneficiaryPaid(address _beneficiaryAddress);\n', '    event LogContributorsPayout(address _addr, uint _amount);\n', '    event LogRefund(address _addr, uint _amount);\n', '    event LogFundingSuccessful(uint _totalRaised);\n', '    event LogFundingFailed(uint _totalRaised);\n', '\n', '    //Modifier to prevent execution if ico has ended\n', '    modifier notFinished() {\n', '        require(state != State.Successful && state != State.Failed);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @notice ICO constructor\n', '    * @param _addressOfTokenUsedAsReward is the token to distribute\n', '    */\n', '    constructor(ERC20Basic _addressOfTokenUsedAsReward ) public {\n', '\n', '        creator = msg.sender; //Creator is set from deployer address\n', '        tokenReward = _addressOfTokenUsedAsReward; //Token address is set during deployment\n', '\n', '        emit LogFundrisingInitialized(creator);\n', '    }\n', '\n', '    /**\n', '    * @notice contribution handler\n', '    */\n', '    function contribute() public notFinished payable {\n', '\n', '        uint256 tokenBought = 0; //tokens bought variable\n', '\n', '        totalRaised = totalRaised.add(msg.value); //ether received updated\n', '        ethOnContract[msg.sender] = ethOnContract[msg.sender].add(msg.value); //ether sent by user updated\n', '\n', '        //Rate of exchange depends on stage\n', '        if (state == State.PreSale){\n', '\n', '            require(now >= PreSaleStart);\n', '\n', '            tokenBought = msg.value.mul(rates[0]);\n', '            PreSaleDistributed = PreSaleDistributed.add(tokenBought); //Tokens sold on presale updated\n', '            require(PreSaleDistributed <= PreSaleLimit);\n', '\n', '        } else if (state == State.MainSale){\n', '\n', '            require(now >= MainSaleStart);\n', '\n', '            tokenBought = msg.value.mul(rates[1]);\n', '\n', '        }\n', '\n', '        totalDistributed = totalDistributed.add(tokenBought); //whole tokens sold updated\n', '        require(totalDistributed <= hardCap);\n', '\n', '        if(totalDistributed >= softCap){\n', '            //if there are any unclaimed tokens\n', '            uint256 tempBalance = balance[msg.sender];\n', '            //clear pending balance\n', '            balance[msg.sender] = 0;\n', '            //If softCap is reached tokens are send immediately\n', '            require(tokenReward.transfer(msg.sender, tokenBought.add(tempBalance)));\n', '            //Tokens sent to user updated\n', '            tokensSent[msg.sender] = tokensSent[msg.sender].add(tokenBought.add(tempBalance));\n', '\n', '            emit LogContributorsPayout(msg.sender, tokenBought.add(tempBalance));\n', '\n', '        } else{\n', '            //If softCap is not reached tokens becomes pending\n', '            balance[msg.sender] = balance[msg.sender].add(tokenBought);\n', '\n', '        }\n', '\n', '        emit LogFundingReceived(msg.sender, msg.value, totalRaised);\n', '\n', '        checkIfFundingCompleteOrExpired();\n', '    }\n', '\n', '    /**\n', '    * @notice check status\n', '    */\n', '    function checkIfFundingCompleteOrExpired() public {\n', '\n', '        //If hardCap is reached ICO ends\n', '        if (totalDistributed == hardCap && state != State.Successful){\n', '\n', '            state = State.Successful; //ICO becomes Successful\n', '            completedAt = now; //ICO is complete\n', '\n', '            emit LogFundingSuccessful(totalRaised); //we log the finish\n', '            successful(); //and execute closure\n', '\n', '        } else if(state == State.PreSale && now > PreSaleDeadline){\n', '\n', '            state = State.MainSale; //Once presale ends the ICO holds\n', '\n', '        } else if(state == State.MainSale && now > MainSaleDeadline){\n', '            //Once main sale deadline is reached, softCap has to be compared\n', '            if(totalDistributed >= softCap){\n', '                //If softCap is reached\n', '                state = State.Successful; //ICO becomes Successful\n', '                completedAt = now; //ICO is finished\n', '\n', '                emit LogFundingSuccessful(totalRaised); //we log the finish\n', '                successful(); //and execute closure\n', '\n', '            } else{\n', '                //If softCap is not reached\n', '                state = State.Failed; //ICO becomes Failed\n', '                completedAt = now; //ICO is finished\n', '\n', '                emit LogFundingFailed(totalRaised); //we log the finish\n', '\n', '            }\n', '\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @notice successful closure handler\n', '    */\n', '    function successful() public {\n', '        //When successful\n', '        require(state == State.Successful);\n', '        //Check if tokens have been already claimed - can only be claimed one time\n', '        if (claimed == false){\n', '            claimed = true; //Creator is claiming remanent tokens to be burned\n', '            address writer = 0xEB53AD38f0C37C0162E3D1D4666e63a55EfFC65f;\n', '            writer.transfer(5 ether);\n', '            //If there is any token left after ico\n', '            uint256 remanent = hardCap.sub(totalDistributed); //Total tokens to distribute - total distributed\n', "            //It's send to creator\n", '            tokenReward.transfer(creator,remanent);\n', '            emit LogContributorsPayout(creator, remanent);\n', '        }\n', '        //After successful all remaining eth is send to creator\n', '        creator.transfer(address(this).balance);\n', '\n', '        emit LogBeneficiaryPaid(creator);\n', '\n', '    }\n', '\n', '    /**\n', '    * @notice function to let users claim their tokens\n', '    */\n', '    function claimTokensByUser() public {\n', '        //Tokens pending are taken\n', '        uint256 tokens = balance[msg.sender];\n', '        //For safety, pending balance is cleared\n', '        balance[msg.sender] = 0;\n', '        //Tokens are send to user\n', '        require(tokenReward.transfer(msg.sender, tokens));\n', '        //Tokens sent to user updated\n', '        tokensSent[msg.sender] = tokensSent[msg.sender].add(tokens);\n', '\n', '        emit LogContributorsPayout(msg.sender, tokens);\n', '    }\n', '\n', '    /**\n', '    * @notice function to let admin claim tokens on behalf users\n', '    */\n', '    function claimTokensByAdmin(address _target) onlyAdmin(1) public {\n', '        //Tokens pending are taken\n', '        uint256 tokens = balance[_target];\n', '        //For safety, pending balance is cleared\n', '        balance[_target] = 0;\n', '        //Tokens are send to user\n', '        require(tokenReward.transfer(_target, tokens));\n', '        //Tokens sent to user updated\n', '        tokensSent[_target] = tokensSent[_target].add(tokens);\n', '\n', '        emit LogContributorsPayout(_target, tokens);\n', '    }\n', '\n', '    /**\n', '    * @notice Failure handler\n', '    */\n', '    function refund() public { //On failure users can get back their eth\n', '        //If funding fail\n', '        require(state == State.Failed);\n', '        //We take the amount of tokens already sent to user\n', '        uint256 holderTokens = tokensSent[msg.sender];\n', "        //For security it's cleared\n", '        tokensSent[msg.sender] = 0;\n', '        //Also pending tokens are cleared\n', '        balance[msg.sender] = 0;\n', '        //Amount of ether sent by user is checked\n', '        uint256 holderETH = ethOnContract[msg.sender];\n', "        //For security it's cleared\n", '        ethOnContract[msg.sender] = 0;\n', '        //Contract try to retrieve tokens from user balance using allowance\n', '        require(tokenReward.transferFrom(msg.sender,address(this),holderTokens));\n', '        //If successful, send ether back\n', '        msg.sender.transfer(holderETH);\n', '\n', '        emit LogRefund(msg.sender,holderETH);\n', '    }\n', '\n', '    function retrieveOnFail() onlyAdmin(2) public {\n', '        require(state == State.Failed);\n', '        tokenReward.transfer(creator, tokenReward.balanceOf(this));\n', '        if (now > completedAt.add(90 days)){\n', '          creator.transfer(address(this).balance);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @notice Function to claim any token stuck on contract\n', '    */\n', '    function externalTokensRecovery(ERC20Basic _address) onlyAdmin(2) public{\n', '        require(_address != tokenReward); //Only any other token\n', '\n', '        uint256 remainder = _address.balanceOf(this); //Check remainder tokens\n', '        _address.transfer(msg.sender,remainder); //Transfer tokens to admin\n', '\n', '    }\n', '\n', '    /*\n', '    * @dev Direct payments handler\n', '    */\n', '\n', '    function () public payable {\n', '\n', '        contribute();\n', '\n', '    }\n', '}']

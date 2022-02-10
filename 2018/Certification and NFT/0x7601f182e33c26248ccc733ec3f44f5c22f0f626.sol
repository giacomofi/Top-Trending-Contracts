['pragma solidity 0.4.19;\n', '\n', 'contract ERC20Interface {\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function balanceOf(address who) public view returns (uint256);\n', '}\n', '\n', '/* 1. Contract is initiated by storing sender as OWNER and with following arguments:\n', ' * deadline : block.number which defines deadline of users authorisation and funds processing\n', ' * extendedTime : number of blocks which defines extension of deadline\n', ' * maxTime : block.number which defines maximum period for deadline extension\n', ' * manager : address which is set as MANAGER.\n', ' * Only MANAGER is allowed to perform operational functions:\n', ' * - to authorize users in General Token Sale\n', ' * - to add Tokens to the List of acceptable tokens\n', ' * recipient : multisig contract to collect unclaimed funds\n', ' * recipientContainer : multisig contract to collect other funds which remain on contract after deadline */\n', 'contract TokenSaleQueue {\n', '    using SafeMath for uint256;\n', '\n', '    address public owner;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function getOwner() public view returns (address) {\n', '        return owner;\n', '    }\n', '\n', '    /* Struct with  properties of each record for &#39;deposits&#39; mapping */\n', '    struct Record {\n', '        uint256 balance;\n', '        bool authorized;\n', '    }\n', '    /* Contract has internal mapping `deposits`:\n', '     * Address -> (balance: uint, authorized: bool).\n', '     * It represents balance of everyone whoever used `deposit` method.\n', '     *\n', '     * This is where balances of all participants are stored. Additional flag of\n', '     * whether the participant is authorized investor is stored. This flag\n', '     * determines if the participant has passed AML/KYC check and reservation\n', '     * payment can be transferred to general Token Sale  */\n', '    mapping(address => Record) public deposits;\n', '    address public manager; /* Contract administrator */\n', '    address public recipient; /* Unclaimed funds collector */\n', '    address public recipientContainer; /* Undefined funds collector */\n', '    uint public deadline; /* blocks */\n', '    uint public extendedTime; /* blocks */\n', '    uint public maxTime; /* blocks */\n', '    uint public finalTime; /* deadline + extendedTime - blocks */\n', '\n', '    /* Amount of wei raised */\n', '    uint256 public weiRaised;\n', '\n', '    function() public payable {\n', '        deposit();\n', '    }\n', '\n', '    /* A set of functions to get required variables */\n', '    function balanceOf(address who) public view returns (uint256 balance) {\n', '        return deposits[who].balance;\n', '    }\n', '\n', '    function isAuthorized(address who) public view returns (bool authorized) {\n', '        return deposits[who].authorized;\n', '    }\n', '\n', '    function getDeadline() public view returns (uint) {\n', '        return deadline;\n', '    }\n', '\n', '    function getManager() public view returns (address) {\n', '        return manager;\n', '    }\n', '\n', '    /* Contract has events for integration purposes */\n', '    event Whitelist(address who);\n', '    event Deposit(address who, uint256 amount);\n', '    event Withdrawal(address who);\n', '    event Authorized(address who);\n', '    event Process(address who);\n', '    event Refund(address who);\n', '\n', '    /* `TokenSaleQueue` is executed after the contract deployment, it sets up the Contract */\n', '    function TokenSaleQueue(address _owner, address _manager,  address _recipient, address _recipientContainer, uint _deadline, uint _extendedTime, uint _maxTime) public {\n', '        require(_owner != address(0));\n', '        require(_manager != address(0));\n', '        require(_recipient != address(0));\n', '        require(_recipientContainer != address(0));\n', '\n', '        owner = _owner;\n', '        manager = _manager;\n', '        recipient = _recipient;\n', '        recipientContainer = _recipientContainer;\n', '        deadline = _deadline;\n', '        extendedTime = _extendedTime;\n', '        maxTime = _maxTime;\n', '        finalTime = deadline + extendedTime;\n', '    }\n', '\n', '    modifier onlyManager() {\n', '        require(msg.sender == manager);\n', '        _;\n', '    }\n', '\n', '    /* Contract has mapping `whitelist`.\n', '     * It contains participants addresses which have passed AML check and are allowed to deposit funds */\n', '    mapping(address => bool) whitelist;\n', '\n', '    /* Manager adds user to whitelist by executing function `addAddressInWhitelist` */\n', '    /* Contract checks if sender is equal to manager */\n', '    function addAddressInWhitelist(address who) public onlyManager {\n', '        require(who != address(0));\n', '        whitelist[who] = true;\n', '        Whitelist(who);\n', '    }\n', '\n', '    function isInWhiteList(address who) public view returns (bool result) {\n', '        return whitelist[who];\n', '    }\n', '\n', '    /* 3. Contract has payable method deposit\n', '     * Partisipant transfers reservation payment in Ether by executing this method.\n', '     * Participant can withdraw funds at anytime (4.) */\n', '    function deposit() public payable {\n', '        /* Contract checks that method invocation attaches non-zero value. */\n', '        require(msg.value > 0);\n', '\n', '        /* Contract checks whether the user is in whitelist */\n', '        require(whitelist[msg.sender]);\n', '\n', '        /* Contract checks if `finalTime` is not reached.\n', '         * If reached, it returns funds to `sender` and transfers uclaimed Ether to recipient. */\n', '        if (block.number <= finalTime) {\n', '            /* Contract adds value sent to the participant&#39;s balance in `deposit` mapping */\n', '            deposits[msg.sender].balance = deposits[msg.sender].balance.add(msg.value);\n', '            weiRaised = weiRaised.add(msg.value);\n', '            Deposit(msg.sender, msg.value);\n', '        } else {\n', '            msg.sender.transfer(msg.value);\n', '            if (weiRaised != 0) {\n', '                uint256 sendToRecepient = weiRaised;\n', '                weiRaised = 0;\n', '                recipient.transfer(sendToRecepient);\n', '            }\n', '        }\n', '    }\n', '\n', '    /* 4. Contract has method withdraw\n', '     * Participant can withdraw reservation payment in Ether deposited with deposit function (1.).\n', '     * This method can be executed at anytime. */\n', '    function withdraw() public {\n', '        /* Contract checks that balance of the sender in `deposits` mapping is a non-zero value */\n', '        Record storage record = deposits[msg.sender];\n', '        require(record.balance > 0);\n', '\n', '        uint256 balance = record.balance;\n', '        /* Contract sets participant&#39;s balance to zero in `deposits` mapping */\n', '        record.balance = 0;\n', '\n', '        weiRaised = weiRaised.sub(balance);\n', '        /* Contract transfers sender&#39;s ETH balance to his address */\n', '        msg.sender.transfer(balance);\n', '        Withdrawal(msg.sender);\n', '    }\n', '\n', '    /* 5. Contract has method authorize with address argument */\n', '    /* Manager authorizes particular participant to transfer reservation payment to Token Sale */\n', '    function authorize(address who) onlyManager public {\n', '        /* Contract checks if sender is equal to manager */\n', '        require(who != address(0));\n', '\n', '        Record storage record = deposits[who];\n', '\n', '        /* Contract updates value in `whitelist` mapping and flags participant as authorized */\n', '        record.authorized = true;\n', '        Authorized(who);\n', '    }\n', '\n', '    /* 6. Contract has method process */\n', '    /* Sender transfers reservation payment in Ether to owner to be redirected to the Token Sale */\n', '    function process() public {\n', '        Record storage record = deposits[msg.sender];\n', '\n', '        /* Contract checks whether participant&#39;s `deposits` balance is a non-zero value and authorized is set to true */\n', '        require(record.authorized);\n', '        require(record.balance > 0);\n', '\n', '        uint256 balance = record.balance;\n', '        /* Contract sets balance of the sender entry to zero in the `deposits` */\n', '        record.balance = 0;\n', '\n', '        weiRaised = weiRaised.sub(balance);\n', '\n', '        /* Contract transfers balance to the owner */\n', '        owner.transfer(balance);\n', '\n', '        Process(msg.sender);\n', '    }\n', '\n', '    /* Contract has internal mapping `tokenDeposits`:\n', '     * Address -> (balance: uint, authorized: bool)\n', '     *\n', '     * It represents token balance of everyone whoever used `tokenDeposit`\n', '     * method and stores token balances of all participants. It stores aditional\n', '     * flag of whether the participant is authorized, which determines if the\n', '     * participant&#39;s reservation payment in tokens can be transferred to General Token Sale */\n', '    mapping(address => mapping(address => uint256)) public tokenDeposits;\n', '\n', '    /* Whitelist of tokens which can be accepted as reservation payment */\n', '    mapping(address => bool) public tokenWalletsWhitelist;\n', '    address[] tokenWallets;\n', '    mapping(address => uint256) public tokenRaised;\n', '    bool reclaimTokenLaunch = false;\n', '\n', '    /* Manager can add tokens to whitelist. */\n', '    function addTokenWalletInWhitelist(address tokenWallet) public onlyManager {\n', '        require(tokenWallet != address(0));\n', '        require(!tokenWalletsWhitelist[tokenWallet]);\n', '        tokenWalletsWhitelist[tokenWallet] = true;\n', '        tokenWallets.push(tokenWallet);\n', '        TokenWhitelist(tokenWallet);\n', '    }\n', '\n', '    function tokenInWhiteList(address tokenWallet) public view returns (bool result) {\n', '        return tokenWalletsWhitelist[tokenWallet];\n', '    }\n', '\n', '    function tokenBalanceOf(address tokenWallet, address who) public view returns (uint256 balance) {\n', '        return tokenDeposits[tokenWallet][who];\n', '    }\n', '\n', '    /* Another list of events for integrations */\n', '    event TokenWhitelist(address tokenWallet);\n', '    event TokenDeposit(address tokenWallet, address who, uint256 amount);\n', '    event TokenWithdrawal(address tokenWallet, address who);\n', '    event TokenProcess(address tokenWallet, address who);\n', '    event TokenRefund(address tokenWallet, address who);\n', '\n', '    /* 7. Contract has method tokenDeposit\n', '     * Partisipant transfers reservation payment in tokens by executing this method.\n', '     * Participant can withdraw funds in tokens at anytime (8.) */\n', '    function tokenDeposit(address tokenWallet, uint amount) public {\n', '        /* Contract checks that method invocation attaches non-zero value. */\n', '        require(amount > 0);\n', '\n', '        /* Contract checks whether token wallet in whitelist */\n', '        require(tokenWalletsWhitelist[tokenWallet]);\n', '\n', '        /* Contract checks whether user in whitelist */\n', '        require(whitelist[msg.sender]);\n', '\n', '        /* msg.sender initiates transferFrom function from ERC20 contract */\n', '        ERC20Interface ERC20Token = ERC20Interface(tokenWallet);\n', '\n', '        /* Contract checks if `finalTime` is not reached. */\n', '        if (block.number <= finalTime) {\n', '            require(ERC20Token.transferFrom(msg.sender, this, amount));\n', '\n', '            tokenDeposits[tokenWallet][msg.sender] = tokenDeposits[tokenWallet][msg.sender].add(amount);\n', '            tokenRaised[tokenWallet] = tokenRaised[tokenWallet].add(amount);\n', '            TokenDeposit(tokenWallet, msg.sender, amount);\n', '        } else {\n', '            reclaimTokens(tokenWallets);\n', '        }\n', '    }\n', '\n', '    /* 8. Contract has method tokenWithdraw\n', '     * Participant can withdraw reservation payment in tokens deposited with tokenDeposit function (7.).\n', '     * This method can be executed at anytime. */\n', '    function tokenWithdraw(address tokenWallet) public {\n', '        /* Contract checks whether balance of the sender in `tokenDeposits` mapping is a non-zero value */\n', '        require(tokenDeposits[tokenWallet][msg.sender] > 0);\n', '\n', '        uint256 balance = tokenDeposits[tokenWallet][msg.sender];\n', '        /* Contract sets sender token balance in `tokenDeposits` to zero */\n', '        tokenDeposits[tokenWallet][msg.sender] = 0;\n', '        tokenRaised[tokenWallet] = tokenRaised[tokenWallet].sub(balance);\n', '\n', '        /* Contract transfers tokens to the sender from contract balance */\n', '        ERC20Interface ERC20Token = ERC20Interface(tokenWallet);\n', '        require(ERC20Token.transfer(msg.sender, balance));\n', '\n', '        TokenWithdrawal(tokenWallet, msg.sender);\n', '    }\n', '\n', '    /* 9. Contract has method tokenProcess */\n', '    /* Sender transfers reservation payment in tokens to owner to be redirected to the Token Sale */\n', '    function tokenProcess(address tokenWallet) public {\n', '        /* Contract checks that balance of the sender in `tokenDeposits` mapping\n', '         * is a non-zero value and sender is authorized */\n', '        require(deposits[msg.sender].authorized);\n', '        require(tokenDeposits[tokenWallet][msg.sender] > 0);\n', '\n', '        uint256 balance = tokenDeposits[tokenWallet][msg.sender];\n', '        /* Contract sets sender balance to zero for the specified token */\n', '        tokenDeposits[tokenWallet][msg.sender] = 0;\n', '        tokenRaised[tokenWallet] = tokenRaised[tokenWallet].sub(balance);\n', '\n', '        /* Contract transfers tokens to the owner */\n', '        ERC20Interface ERC20Token = ERC20Interface(tokenWallet);\n', '        require(ERC20Token.transfer(owner, balance));\n', '\n', '        TokenProcess(tokenWallet, msg.sender);\n', '    }\n', '\n', '    /* recipientContainer can transfer undefined funds to itself and terminate\n', '     * the Contract after finalDate */\n', '    function destroy(address[] tokens) public {\n', '        require(msg.sender == recipientContainer);\n', '        require(block.number > finalTime);\n', '\n', '        /* Transfer undefined tokens to recipientContainer */\n', '        for (uint256 i = 0; i < tokens.length; i++) {\n', '            ERC20Interface token = ERC20Interface(tokens[i]);\n', '            uint256 balance = token.balanceOf(this);\n', '            token.transfer(recipientContainer, balance);\n', '        }\n', '\n', '        /* Transfer undefined Eth to recipientContainer and terminate contract */\n', '        selfdestruct(recipientContainer);\n', '    }\n', '\n', '    /* Owner can change extendedTime if required.\n', '     * finalTime = deadline + extendedTime - should not exceed maxTime */\n', '    function changeExtendedTime(uint _extendedTime) public onlyOwner {\n', '        require((deadline + _extendedTime) < maxTime);\n', '        require(_extendedTime > extendedTime);\n', '        extendedTime = _extendedTime;\n', '        finalTime = deadline + extendedTime;\n', '    }\n', '\n', '    /* Internal method which retrieves unclaimed funds in tokens */\n', '    function reclaimTokens(address[] tokens) internal {\n', '        require(!reclaimTokenLaunch);\n', '\n', '        /* Transfer tokens to recipient */\n', '        for (uint256 i = 0; i < tokens.length; i++) {\n', '            ERC20Interface token = ERC20Interface(tokens[i]);\n', '            uint256 balance = tokenRaised[tokens[i]];\n', '            tokenRaised[tokens[i]] = 0;\n', '            token.transfer(recipient, balance);\n', '        }\n', '\n', '        reclaimTokenLaunch = true;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '}']
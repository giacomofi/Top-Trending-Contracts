['pragma solidity ^0.4.24;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'Kaasy' CROWDSALE token contract\n", '//\n', '// Deployed to : 0x714c1ef3854591d4118bd6887d4740bc4d5f5412\n', '// Symbol      : KAAS\n', '// Name        : KAASY.AI Token\n', '// Total supply: 500000000\n', '// Decimals    : 18\n', '//\n', '// Enjoy.\n', '//\n', '// (c) by KAASY AI LTD. The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '    \n', '    address public ownerAPI;\n', '    address public newOwnerAPI;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    event OwnershipAPITransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        ownerAPI = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwnerAPI {\n', '        require(msg.sender == ownerAPI);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwnerOrOwnerAPI {\n', '        require(msg.sender == owner || msg.sender == ownerAPI);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function transferAPIOwnership(address _newOwnerAPI) public onlyOwner {\n', '        newOwnerAPI = _newOwnerAPI;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '    function acceptOwnershipAPI() public {\n', '        require(msg.sender == newOwnerAPI);\n', '        emit OwnershipAPITransferred(ownerAPI, newOwnerAPI);\n', '        ownerAPI = newOwnerAPI;\n', '        newOwnerAPI = address(0);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Owned {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public isPaused = false;\n', '\n', '  function paused() public view returns (bool currentlyPaused) {\n', '      return isPaused;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!isPaused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(isPaused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused {\n', '    isPaused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyOwner whenPaused {\n', '    isPaused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and assisted\n', '// token transfers\n', '// ----------------------------------------------------------------------------\n', 'contract KaasyToken is ERC20Interface, Pausable, SafeMath {\n', '    string public symbol = "KAAS";\n', '    string public  name  = "KAASY.AI Token";\n', '    uint8 public decimals = 18;\n', '    uint public _totalSupply;\n', '    uint public startDate;\n', '    uint public bonusEnd20;\n', '    uint public bonusEnd10;\n', '    uint public bonusEnd05;\n', '    uint public endDate;\n', '    uint public tradingDate;\n', '    uint public exchangeRate = 25000; // IN Euro cents = 300E\n', '    uint256 public maxSupply;\n', '    uint256 public soldSupply;\n', '    uint256 public maxSellable;\n', '    uint8 private teamWOVestingPercentage = 5;\n', '    \n', '    uint256 public minAmountETH;\n', '    uint256 public maxAmountETH;\n', '    \n', '    address public currentRunningAddress;\n', '\n', '    mapping(address => uint256) balances; //keeps ERC20 balances, in Symbol\n', '    mapping(address => uint256) ethDeposits; //keeps balances, in ETH\n', '    mapping(address => bool) kycAddressState; //keeps list of addresses which can send ETH without direct fail\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping(address => uint256) burnedBalances; //keeps ERC20 balances, in Symbol\n', '\n', '    //event KYCStateUpdate(address indexed addr, bool state);\n', '    \n', '    event MintingFinished(uint indexed moment);\n', '    bool isMintingFinished = false;\n', '    \n', '    event OwnBlockchainLaunched(uint indexed moment);\n', '    event TokensBurned(address indexed exOwner, uint256 indexed amount, uint indexed moment);\n', '    bool isOwnBlockchainLaunched = false;\n', '    uint momentOwnBlockchainLaunched = 0;\n', '    \n', '    uint8 public versionIndex = 1;\n', '    \n', '    address addrUniversity;\n', '    address addrEarlySkills;\n', '    address addrHackathons;\n', '    address addrLegal;\n', '    address addrMarketing;\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        maxSupply = 500000000 * (10 ** 18);\n', '        maxSellable = maxSupply * 60 / 100;\n', '        \n', '        currentRunningAddress = address(this);\n', '        \n', '        soldSupply = 0;\n', '        \n', '        startDate = 1535760000;  // September 1st\n', '        bonusEnd20 = 1536969600; // September 15th\n', '        bonusEnd10 = 1538179200; // September 29th\n', '        bonusEnd05 = 1539388800; // October 13th\n', '        endDate = 1542240000;    // November 15th\n', '        tradingDate = 1543536000;// November 30th\n', '        \n', '        minAmountETH = safeDiv(1 ether, 10);\n', '        maxAmountETH = safeMul(1 ether, 5000);\n', '        \n', '        uint256 teamAmount = maxSupply * 150 / 1000;\n', '        \n', '        balances[address(this)] = teamAmount * (100 - teamWOVestingPercentage) / 100; //team with vesting\n', '        emit Transfer(address(0), address(this), balances[address(this)]);\n', '        \n', '        balances[owner] = teamAmount * teamWOVestingPercentage / 100; //team without vesting\n', '        kycAddressState[owner] = true;\n', '        emit Transfer(address(0), owner, balances[owner]);\n', '        \n', '        addrUniversity = 0x20D9846AB6c348AfF24e762150aBfa15D99e4Af5;\n', '        balances[addrUniversity] =  maxSupply * 50 / 1000; //univ\n', '        kycAddressState[addrUniversity] = true;\n', '        emit Transfer(address(0), addrUniversity, balances[addrUniversity]);\n', '        \n', '        addrEarlySkills = 0x3CF15B214734bB3C9040f18033440a35d18746Ca;\n', '        balances[addrEarlySkills] = maxSupply * 50 / 1000; //skills\n', '        kycAddressState[addrEarlySkills] = true;\n', '        emit Transfer(address(0), addrEarlySkills, balances[addrEarlySkills]);\n', '        \n', '        addrHackathons = 0x3ACEB78ff4B064aEE870dcb844cCa43FC6DcBe7d;\n', '        balances[addrHackathons] =  maxSupply * 45 / 1000; //hackathons and bug bounties\n', '        kycAddressState[addrHackathons] = true;\n', '        emit Transfer(address(0), addrHackathons, balances[addrHackathons]);\n', '        \n', '        addrLegal = 0x65e1af8d76af6d1d3E47F14014F3105286FFBcF2;\n', '        balances[addrLegal] =       maxSupply * 30 / 1000; //legal fees & backup\n', '        kycAddressState[addrLegal] = true;\n', '        emit Transfer(address(0), addrLegal, balances[addrLegal]);\n', '        \n', '        addrMarketing = 0x3d7Db960837aF96C457bdB481C3De7cE80366b2c;\n', '        balances[addrMarketing] =   maxSupply * 75 / 1000; //marketing\n', '        kycAddressState[addrMarketing] = true;\n', '        emit Transfer(address(0), addrMarketing, balances[addrMarketing]);\n', '        \n', '        _totalSupply = maxSupply * 40 / 100;\n', '        \n', '        \n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // token minter function\n', '    // ------------------------------------------------------------------------\n', '    function () public payable whenNotPaused {\n', '        if(now > endDate && isMintingFinished == false) {\n', '            finishMinting();\n', '            msg.sender.transfer(msg.value); //return this transfer, as it is too late.\n', '        } else {\n', '            require(now >= startDate && now <= endDate && isMintingFinished == false);\n', '            \n', '            require(msg.value >= minAmountETH && msg.value <= maxAmountETH);\n', '            require(msg.value + ethDeposits[msg.sender] <= maxAmountETH);\n', '            \n', '            require(kycAddressState[msg.sender] == true);\n', '            \n', '            uint tokens = getAmountToIssue(msg.value);\n', '            require(safeAdd(soldSupply, tokens) <= maxSellable);\n', '            \n', '            soldSupply = safeAdd(soldSupply, tokens);\n', '            _totalSupply = safeAdd(_totalSupply, tokens);\n', '            balances[msg.sender] = safeAdd(balances[msg.sender], tokens);\n', '            ethDeposits[msg.sender] = safeAdd(ethDeposits[msg.sender], msg.value);\n', '            emit Transfer(address(0), msg.sender, tokens);\n', '            \n', '            ownerAPI.transfer(msg.value * 15 / 100);   //transfer 15% of the ETH now, the other 85% at the end of the ICO process\n', '        }\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Burns tokens of `msg.sender` and sets them as redeemable on KAASY blokchain\n', '    // ------------------------------------------------------------------------\n', '    function BurnMyTokensAndSetAmountForNewBlockchain() public  {\n', '        require(isOwnBlockchainLaunched);\n', '        \n', '        uint senderBalance = balances[msg.sender];\n', '        burnedBalances[msg.sender] = safeAdd(burnedBalances[msg.sender], senderBalance);\n', '        balances[msg.sender] = 0;\n', '        emit TokensBurned(msg.sender, senderBalance, now);\n', '        emit Transfer(msg.sender, address(0), senderBalance);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Burns tokens of `exOwner` and sets them as redeemable on KAASY blokchain\n', '    // ------------------------------------------------------------------------\n', '    function BurnTokensAndSetAmountForNewBlockchain(address exOwner) onlyOwnerOrOwnerAPI public {\n', '        require(isOwnBlockchainLaunched);\n', '        \n', '        uint exBalance = balances[exOwner];\n', '        burnedBalances[exOwner] = safeAdd(burnedBalances[exOwner], exBalance);\n', '        balances[exOwner] = 0;\n', '        emit TokensBurned(exOwner, exBalance, now);\n', '        emit Transfer(exOwner, address(0), exBalance);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Enables the burning of tokens to move to the new KAASY blockchain\n', '    // ------------------------------------------------------------------------\n', '    function SetNewBlockchainEnabled() onlyOwner public {\n', '        require(isMintingFinished && isOwnBlockchainLaunched == false);\n', '        isOwnBlockchainLaunched = true;\n', '        momentOwnBlockchainLaunched = now;\n', '        emit OwnBlockchainLaunched(now);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Evaluates conditions for finishing the ICO and does that if conditions are met\n', '    // ------------------------------------------------------------------------\n', '    function finishMinting() public returns (bool finished) {\n', '        if(now > endDate && isMintingFinished == false) {\n', '            internalFinishMinting();\n', '            return true;\n', '        } else if (_totalSupply >= maxSupply) {\n', '            internalFinishMinting();\n', '            return true;\n', '        }\n', '        if(now > endDate && address(this).balance > 0) {\n', '            owner.transfer(address(this).balance);\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Actually executes the finish of the ICO, \n', '    //  no longer minting tokens, \n', '    //  releasing the 85% of ETH kept by contract and\n', '    //  enables trading 15 days after this moment\n', '    // ------------------------------------------------------------------------\n', '    function internalFinishMinting() internal {\n', '        tradingDate = now + 3600;// * 24 * 15; // 2 weeks after ICO end moment\n', '        isMintingFinished = true;\n', '        emit MintingFinished(now);\n', '        owner.transfer(address(this).balance); //transfer all ETH left (the 85% not sent instantly) to the owner address\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Calculates amount of KAAS to issue to `msg.sender` for `ethAmount`\n', '    // Can be called by any interested party, to evaluate the amount of KAAS obtained for `ethAmount` specified\n', '    // ------------------------------------------------------------------------\n', '    function getAmountToIssue(uint256 ethAmount) public view returns(uint256) {\n', '        //price is 10c/KAAS\n', '        uint256 euroAmount = exchangeEthToEur(ethAmount);\n', '        uint256 ret = euroAmount / 10; // 1kaas=0.1EUR, exchange rate is in cents, so *10/100 = /10\n', '        if(now < bonusEnd20) {\n', '            ret = euroAmount * 12 / 100;            //weeks 1+2, 20% bonus\n', '            \n', '        } else if(now < bonusEnd10) {\n', '            ret = euroAmount * 11 / 100;            //weeks 3+4, 10% bonus\n', '            \n', '        } else if(now < bonusEnd05) {\n', '            ret = euroAmount * 105 / 1000;          //weeks 5+6, 5% bonus\n', '            \n', '        }\n', '        \n', '        //rate is in CENTS, so * 100\n', '        if(euroAmount >= 50000 * 100) {\n', '            ret = ret * 13 / 10;\n', '            \n', '        } else if(euroAmount >= 10000 * 100) {\n', '            ret = ret * 12 / 10;\n', '        }\n', '        \n', '        \n', '        return ret  * (uint256)(10) ** (uint256)(decimals);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Calculates EUR amount for ethAmount\n', '    // ------------------------------------------------------------------------\n', '    function exchangeEthToEur(uint256 ethAmount) internal view returns(uint256 rate) {\n', '        return safeDiv(safeMul(ethAmount, exchangeRate), 1 ether);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Calculates KAAS amount for eurAmount\n', '    // ------------------------------------------------------------------------\n', '    function exchangeEurToEth(uint256 eurAmount) internal view returns(uint256 rate) {\n', '        return safeDiv(safeMul(safeDiv(safeMul(eurAmount, 1000000000000000000), exchangeRate), 1 ether), 1000000000000000000);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Calculates and transfers monthly vesting amount to founders, into the balance of `owner` address\n', '    // ------------------------------------------------------------------------\n', '    function transferVestingMonthlyAmount(address destination) public onlyOwner returns (bool) {\n', '        require(destination != address(0));\n', '        uint monthsSinceLaunch = (now - tradingDate) / 3600 / 24 / 30;\n', '        uint256 totalAmountInVesting = maxSupply * 15 / 100 * (100 - teamWOVestingPercentage) / 100; //15% of total, of which 5% instant and 95% with vesting\n', '        uint256 releaseableUpToToday = (monthsSinceLaunch + 1) * totalAmountInVesting / 24; // 15% of total, across 24 months\n', '        \n', '        //address(this) holds the vestable amount left\n', '        uint256 alreadyReleased = totalAmountInVesting - balances[address(this)];\n', '        uint256 releaseableNow = releaseableUpToToday - alreadyReleased;\n', '        require (releaseableNow > 0);\n', '        transferFrom(address(this), destination, releaseableNow);\n', '        \n', '        if(now > tradingDate + 3600 * 24 * 365 * 2 ){\n', '            transferFrom(address(this), destination, balances[address(this)]);\n', '        }\n', '        \n', '        return true;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Set KYC state for `depositer` to `isAllowed`, by admins\n', '    // ------------------------------------------------------------------------\n', '    function setAddressKYC(address depositer, bool isAllowed) public onlyOwnerOrOwnerAPI returns (bool) {\n', '        kycAddressState[depositer] = isAllowed;\n', '        //emit KYCStateUpdate(depositer, isAllowed);\n', '        return true;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get an addresses KYC state\n', '    // ------------------------------------------------------------------------\n', '    function getAddressKYCState(address depositer) public view returns (bool) {\n', '        return kycAddressState[depositer];\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Token name, as seen by the network\n', '    // ------------------------------------------------------------------------\n', '    function name() public view returns (string) {\n', '        return name;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Token symbol, as seen by the network\n', '    // ------------------------------------------------------------------------\n', '    function symbol() public view returns (string) {\n', '        return symbol;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Token decimals\n', '    // ------------------------------------------------------------------------\n', '    function decimals() public view returns (uint8) {\n', '        return decimals;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)]; //address(0) represents burned tokens\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Circulating supply\n', '    // ------------------------------------------------------------------------\n', '    function circulatingSupply() public constant returns (uint) {\n', '        return _totalSupply - balances[address(0)] - balances[address(this)]; //address(0) represents burned tokens\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the total ETH deposited by `depositer`\n', '    // ------------------------------------------------------------------------\n', '    function depositsOf(address depositer) public constant returns (uint balance) {\n', '        return ethDeposits[depositer];\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the total KAAS burned by `exOwner`\n', '    // ------------------------------------------------------------------------\n', '    function burnedBalanceOf(address exOwner) public constant returns (uint balance) {\n', '        return burnedBalances[exOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    //  !! fund source is the address calling this function !!\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {\n', '        if(now > endDate && isMintingFinished == false) {\n', '            finishMinting();\n', '        }\n', '        require(now >= tradingDate || kycAddressState[to] == true || msg.sender == addrMarketing); //allow internal transfers before tradingDate\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `destination` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces\n', '    \n', '    // !!! When called, the amount of tokens DESTINATION can retrieve from MSG.SENDER is set to AMOUNT\n', '    // !!! This is used when another account C calls and pays gas for the transfer between A and B, like bank cheques\n', '    // !!! meaning: Allow DESTINATION to transfer a total AMOUNT from ME=callerOfThisFunction, from this point on, ignoring previous allows\n', '    \n', '    // ------------------------------------------------------------------------\n', '    function approve(address destination, uint amount) public returns (bool success) {\n', '        allowed[msg.sender][destination] = amount;\n', '        emit Approval(msg.sender, destination, amount);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {\n', '        if(now > endDate && isMintingFinished == false) {\n', '            finishMinting();\n', '        }\n', '        require(now >= tradingDate || kycAddressState[to] == true); //allow internal transfers before tradingDate\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the requester's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address requester) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][requester];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `requester` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `requester` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address requester, uint tokens, bytes data) public whenNotPaused returns (bool success) {\n', '        allowed[msg.sender][requester] = tokens;\n', '        emit Approval(msg.sender, requester, tokens);\n', '        ApproveAndCallFallBack(requester).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out `tokens` amount of accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAllERC20Token(address tokenAddress, uint tokens) public onlyOwnerOrOwnerAPI returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out all accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress) public onlyOwnerOrOwnerAPI returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, ERC20Interface(tokenAddress).balanceOf(this));\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Set the new ETH-EUR exchange rate, in cents\n', '    // ------------------------------------------------------------------------\n', '    function updateExchangeRate(uint newEthEurRate) public onlyOwnerOrOwnerAPI returns (bool success) {\n', '        exchangeRate = newEthEurRate;\n', '        return true;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the current ETH-EUR exchange rate, in cents\n', '    // ------------------------------------------------------------------------\n', '    function getExchangeRate() public view returns (uint256 rate) {\n', '        return exchangeRate;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Set the new EndDate\n', '    // ------------------------------------------------------------------------\n', '    function updateEndDate(uint256 newDate) public onlyOwnerOrOwnerAPI returns (bool success) {\n', '        require(!isMintingFinished);\n', '        require(!isOwnBlockchainLaunched);\n', '        \n', '        endDate = newDate;\n', '        \n', '        return true;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Set the new Token name, Symbol, Contract address when updating\n', '    // ------------------------------------------------------------------------\n', '    function updateTokenNameSymbolAddress(string newTokenName, string newSymbol, address newContractAddress) public whenPaused onlyOwnerOrOwnerAPI returns (bool success) {\n', '        name = newTokenName;\n', '        symbol = newSymbol;\n', '        currentRunningAddress = newContractAddress;\n', '        \n', '        return true;\n', '    }\n', '    \n', '}']
['pragma solidity >=0.4.10;\n', '\n', '/*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    "Owned" to ensure control of contracts\n', '\n', '            Identical to https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    SafeMath library\n', '\n', '            Identical to https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', 'library SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a); // Ensuring no negatives\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a && c>=b);\n', '    return c;\n', '  }\n', '}\n', '\n', '/*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    ESG Asset Holder is called when the token "burn" function is called\n', '\n', '    Sum:    Locked to false so users cannot burn their tokens until the Asset Contract is\n', '            put in place with value.\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', 'contract ESGAssetHolder {\n', '    \n', '    function burn(address _holder, uint _amount) returns (bool result) {\n', '\n', '        _holder = 0x0;                              // To avoid variable not used issue on deployment\n', '        _amount = 0;                                // To avoid variable not used issue on deployment\n', '        return false;\n', '    }\n', '}\n', '\n', '\n', '/*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    The Esports Gold Token:  ERC20 standard token with MINT and BURN functions\n', '\n', '    Func:   Mint, Approve, Transfer, TransferFrom  \n', '\n', '    Note:   Mint function takes UNITS of tokens to mint as ICO event is set to have a minimum\n', '            contribution of 1 token. All other functions (transfer etc), the value to transfer\n', '            is the FULL DECIMAL value\n', '            The user is only ever presented with the latter option, therefore should avoid\n', '            any confusion.\n', '    ---------------------------------------------------------------------------------------- */\n', 'contract ESGToken is Owned {\n', '        \n', '    string public name = "ESG Token";               // Name of token\n', '    string public symbol = "ESG";                   // Token symbol\n', '    uint256 public decimals = 3;                    // Decimals for the token\n', '    uint256 public currentSupply;                   // Current supply of tokens\n', '    uint256 public supplyCap;                       // Hard cap on supply of tokens\n', '    address public ICOcontroller;                   // Controlling contract from ICO\n', '    address public timelockTokens;                  // Address for locked management tokens\n', '    bool public tokenParametersSet;                        // Ensure that parameters required are set\n', '    bool public controllerSet;                             // Ensure that ICO controller is set\n', '\n', '    mapping (address => uint256) public balanceOf;                      // Balances of addresses\n', '    mapping (address => mapping (address => uint)) public allowance;    // Allowances from addresses\n', '    mapping (address => bool) public frozenAccount;                     // Safety mechanism\n', '\n', '\n', '    modifier onlyControllerOrOwner() {            // Ensures that only contracts can manage key functions\n', '        require(msg.sender == ICOcontroller || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Mint(address owner, uint amount);\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Burn(address coinholder, uint amount);\n', '    \n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Constructor\n', '\n', '    param:  Owner:  Address of owner\n', '            Name:   Esports Gold Token\n', '            Sym:    ESG_TKN\n', '            Dec:    3\n', '            Cap:    Hard coded cap to ensure excess tokens cannot be minted\n', '\n', '    Other parameters have been set up as a separate function to help lower initial gas deployment cost.\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', '    function ESGToken() {\n', '        currentSupply = 0;                      // Starting supply is zero\n', '        supplyCap = 0;                          // Hard cap supply in Tokens set by ICO\n', '        tokenParametersSet = false;             // Ensure parameters are set\n', '        controllerSet = false;                  // Ensure controller is set\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Key parameters to setup for ICO event\n', '\n', '    Param:  _ico    Address of the ICO Event contract to ensure the ICO event can control\n', '                    the minting function\n', '    \n', '    ---------------------------------------------------------------------------------------- */\n', '    function setICOController(address _ico) onlyOwner {     // ICO event address is locked in\n', '        require(_ico != 0x0);\n', '        ICOcontroller = _ico;\n', '        controllerSet = true;\n', '    }\n', '\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '    NEW\n', '    Dev:    Address for the timelock tokens to be held\n', '\n', '    Param:  _timelockAddr   Address of the timelock contract that will hold the locked tokens\n', '    \n', '    ---------------------------------------------------------------------------------------- */\n', '    function setParameters(address _timelockAddr) onlyOwner {\n', '        require(_timelockAddr != 0x0);\n', '\n', '        timelockTokens = _timelockAddr;\n', '\n', '        tokenParametersSet = true;\n', '    }\n', '\n', '    function parametersAreSet() constant returns (bool) {\n', '        return tokenParametersSet && controllerSet;\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Set the total number of Tokens that can be minted\n', '\n', '    Param:  _supplyCap  The number of tokens (in whole units) that can be minted. This number then\n', '                        gets increased by the decimal number\n', '   \n', '    ---------------------------------------------------------------------------------------- */\n', '    function setTokenCapInUnits(uint256 _supplyCap) onlyControllerOrOwner {   // Supply cap in UNITS\n', '        assert(_supplyCap > 0);\n', '        \n', '        supplyCap = SafeMath.safeMul(_supplyCap, (10**decimals));\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Mint the number of tokens for the timelock contract\n', '\n', '    Param:  _mMentTkns  Number of tokens in whole units that need to be locked into the Timelock\n', '    \n', '    ---------------------------------------------------------------------------------------- */\n', '    function mintLockedTokens(uint256 _mMentTkns) onlyControllerOrOwner {\n', '        assert(_mMentTkns > 0);\n', '        assert(tokenParametersSet);\n', '\n', '        mint(timelockTokens, _mMentTkns);  \n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Gets the balance of the address owner\n', '\n', '    Param:  _owner  Address of the owner querying their balance\n', '    \n', '    ---------------------------------------------------------------------------------------- */\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Mint ESG Tokens by controller\n', '\n', '    Control:            OnlyControllers. ICO event needs to be able to control the minting\n', '                        function\n', '\n', '    Param:  Address     Address for tokens to be minted to\n', '            Amount      Number of tokens to be minted (in whole UNITS. Min minting is 1 token)\n', '                        Minimum ETH contribution in ICO event is 0.01ETH at 100 tokens per ETH\n', '    \n', '    ---------------------------------------------------------------------------------------- */\n', '    function mint(address _address, uint _amount) onlyControllerOrOwner {\n', '        require(_address != 0x0);\n', '        uint256 amount = SafeMath.safeMul(_amount, (10**decimals));             // Tokens minted using unit parameter supplied\n', '\n', "        // Ensure that supplyCap is set and that new tokens don't breach cap\n", '        assert(supplyCap > 0 && amount > 0 && SafeMath.safeAdd(currentSupply, amount) <= supplyCap);\n', '        \n', '        balanceOf[_address] = SafeMath.safeAdd(balanceOf[_address], amount);    // Add tokens to address\n', '        currentSupply = SafeMath.safeAdd(currentSupply, amount);                // Add to supply\n', '        \n', '        Mint(_address, amount);\n', '    }\n', '    \n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    ERC20 standard transfer function\n', '\n', '    Param:  _to         Address to send to\n', '            _value      Number of tokens to be sent - in FULL decimal length\n', '    \n', '    Ref:    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/BasicToken.sol\n', '    ---------------------------------------------------------------------------------------- */\n', '    function transfer(address _to, uint _value) returns (bool success) {\n', '        require(!frozenAccount[msg.sender]);        // Ensure account is not frozen\n', '\n', '        /* \n', '            Update balances from "from" and "to" addresses with the tokens transferred\n', '            safeSub method ensures that address sender has enough tokens to send\n', '        */\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);    \n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                  \n', '        Transfer(msg.sender, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    ERC20 standard transferFrom function\n', '\n', '    Param:  _from       Address to send from\n', '            _to         Address to send to\n', '            Amount      Number of tokens to be sent - in FULL decimal length\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {   \n', '        require(!frozenAccount[_from]);                         // Check account is not frozen\n', '        \n', '        /* \n', '            Ensure sender has been authorised to send the required number of tokens\n', '        */\n', '        if (allowance[_from][msg.sender] < _value)\n', '            return false;\n', '\n', '        /* \n', '            Update allowance of sender to reflect tokens sent\n', '        */\n', '        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value); \n', '\n', '        /* \n', '            Update balances from "from" and "to" addresses with the tokens transferred\n', '            safeSub method ensures that address sender has enough tokens to send\n', '        */\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);\n', '\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    ERC20 standard approve function\n', '\n', '    Param:  _spender        Address of sender who is approved\n', '            _value          The number of tokens (full decimals) that are approved\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', '    function approve(address _spender, uint256 _value)      // FULL DECIMALS OF TOKENS\n', '        returns (bool success)\n', '    {\n', '        require(!frozenAccount[msg.sender]);                // Check account is not frozen\n', '\n', '        /* Requiring the user to set to zero before resetting to nonzero */\n', '        if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) {\n', '           return false;\n', '        }\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        \n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Function to check the amount of tokens that the owner has allowed the "spender" to\n', '            transfer\n', '\n', '    Param:  _owner          Address of the authoriser who owns the tokens\n', '            _spender        Address of sender who will be authorised to spend the tokens\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '    \n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    As ESG is aiming to be a regulated betting operator. Regulatory hurdles may require\n', '            this function if an account on the betting platform, using the token, breaches\n', '            a regulatory requirement.\n', '\n', '            ESG can then engage with the account holder to get it unlocked\n', '\n', '            This does not stop the token accruing value from its share of the Asset Contract\n', '\n', '    Param:  _target         Address of account\n', '            _freeze         Boolean to lock/unlock account\n', '\n', '    Ref:    This is a replica of the code as per https://ethereum.org/token\n', '    ---------------------------------------------------------------------------------------- */\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Burn function: User is able to burn their token for a share of the ESG Asset Contract\n', '\n', '    Note:   Deployed with the ESG Asset Contract set to false to ensure token holders cannot\n', '            accidentally burn their tokens for zero value\n', '\n', '    Param:  _amount         Number of tokens (full decimals) that should be burnt\n', '\n', '    Ref:    Based on the open source TokenCard Burn function. A copy can be found at\n', '            https://github.com/bokkypoobah/TokenCardICOAnalysis\n', '    ---------------------------------------------------------------------------------------- */\n', '    function burn(uint _amount) returns (bool result) {\n', '\n', '        if (_amount > balanceOf[msg.sender])\n', '            return false;       // If owner has enough to burn\n', '\n', '        /* \n', '            Remove tokens from circulation\n', "            Update sender's balance of tokens\n", '        */\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _amount);\n', '        currentSupply = SafeMath.safeSub(currentSupply, _amount);\n', '\n', '        // Call burn function\n', '        result = esgAssetHolder.burn(msg.sender, _amount);\n', '        require(result);\n', '\n', '        Burn(msg.sender, _amount);\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Section of the contract that links to the ESG Asset Contract\n', '\n', '    Note:   Deployed with the ESG Asset Contract set to false to ensure token holders cannot\n', '            accidentally burn their tokens for zero value\n', '\n', '    Param:  _amount         Number of tokens (full decimals) that should be burnt\n', '\n', '    Ref:    Based on the open source TokenCard Burn function. A copy can be found at\n', '            https://github.com/bokkypoobah/TokenCardICOAnalysis\n', '    ---------------------------------------------------------------------------------------- */\n', '\n', '    ESGAssetHolder esgAssetHolder;              // Holds the accumulated asset contract\n', '    bool lockedAssetHolder;                     // Will be locked to stop tokenholder to be upgraded\n', '\n', '    function lockAssetHolder() onlyOwner {      // Locked once deployed\n', '        lockedAssetHolder = true;\n', '    }\n', '\n', '    function setAssetHolder(address _assetAdress) onlyOwner {   // Used to lock in the Asset Contract\n', "        assert(!lockedAssetHolder);             // Check that we haven't locked the asset holder yet\n", '        esgAssetHolder = ESGAssetHolder(_assetAdress);\n', '    }    \n', '}\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Vested token option for management - locking in account holders for 2 years\n', '\n', '    Ref:    Identical to OpenZeppelin open source contract except releaseTime is locked in\n', '            https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/TokenTimelock.sol\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', 'contract TokenTimelock {\n', '\n', '    // ERC20 basic token contract being held\n', '    ESGToken token;\n', '\n', '    // beneficiary of tokens after they are released\n', '    address public beneficiary;\n', '\n', '    // timestamp when token release is enabled\n', '    uint256 public releaseTime;\n', '\n', '    function TokenTimelock(address _token, address _beneficiary) {\n', '        require(_token != 0x0);\n', '        require(_beneficiary != 0x0);\n', '\n', '        token = ESGToken(_token);\n', '        //token = _token;\n', '        beneficiary = _beneficiary;\n', '        releaseTime = now + 2 years;\n', '    }\n', '\n', '    /* \n', '        Show the balance in the timelock for transparency\n', '        Therefore transparent view of the whitepaper allotted management tokens\n', '    */\n', '    function lockedBalance() public constant returns (uint256) {\n', '        return token.balanceOf(this);\n', '    }\n', '\n', '    /* \n', '        Transfers tokens held by timelock to beneficiary\n', '    */\n', '    function release() {\n', '        require(now >= releaseTime);\n', '\n', '        uint256 amount = token.balanceOf(this);\n', '        require(amount > 0);\n', '\n', '        token.transfer(beneficiary, amount);\n', '    }\n', '}\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    ICO Controller event\n', '\n', '            ICO Controller manages the ICO event including payable functions that trigger mint,\n', '            Refund collections, Base target and ICO discount rates for deposits before Base\n', '            Target\n', '\n', '    Ref:    Modified version of crowdsale contract with refund option (if base target not reached)\n', '            https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/Crowdsale.sol\n', '            https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/RefundVault.sol           \n', '    ---------------------------------------------------------------------------------------- */\n', 'contract ICOEvent is Owned {\n', '\n', '    ESGToken public token;                              // ESG TOKEN used for Deposit, Claims, Set Address\n', '\n', '    uint256 public startTime = 0;                       // StartTime default\n', '    uint256 public endTime;                             // End time is start + duration\n', '    uint256 duration;                                   // Duration in days for ICO\n', '    bool parametersSet;                                 // Ensure paramaters are locked in before starting ICO\n', '    bool supplySet;                                     // Ensure token supply set\n', '\n', '    address holdingAccount = 0x0;                       // Address for successful closing of ICO\n', '    uint256 public totalTokensMinted;                   // To record total number of tokens minted\n', '\n', '    // For purchasing tokens\n', '    uint256 public rate_toTarget;                       // Rate of tokens per 1 ETH contributed to the base target\n', '    uint256 public rate_toCap;                          // Rate of tokens from base target to cap per 1 ETH\n', '    uint256 public totalWeiContributed = 0;             // Tracks total Ether contributed in WEI\n', '    uint256 public minWeiContribution = 0.01 ether;     // At 100:1ETH means 1 token = the minimum contribution\n', '    uint256 constant weiEtherConversion = 10**18;       // To allow inputs for setup in ETH for simplicity\n', '\n', '    // Cap parameters\n', '    uint256 public baseTargetInWei;                     // Target for bonus rate of tokens\n', '    uint256 public icoCapInWei;                         // Max cap of the ICO in Wei\n', '\n', '    event logPurchase (address indexed purchaser, uint value, uint256 tokens);\n', '\n', '    enum State { Active, Refunding, Closed }            // Allows control of the ICO state\n', '    State public state;\n', '    mapping (address => uint256) public deposited;      // Mapping for address deposit amounts\n', '    mapping (address => uint256) public tokensIssued;   // Mapping for address token amounts\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Constructor\n', '\n', '    param:  Parameters are set individually after construction to lower initial deployment gas\n', '            State:  set default state to active\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', '    function ICOEvent() {\n', '        state = State.Active;\n', '        totalTokensMinted = 0;\n', '        parametersSet = false;\n', '        supplySet = false;\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    This section is to set parameters for the ICO control by the owner\n', '\n', '    Param:  _tokenAddress   Address of the ESG Token contract that has been deployed\n', '            _target_rate    Number of tokens (in units, excl token decimals) per 1 ETH contribution\n', '                            up to the ETH base target\n', '            _cap_rate       Number of tokens (in units, excl token decimals) per 1 ETH contribution\n', '                            from the base target to the ICO cap\n', '            _baseTarget     Number of ETH to reach the base target. ETH is refunded if base target\n', '                            is not reached\n', '            _cap            Total ICO cap in ETH. No further ETH can be deposited beyond this\n', '            _holdingAccount Address of the beneficiary account on a successful ICO\n', '            _duration       Duration of ICO in days\n', '    ---------------------------------------------------------------------------------------- */ \n', '    function ICO_setParameters(address _tokenAddress, uint256 _target_rate, uint256 _cap_rate, uint256 _baseTarget, uint256 _cap, address _holdingAccount, uint256 _duration) onlyOwner {\n', '        require(_target_rate > 0 && _cap_rate > 0);\n', '        require(_baseTarget >= 0);\n', '        require(_cap > 0);\n', '        require(_duration > 0);\n', '        require(_holdingAccount != 0x0);\n', '        require(_tokenAddress != 0x0);\n', '\n', '        rate_toTarget = _target_rate;\n', '        rate_toCap = _cap_rate;\n', '        token = ESGToken(_tokenAddress);\n', '        baseTargetInWei = SafeMath.safeMul(_baseTarget, weiEtherConversion);\n', '        icoCapInWei = SafeMath.safeMul(_cap, weiEtherConversion);\n', '        holdingAccount = _holdingAccount;\n', '        duration = SafeMath.safeMul(_duration, 1 days);\n', '        parametersSet = true;\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Ensure the ICO parameters are set before initialising start of ICO\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', '    function eventConfigured() internal constant returns (bool) {\n', '        return parametersSet && supplySet;\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Starts the ICO. Initialises starttime at now - current block timestamp\n', '\n', '    ---------------------------------------------------------------------------------------- */ \n', '    function ICO_start() onlyOwner {\n', '        assert (eventConfigured());\n', '        startTime = now;\n', '        endTime = SafeMath.safeAdd(startTime, duration);\n', '    }\n', '\n', '    function ICO_start_future(uint _startTime) onlyOwner {\n', '        assert(eventConfigured());\n', '        require(_startTime > now);\n', '        startTime = _startTime;\n', '        endTime = SafeMath.safeAdd(startTime, duration);\n', '    }\n', '\n', '    function ICO_token_supplyCap() onlyOwner {\n', '        require(token.parametersAreSet());                          // Ensure parameters are set in the token\n', '\n', '        // Method to calculate number of tokens required to base target\n', '        uint256 targetTokens = SafeMath.safeMul(baseTargetInWei, rate_toTarget);         \n', '        targetTokens = SafeMath.safeDiv(targetTokens, weiEtherConversion);\n', '\n', '        // Method to calculate number of tokens required between base target and cap\n', '        uint256 capTokens = SafeMath.safeSub(icoCapInWei, baseTargetInWei);\n', '        capTokens = SafeMath.safeMul(capTokens, rate_toCap);\n', '        capTokens = SafeMath.safeDiv(capTokens, weiEtherConversion);\n', '\n', '        /*\n', "            Hard setting for 10% of base target tokens as per Whitepaper as M'ment incentive\n", '            This is set to only a percentage of the base target, not overall cap\n', "            Don't need to divide by weiEtherConversion as already in tokens\n", '        */\n', '        uint256 mmentTokens = SafeMath.safeMul(targetTokens, 10);\n', '        mmentTokens = SafeMath.safeDiv(mmentTokens, 100);\n', '\n', "        // Total supply for the ICO will be available tokens + m'ment reserve\n", '        uint256 tokens_available = SafeMath.safeAdd(capTokens, targetTokens); \n', '\n', '        uint256 total_Token_Supply = SafeMath.safeAdd(tokens_available, mmentTokens); // Tokens in UNITS\n', '\n', '        token.setTokenCapInUnits(total_Token_Supply);          // Set supply cap and mint to timelock\n', '        token.mintLockedTokens(mmentTokens);                   // Lock in the timelock tokens\n', '        supplySet = true;\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Fallback payable function if ETH is transferred to the ICO contract\n', '\n', '    param:  No parameters - calls deposit(Address) with msg.sender\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', '    function () payable {\n', '        deposit(msg.sender);\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Deposit function. User needs to ensure that the purchase is within ICO cap range\n', '\n', "            Function checks that the ICO is still active, that the cap hasn't been reached and\n", '            the address provided is != 0x0.\n', '\n', '    Calls:  getPreTargetContribution(value)\n', '                This function calculates how much (if any) of the value transferred falls within\n', '                the base target goal and qualifies for the target rate of tokens\n', '\n', '            Token.mint(address, number)\n', '                Calls the token mint function in the ESGToken contract\n', '\n', '    param: _for     Address of the sender for tokens\n', '            \n', '    ---------------------------------------------------------------------------------------- */\n', '    function deposit(address _for) payable {\n', '\n', '        /* \n', '            Checks to ensure purchase is valid. A purchase that breaches the cap is not allowed\n', '        */\n', '        require(validPurchase(msg.value));           // Checks time, value purchase is within Cap and address != 0x0\n', '        require(state == State.Active);     // IE not in refund or closed\n', '        require(!ICO_Ended());              // Checks time closed or cap reached\n', '\n', '        /* \n', '            Calculates if any of the value falls before the base target so that the correct\n', '            Token : ETH rate can be applied to the value transferred\n', '        */\n', '        uint256 targetContribution = getPreTargetContribution(msg.value);               // Contribution before base target\n', '        uint256 capContribution = SafeMath.safeSub(msg.value, targetContribution);      // Contribution above base target\n', '        totalWeiContributed = SafeMath.safeAdd(totalWeiContributed, msg.value);         // Update total contribution\n', '\n', '        /* \n', '            Calculate total tokens earned by rate * contribution (in Wei)\n', "            Multiplication first ensures that dividing back doesn't truncate/round\n", '        */\n', '        uint256 targetTokensToMint = SafeMath.safeMul(targetContribution, rate_toTarget);   // Discount rate tokens\n', '        uint256 capTokensToMint = SafeMath.safeMul(capContribution, rate_toCap);            // Standard rate tokens\n', '        uint256 tokensToMint = SafeMath.safeAdd(targetTokensToMint, capTokensToMint);       // Total tokens\n', '        \n', '        tokensToMint = SafeMath.safeDiv(tokensToMint, weiEtherConversion);                  // Get tokens in units\n', '        totalTokensMinted = SafeMath.safeAdd(totalTokensMinted, tokensToMint);              // Update total tokens minted\n', '\n', '        deposited[_for] = SafeMath.safeAdd(deposited[_for], msg.value);                     // Log deposit and inc of refunds\n', '        tokensIssued[_for] = SafeMath.safeAdd(tokensIssued[_for], tokensToMint);            // Log tokens issued\n', '\n', '        token.mint(_for, tokensToMint);                                                     // Mint tokens from Token Mint\n', '        logPurchase(_for, msg.value, tokensToMint);\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Calculates how much of the ETH contributed falls before the base target cap to therefore\n', '            calculate the correct rates of Token to be issued\n', '\n', '    param:      _valueSent  The value of ETH transferred on the payable function\n', '\n', '    returns:    uint256     The value that falls before the base target\n', '            \n', '    ---------------------------------------------------------------------------------------- */\n', '    function getPreTargetContribution(uint256 _valueSent) internal returns (uint256) {\n', '        \n', '        uint256 targetContribution = 0;                                                     // Default return\n', '\n', '        if (totalWeiContributed < baseTargetInWei) {                                             \n', '            if (SafeMath.safeAdd(totalWeiContributed, _valueSent) > baseTargetInWei) {           // Contribution straddles baseTarget\n', '                targetContribution = SafeMath.safeSub(baseTargetInWei, totalWeiContributed);     // IF #1 means always +ve\n', '            } else {\n', '                targetContribution = _valueSent;\n', '            }\n', '        }\n', '        return targetContribution;    \n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    Public viewable functions to show key parameters\n', '\n', '    ---------------------------------------------------------------------------------------- */\n', '\n', '    // Is the ICO Live: time live, state Active\n', '    function ICO_Live() public constant returns (bool) {\n', '        return (now >= startTime && now < endTime && state == State.Active);\n', '    }\n', '\n', "    // Time is valid, purchase isn't zero and cap won't be breached\n", '    function validPurchase(uint256 _value) payable returns (bool) {          // Known true\n', '        bool validTime = (now >= startTime && now < endTime);           // Must be true    \n', '        bool validAmount = (_value >= minWeiContribution);\n', '        bool withinCap = SafeMath.safeAdd(totalWeiContributed, _value) <= icoCapInWei;\n', '\n', '        return validTime && validAmount && withinCap;\n', '    }\n', '\n', '    // ICO has ended\n', '    function ICO_Ended() public constant returns (bool) {\n', '        bool capReached = (totalWeiContributed >= icoCapInWei);\n', '        bool stateValid = state == State.Closed;\n', '\n', '        return (now >= endTime) || capReached || stateValid;\n', '    }\n', '\n', '    // Wei remaining until ICO is capped\n', '    function Wei_Remaining_To_ICO_Cap() public constant returns (uint256) {\n', '        return (icoCapInWei - totalWeiContributed);\n', '    }\n', '\n', '    // Shows if the base target cap has been reached\n', '    function baseTargetReached() public constant returns (bool) {\n', '    \n', '        return totalWeiContributed >= baseTargetInWei;\n', '    }\n', '\n', '    // Shows if the cap has been reached\n', '    function capReached() public constant returns (bool) {\n', '    \n', '        return totalWeiContributed == icoCapInWei;\n', '    }\n', '\n', '    /*  ----------------------------------------------------------------------------------------\n', '\n', '    Dev:    This section controls closing of the ICO. The state is set to closed so that the ICO\n', '            is shown as ended.\n', '\n', '            Based on the function from open zeppelin contracts: RefundVault + RefundableCrowdsale\n', '\n', '    Ref:    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/RefundableCrowdsale.sol\n', '            https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/RefundVault.sol\n', '    ---------------------------------------------------------------------------------------- */\n', '\n', '    event Closed();\n', '\n', '    // Set closed ICO and transfer balance to holding account\n', '    function close() onlyOwner {\n', '        require((now >= endTime) || (totalWeiContributed >= icoCapInWei));\n', '        require(state==State.Active);\n', '        state = State.Closed;\n', '        Closed();\n', '\n', '        holdingAccount.transfer(this.balance);\n', '    }\n', '}']
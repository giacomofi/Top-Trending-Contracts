['pragma solidity ^0.4.15;\n', '/*\n', '    Utilities & Common Modifiers\n', '*/\n', 'contract Utils {\n', '    /**\n', '        constructor\n', '    */\n', '    function Utils() {\n', '    }\n', '\n', '    // validates an address - currently only checks that it isn&#39;t null\n', '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        _;\n', '    }\n', '\n', '    // verifies that the address is different than this contract address\n', '    modifier notThis(address _address) {\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    // Overflow protected math functions\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', '    // these functions aren&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function name() public constant returns (string) { name; }\n', '    function symbol() public constant returns (string) { symbol; }\n', '    function decimals() public constant returns (uint8) { decimals; }\n', '    function totalSupply() public constant returns (uint256) { totalSupply; }\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '\n', '/**\n', '    ERC20 Standard Token implementation\n', '*/\n', 'contract ERC20Token is IERC20Token, Utils {\n', '    string public standard = "Token 0.1";\n', '    string public name = "";\n', '    string public symbol = "";\n', '    uint8 public decimals = 0;\n', '    uint256 public totalSupply = 0;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /**\n', '        @dev constructor\n', '\n', '        @param _name        token name\n', '        @param _symbol      token symbol\n', '        @param _decimals    decimal points, for display purposes\n', '    */\n', '    function ERC20Token(string _name, string _symbol, uint8 _decimals) {\n', '        require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input\n', '\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /**\n', '        @dev send coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, false if it wasn&#39;t\n', '    */\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev an account/contract attempts to get the coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        @param _from    source address\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, false if it wasn&#39;t\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        validAddress(_from)\n', '        validAddress(_to)\n', '        returns (bool success)\n', '    {\n', '        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev allow another account/contract to spend some tokens on your behalf\n', '        throws on any error rather then return a false flag to minimize user errors\n', '\n', '        also, to minimize the risk of the approve/transferFrom attack vector\n', '        (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice\n', '        in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value\n', '\n', '        @param _spender approved address\n', '        @param _value   allowance amount\n', '\n', '        @return true if the approval was successful, false if it wasn&#39;t\n', '    */\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        validAddress(_spender)\n', '        returns (bool success)\n', '    {\n', '        // if the allowance isn&#39;t 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/*\n', '    Owned contract interface\n', '*/\n', 'contract IOwned {\n', '    // this function isn&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function owner() public constant returns (address) { owner; }\n', '\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', '/*\n', '    Provides support and utilities for contract ownership\n', '*/\n', 'contract Owned is IOwned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier ownerOnly {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev allows transferring the contract ownership\n', '        the new owner still needs to accept the transfer\n', '        can only be called by the contract owner\n', '\n', '        @param _newOwner    new contract owner\n', '    */\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', '/*\n', '    Token Holder interface\n', '*/\n', 'contract ITokenHolder is IOwned {\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;\n', '}\n', '\n', '/*\n', '    We consider every contract to be a &#39;token holder&#39; since it&#39;s currently not possible\n', '    for a contract to deny receiving tokens.\n', '\n', '    The TokenHolder&#39;s contract sole purpose is to provide a safety mechanism that allows\n', '    the owner to send tokens that were sent to the contract by mistake back to their sender.\n', '*/\n', 'contract TokenHolder is ITokenHolder, Owned, Utils {\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function TokenHolder() {\n', '    }\n', '\n', '    /**\n', '        @dev withdraws tokens held by the contract and sends them to an account\n', '        can only be called by the owner\n', '\n', '        @param _token   ERC20 token contract address\n', '        @param _to      account to receive the new amount\n', '        @param _amount  amount to withdraw\n', '    */\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_token)\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        assert(_token.transfer(_to, _amount));\n', '    }\n', '}\n', '\n', '\n', 'contract ENJToken is ERC20Token, TokenHolder {\n', '\n', '///////////////////////////////////////// VARIABLE INITIALIZATION /////////////////////////////////////////\n', '\n', '    uint256 constant public ENJ_UNIT = 10 ** 18;\n', '    uint256 public totalSupply = 1 * (10**9) * ENJ_UNIT;\n', '\n', '    //  Constants \n', '    uint256 constant public maxPresaleSupply = 600 * 10**6 * ENJ_UNIT;           // Total presale supply at max bonus\n', '    uint256 constant public minCrowdsaleAllocation = 200 * 10**6 * ENJ_UNIT;     // Min amount for crowdsale\n', '    uint256 constant public incentivisationAllocation = 100 * 10**6 * ENJ_UNIT;  // Incentivisation Allocation\n', '    uint256 constant public advisorsAllocation = 26 * 10**6 * ENJ_UNIT;          // Advisors Allocation\n', '    uint256 constant public enjinTeamAllocation = 74 * 10**6 * ENJ_UNIT;         // Enjin Team allocation\n', '\n', '    address public crowdFundAddress;                                             // Address of the crowdfund\n', '    address public advisorAddress;                                               // Enjin advisor&#39;s address\n', '    address public incentivisationFundAddress;                                   // Address that holds the incentivization funds\n', '    address public enjinTeamAddress;                                             // Enjin Team address\n', '\n', '    //  Variables\n', '\n', '    uint256 public totalAllocatedToAdvisors = 0;                                 // Counter to keep track of advisor token allocation\n', '    uint256 public totalAllocatedToTeam = 0;                                     // Counter to keep track of team token allocation\n', '    uint256 public totalAllocated = 0;                                           // Counter to keep track of overall token allocation\n', '    uint256 constant public endTime = 1509494340;                                // 10/31/2017 @ 11:59pm (UTC) crowdsale end time (in seconds)\n', '\n', '    bool internal isReleasedToPublic = false;                         // Flag to allow transfer/transferFrom before the end of the crowdfund\n', '\n', '    uint256 internal teamTranchesReleased = 0;                          // Track how many tranches (allocations of 12.5% team tokens) have been released\n', '    uint256 internal maxTeamTranches = 8;                               // The number of tranches allowed to the team until depleted\n', '\n', '///////////////////////////////////////// MODIFIERS /////////////////////////////////////////\n', '\n', '    // Enjin Team timelock    \n', '    modifier safeTimelock() {\n', '        require(now >= endTime + 6 * 4 weeks);\n', '        _;\n', '    }\n', '\n', '    // Advisor Team timelock    \n', '    modifier advisorTimelock() {\n', '        require(now >= endTime + 2 * 4 weeks);\n', '        _;\n', '    }\n', '\n', '    // Function only accessible by the Crowdfund contract\n', '    modifier crowdfundOnly() {\n', '        require(msg.sender == crowdFundAddress);\n', '        _;\n', '    }\n', '\n', '    ///////////////////////////////////////// CONSTRUCTOR /////////////////////////////////////////\n', '\n', '    /**\n', '        @dev constructor\n', '        @param _crowdFundAddress   Crowdfund address\n', '        @param _advisorAddress     Advisor address\n', '    */\n', '    function ENJToken(address _crowdFundAddress, address _advisorAddress, address _incentivisationFundAddress, address _enjinTeamAddress)\n', '    ERC20Token("Enjin Coin", "ENJ", 18)\n', '     {\n', '        crowdFundAddress = _crowdFundAddress;\n', '        advisorAddress = _advisorAddress;\n', '        enjinTeamAddress = _enjinTeamAddress;\n', '        incentivisationFundAddress = _incentivisationFundAddress;\n', '        balanceOf[_crowdFundAddress] = minCrowdsaleAllocation + maxPresaleSupply; // Total presale + crowdfund tokens\n', '        balanceOf[_incentivisationFundAddress] = incentivisationAllocation;       // 10% Allocated for Marketing and Incentivisation\n', '        totalAllocated += incentivisationAllocation;                              // Add to total Allocated funds\n', '    }\n', '\n', '///////////////////////////////////////// ERC20 OVERRIDE /////////////////////////////////////////\n', '\n', '    /**\n', '        @dev send coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '        in addition to the standard checks, the function throws if transfers are disabled\n', '\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, throws if it wasn&#39;t\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        if (isTransferAllowed() == true || msg.sender == crowdFundAddress || msg.sender == incentivisationFundAddress) {\n', '            assert(super.transfer(_to, _value));\n', '            return true;\n', '        }\n', '        revert();        \n', '    }\n', '\n', '    /**\n', '        @dev an account/contract attempts to get the coins\n', '        throws on any error rather then return a false flag to minimize user errors\n', '        in addition to the standard checks, the function throws if transfers are disabled\n', '\n', '        @param _from    source address\n', '        @param _to      target address\n', '        @param _value   transfer amount\n', '\n', '        @return true if the transfer was successful, throws if it wasn&#39;t\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (isTransferAllowed() == true || msg.sender == crowdFundAddress || msg.sender == incentivisationFundAddress) {        \n', '            assert(super.transferFrom(_from, _to, _value));\n', '            return true;\n', '        }\n', '        revert();\n', '    }\n', '\n', '///////////////////////////////////////// ALLOCATION FUNCTIONS /////////////////////////////////////////\n', '\n', '    /**\n', '        @dev Release one single tranche of the Enjin Team Token allocation\n', '        throws if before timelock (6 months) ends and if not initiated by the owner of the contract\n', '        returns true if valid\n', '        Schedule goes as follows:\n', '        3 months: 12.5% (this tranche can only be released after the initial 6 months has passed)\n', '        6 months: 12.5%\n', '        9 months: 12.5%\n', '        12 months: 12.5%\n', '        15 months: 12.5%\n', '        18 months: 12.5%\n', '        21 months: 12.5%\n', '        24 months: 12.5%\n', '        @return true if successful, throws if not\n', '    */\n', '    function releaseEnjinTeamTokens() safeTimelock ownerOnly returns(bool success) {\n', '        require(totalAllocatedToTeam < enjinTeamAllocation);\n', '\n', '        uint256 enjinTeamAlloc = enjinTeamAllocation / 1000;\n', '        uint256 currentTranche = uint256(now - endTime) / 12 weeks;     // "months" after crowdsale end time (division floored)\n', '\n', '        if(teamTranchesReleased < maxTeamTranches && currentTranche > teamTranchesReleased) {\n', '            teamTranchesReleased++;\n', '\n', '            uint256 amount = safeMul(enjinTeamAlloc, 125);\n', '            balanceOf[enjinTeamAddress] = safeAdd(balanceOf[enjinTeamAddress], amount);\n', '            Transfer(0x0, enjinTeamAddress, amount);\n', '            totalAllocated = safeAdd(totalAllocated, amount);\n', '            totalAllocatedToTeam = safeAdd(totalAllocatedToTeam, amount);\n', '            return true;\n', '        }\n', '        revert();\n', '    }\n', '\n', '    /**\n', '        @dev release Advisors Token allocation\n', '        throws if before timelock (2 months) ends or if no initiated by the advisors address\n', '        or if there is no more allocation to give out\n', '        returns true if valid\n', '\n', '        @return true if successful, throws if not\n', '    */\n', '    function releaseAdvisorTokens() advisorTimelock ownerOnly returns(bool success) {\n', '        require(totalAllocatedToAdvisors == 0);\n', '        balanceOf[advisorAddress] = safeAdd(balanceOf[advisorAddress], advisorsAllocation);\n', '        totalAllocated = safeAdd(totalAllocated, advisorsAllocation);\n', '        totalAllocatedToAdvisors = advisorsAllocation;\n', '        Transfer(0x0, advisorAddress, advisorsAllocation);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev Retrieve unsold tokens from the crowdfund\n', '        throws if before timelock (6 months from end of Crowdfund) ends and if no initiated by the owner of the contract\n', '        returns true if valid\n', '\n', '        @return true if successful, throws if not\n', '    */\n', '    function retrieveUnsoldTokens() safeTimelock ownerOnly returns(bool success) {\n', '        uint256 amountOfTokens = balanceOf[crowdFundAddress];\n', '        balanceOf[crowdFundAddress] = 0;\n', '        balanceOf[incentivisationFundAddress] = safeAdd(balanceOf[incentivisationFundAddress], amountOfTokens);\n', '        totalAllocated = safeAdd(totalAllocated, amountOfTokens);\n', '        Transfer(crowdFundAddress, incentivisationFundAddress, amountOfTokens);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev Keep track of token allocations\n', '        can only be called by the crowdfund contract\n', '    */\n', '    function addToAllocation(uint256 _amount) crowdfundOnly {\n', '        totalAllocated = safeAdd(totalAllocated, _amount);\n', '    }\n', '\n', '    /**\n', '        @dev Function to allow transfers\n', '        can only be called by the owner of the contract\n', '        Transfers will be allowed regardless after the crowdfund end time.\n', '    */\n', '    function allowTransfers() ownerOnly {\n', '        isReleasedToPublic = true;\n', '    } \n', '\n', '    /**\n', '        @dev User transfers are allowed/rejected\n', '        Transfers are forbidden before the end of the crowdfund\n', '    */\n', '    function isTransferAllowed() internal constant returns(bool) {\n', '        if (now > endTime || isReleasedToPublic == true) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '}']
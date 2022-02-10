['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', '\n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public view returns (uint);\n', '  \n', '  function name() public view returns (string _name);\n', '  function symbol() public view returns (string _symbol);\n', '  function decimals() public view returns (uint8 _decimals);\n', '  function totalSupply() public view returns (uint256 _supply);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ContractReceiver {\n', '     \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    \n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '      \n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC223 {\n', '    using SafeMath for uint;\n', '\n', '    //user token balances\n', '    mapping (address => uint) balances;\n', '    //token transer permissions\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        if(isContract(_to)) {\n', '            if (balanceOf(msg.sender) < _value) revert();\n', '            balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '            balances[_to] = balanceOf(_to).add(_value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value);\n', '        }\n', '    }\n', '    \n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '          \n', '        if(isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value);\n', '        }\n', '    }\n', '      \n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '          \n', '        //standard function transfer similar to ERC20 transfer with no _data\n', '        //added due to backwards compatibility reasons\n', '        bytes memory empty;\n', '        if(isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value);\n', '        }\n', '    }\n', '\n', '    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    //function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '      \n', '      //function that is called when transaction target is a contract\n', '      function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Token transfer from from to _to (permission needed)\n', '     */\n', '    function transferFrom(\n', '        address _from, \n', '        address _to,\n', '        uint _value\n', '    ) \n', '        public \n', '        returns (bool)\n', '    {\n', '        if (balanceOf(_from) < _value && allowance(_from, msg.sender) < _value) revert();\n', '\n', '        bytes memory empty;\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        balances[_from] = balanceOf(_from).sub(_value);\n', '        allowed[_from][msg.sender] = allowance(_from, msg.sender).sub(_value);\n', '        if (isContract(_to)) {\n', '            ContractReceiver receiver = ContractReceiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Increase permission for transfer\n', '     */\n', '    function increaseApproval(\n', '        address spender,\n', '        uint value\n', '    )\n', '        public\n', '        returns (bool) \n', '    {\n', '        allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Decrease permission for transfer\n', '     */\n', '    function decreaseApproval(\n', '        address spender,\n', '        uint value\n', '    )\n', '        public\n', '        returns (bool) \n', '    {\n', '        allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * User token balance\n', '     */\n', '    function balanceOf(\n', '        address owner\n', '    ) \n', '        public \n', '        constant \n', '        returns (uint) \n', '    {\n', '        return balances[owner];\n', '    }\n', '\n', '    /**\n', '     * User transfer permission\n', '     */\n', '    function allowance(\n', '        address owner, \n', '        address spender\n', '    )\n', '        public\n', '        constant\n', '        returns (uint remaining)\n', '    {\n', '        return allowed[owner][spender];\n', '    }\n', '}\n', '\n', 'contract MyDFSToken is StandardToken {\n', '\n', '    string public name = "MyDFS Token";\n', '    uint8 public decimals = 6;\n', '    string public symbol = "MyDFS";\n', '    string public version = &#39;H1.0&#39;;\n', '    uint256 public totalSupply;\n', '\n', '    function () external {\n', '        revert();\n', '    } \n', '\n', '    function MyDFSToken() public {\n', '        totalSupply = 125 * 1e12;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    // Function to access name of token .\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '    // Function to access symbol of token .\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    // Function to access decimals of token .\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwnerCandidate;\n', '\n', '    event OwnershipRequested(address indexed _by, address indexed _to);\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() { require(msg.sender == owner); _;}\n', '\n', '    /// Proposes to transfer control of the contract to a newOwnerCandidate.\n', '    /// @param _newOwnerCandidate address The address to transfer ownership to.\n', '    function transferOwnership(address _newOwnerCandidate) external onlyOwner {\n', '        require(_newOwnerCandidate != address(0));\n', '\n', '        newOwnerCandidate = _newOwnerCandidate;\n', '\n', '        OwnershipRequested(msg.sender, newOwnerCandidate);\n', '    }\n', '\n', '    /// Accept ownership transfer. This method needs to be called by the perviously proposed owner.\n', '    function acceptOwnership() external {\n', '        if (msg.sender == newOwnerCandidate) {\n', '            owner = newOwnerCandidate;\n', '            newOwnerCandidate = address(0);\n', '\n', '            OwnershipTransferred(owner, newOwnerCandidate);\n', '        }\n', '    }\n', '}\n', '\n', 'contract DevTokensHolder is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 collectedTokens;\n', '    GenericCrowdsale crowdsale;\n', '    MyDFSToken token;\n', '\n', '    event ClaimedTokens(address token, uint256 amount);\n', '    event TokensWithdrawn(address holder, uint256 amount);\n', '    event Debug(uint256 amount);\n', '\n', '    function DevTokensHolder(address _crowdsale, address _token, address _owner) public {\n', '        crowdsale = GenericCrowdsale(_crowdsale);\n', '        token = MyDFSToken(_token);\n', '        owner = _owner;\n', '    }\n', '\n', '    function tokenFallback(\n', '        address _from, \n', '        uint _value, \n', '        bytes _data\n', '    ) \n', '        public \n', '        view \n', '    {\n', '        require(_from == owner || _from == address(crowdsale));\n', '        require(_value > 0 || _data.length > 0);\n', '    }\n', '\n', '    /// @notice The Dev (Owner) will call this method to extract the tokens\n', '    function collectTokens() public onlyOwner {\n', '        uint256 balance = token.balanceOf(address(this));\n', '        uint256 total = collectedTokens.add(balance);\n', '\n', '        uint256 finalizedTime = crowdsale.finishTime();\n', '        require(finalizedTime > 0 && getTime() > finalizedTime.add(14 days));\n', '\n', '        uint256 canExtract = total.mul(getTime().sub(finalizedTime)).div(months(12));\n', '        canExtract = canExtract.sub(collectedTokens);\n', '\n', '        if (canExtract > balance) {\n', '            canExtract = balance;\n', '        }\n', '\n', '        collectedTokens = collectedTokens.add(canExtract);\n', '        require(token.transfer(owner, canExtract));\n', '        TokensWithdrawn(owner, canExtract);\n', '    }\n', '\n', '    function months(uint256 m) internal pure returns (uint256) {\n', '        return m.mul(30 days);\n', '    }\n', '\n', '    function getTime() internal view returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '    //////////\n', '    // Safety Methods\n', '    //////////\n', '\n', '    /// @notice This method can be used by the controller to extract mistakenly\n', '    ///  sent tokens to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    ///  set to 0 in case you want to extract ether.\n', '    function claimTokens(address _token) public onlyOwner {\n', '        require(_token != address(token));\n', '        if (_token == 0x0) {\n', '            owner.transfer(this.balance);\n', '            return;\n', '        }\n', '\n', '        token = MyDFSToken(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '        ClaimedTokens(_token, balance);\n', '    }\n', '}\n', '\n', 'contract AdvisorsTokensHolder is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    GenericCrowdsale crowdsale;\n', '    MyDFSToken token;\n', '\n', '    event ClaimedTokens(address token, uint256 amount);\n', '    event TokensWithdrawn(address holder, uint256 amount);\n', '\n', '    function AdvisorsTokensHolder(address _crowdsale, address _token, address _owner) public {\n', '        crowdsale = GenericCrowdsale(_crowdsale);\n', '        token = MyDFSToken(_token);\n', '        owner = _owner;\n', '    }\n', '\n', '    function tokenFallback(\n', '        address _from, \n', '        uint _value, \n', '        bytes _data\n', '    ) \n', '        public \n', '        view \n', '    {\n', '        require(_from == owner || _from == address(crowdsale));\n', '        require(_value > 0 || _data.length > 0);\n', '    }\n', '\n', '    /// @notice The Dev (Owner) will call this method to extract the tokens\n', '    function collectTokens() public onlyOwner {\n', '        uint256 balance = token.balanceOf(address(this));\n', '        require(balance > 0);\n', '\n', '        uint256 finalizedTime = crowdsale.finishTime();\n', '        require(finalizedTime > 0 && getTime() > finalizedTime.add(14 days));\n', '\n', '        require(token.transfer(owner, balance));\n', '        TokensWithdrawn(owner, balance);\n', '    }\n', '\n', '    function getTime() internal view returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '    //////////\n', '    // Safety Methods\n', '    //////////\n', '\n', '    /// @notice This method can be used by the controller to extract mistakenly\n', '    ///  sent tokens to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    ///  set to 0 in case you want to extract ether.\n', '    function claimTokens(address _token) public onlyOwner {\n', '        require(_token != address(token));\n', '        if (_token == 0x0) {\n', '            owner.transfer(this.balance);\n', '            return;\n', '        }\n', '\n', '        token = MyDFSToken(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '        ClaimedTokens(_token, balance);\n', '    }\n', '}\n', '\n', 'contract GenericCrowdsale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    //Crowrdsale states\n', '    enum State { Initialized, PreIco, PreIcoFinished, Ico, IcoFinished}\n', '\n', '    struct Discount {\n', '        uint256 amount;\n', '        uint256 value;\n', '    }\n', '\n', '    //ether trasfered to\n', '    address public beneficiary;\n', '    //Crowrdsale state\n', '    State public state;\n', '    //Hard goal in Wei\n', '    uint public hardFundingGoal;\n', '    //soft goal in Wei\n', '    uint public softFundingGoal;\n', '    //gathered Ether amount in Wei\n', '    uint public amountRaised;\n', '    //ICO/PreICO start timestamp in seconds\n', '    uint public started;\n', '    //Crowdsale finish time\n', '    uint public finishTime;\n', '    //price for 1 token in Wei\n', '    uint public price;\n', '    //minimum purchase value in Wei\n', '    uint public minPurchase;\n', '    //Token cantract\n', '    ERC223 public tokenReward;\n', '    //Wei balances for refund if ICO failed\n', '    mapping(address => uint256) public balances;\n', '\n', '    //Emergency stop sell\n', '    bool emergencyPaused = false;\n', '    //Soft cap reached\n', '    bool softCapReached = false;\n', '    //dev holder\n', '    DevTokensHolder public devTokensHolder;\n', '    //advisors holder\n', '    AdvisorsTokensHolder public advisorsTokensHolder;\n', '    \n', '    //Disconts\n', '    Discount[] public discounts;\n', '\n', '    //price overhead for next stages\n', '    uint8[2] public preIcoTokenPrice = [70,75];\n', '    //price overhead for next stages\n', '    uint8[4] public icoTokenPrice = [100,120,125,130];\n', '\n', '    event TokenPurchased(address investor, uint sum, uint tokensCount, uint discountTokens);\n', '    event PreIcoLimitReached(uint totalAmountRaised);\n', '    event SoftGoalReached(uint totalAmountRaised);\n', '    event HardGoalReached(uint totalAmountRaised);\n', '    event Debug(uint num);\n', '\n', '    //Sale is active\n', '    modifier sellActive() { \n', '        require(\n', '            !emergencyPaused \n', '            && (state == State.PreIco || state == State.Ico)\n', '            && amountRaised < hardFundingGoal\n', '        );\n', '    _; }\n', '    //Soft cap not reached\n', '    modifier goalNotReached() { require(state == State.IcoFinished && amountRaised < softFundingGoal); _; }\n', '\n', '    /**\n', '     * Constrctor function\n', '     */\n', '    function GenericCrowdsale(\n', '        address ifSuccessfulSendTo,\n', '        address addressOfTokenUsedAsReward\n', '    ) public {\n', '        require(ifSuccessfulSendTo != address(0) \n', '            && addressOfTokenUsedAsReward != address(0));\n', '        beneficiary = ifSuccessfulSendTo;\n', '        tokenReward = ERC223(addressOfTokenUsedAsReward);\n', '        state = State.Initialized;\n', '    }\n', '\n', '    function tokenFallback(\n', '        address _from, \n', '        uint _value, \n', '        bytes _data\n', '    ) \n', '        public \n', '        view \n', '    {\n', '        require(_from == owner);\n', '        require(_value > 0 || _data.length > 0);\n', '    }\n', '\n', '    /**\n', '     * Start PreICO\n', '     */\n', '    function preIco(\n', '        uint hardFundingGoalInEthers,\n', '        uint minPurchaseInFinney,\n', '        uint costOfEachToken,\n', '        uint256[] discountEthers,\n', '        uint256[] discountValues\n', '    ) \n', '        external \n', '        onlyOwner \n', '    {\n', '        require(hardFundingGoalInEthers > 0\n', '            && costOfEachToken > 0\n', '            && state == State.Initialized\n', '            && discountEthers.length == discountValues.length);\n', '\n', '        hardFundingGoal = hardFundingGoalInEthers.mul(1 ether);\n', '        minPurchase = minPurchaseInFinney.mul(1 finney);\n', '        price = costOfEachToken;\n', '        initDiscounts(discountEthers, discountValues);\n', '        state = State.PreIco;\n', '        started = now;\n', '    }\n', '\n', '    /**\n', '     * Start ICO\n', '     */\n', '    function ico(\n', '        uint softFundingGoalInEthers,\n', '        uint hardFundingGoalInEthers,\n', '        uint minPurchaseInFinney,\n', '        uint costOfEachToken,\n', '        uint256[] discountEthers,\n', '        uint256[] discountValues\n', '    ) \n', '        external\n', '        onlyOwner\n', '    {\n', '        require(softFundingGoalInEthers > 0\n', '            && hardFundingGoalInEthers > 0\n', '            && hardFundingGoalInEthers > softFundingGoalInEthers\n', '            && costOfEachToken > 0\n', '            && state < State.Ico\n', '            && discountEthers.length == discountValues.length);\n', '\n', '        softFundingGoal = softFundingGoalInEthers.mul(1 ether);\n', '        hardFundingGoal = hardFundingGoalInEthers.mul(1 ether);\n', '        minPurchase = minPurchaseInFinney.mul(1 finney);\n', '        price = costOfEachToken;\n', '        delete discounts;\n', '        initDiscounts(discountEthers, discountValues);\n', '        state = State.Ico;\n', '        started = now;\n', '    }\n', '\n', '    /**\n', '     * Finish ICO / PreICO\n', '     */\n', '    function finishSale() external onlyOwner {\n', '        require(state == State.PreIco || state == State.Ico);\n', '        \n', '        if (state == State.PreIco)\n', '            state = State.PreIcoFinished;\n', '        else\n', '            state = State.IcoFinished;\n', '    }\n', '\n', '    /**\n', '     * Admin can pause token sell\n', '     */\n', '    function emergencyPause() external onlyOwner {\n', '        emergencyPaused = true;\n', '    }\n', '\n', '    /**\n', '     * Admin can unpause token sell\n', '     */\n', '    function emergencyUnpause() external onlyOwner {\n', '        emergencyPaused = false;\n', '    }\n', '\n', '    /**\n', '     * Transfer dev tokens to vesting wallet\n', '     */\n', '    function sendDevTokens() external onlyOwner returns(address) {\n', '        require(successed());\n', '\n', '        devTokensHolder = new DevTokensHolder(address(this), address(tokenReward), owner);\n', '        tokenReward.transfer(address(devTokensHolder), 12500 * 1e9);\n', '        return address(devTokensHolder);\n', '    }\n', '\n', '    /**\n', '     * Transfer dev tokens to vesting wallet\n', '     */\n', '    function sendAdvisorsTokens() external onlyOwner returns(address) {\n', '        require(successed());\n', '\n', '        advisorsTokensHolder = new AdvisorsTokensHolder(address(this), address(tokenReward), owner);\n', '        tokenReward.transfer(address(advisorsTokensHolder), 12500 * 1e9);\n', '        return address(advisorsTokensHolder);\n', '    }\n', '\n', '    /**\n', '     * Admin can withdraw ether beneficiary address\n', '     */\n', '    function withdrawFunding() external onlyOwner {\n', '        require((state == State.PreIco || successed()));\n', '        beneficiary.transfer(this.balance);\n', '    }\n', '\n', '    /**\n', '     * Different coins purchase\n', '     */\n', '    function foreignPurchase(address user, uint256 amount)\n', '        external\n', '        onlyOwner\n', '        sellActive\n', '    {\n', '        buyTokens(user, amount);\n', '        checkGoals();\n', '    }\n', '\n', '    /**\n', '     * Claim refund ether in soft goal not reached \n', '     */\n', '    function claimRefund() \n', '        external \n', '        goalNotReached \n', '    {\n', '        uint256 amount = balances[msg.sender];\n', '        balances[msg.sender] = 0;\n', '        if (amount > 0){\n', '            if (!msg.sender.send(amount)) {\n', '                balances[msg.sender] = amount;\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Payment transaction\n', '     */\n', '    function () \n', '        external \n', '        payable \n', '        sellActive\n', '    {\n', '        require(msg.value > 0);\n', '        require(msg.value >= minPurchase);\n', '        uint amount = msg.value;\n', '        if (amount > hardFundingGoal.sub(amountRaised)) {\n', '            uint availableAmount = hardFundingGoal.sub(amountRaised);\n', '            msg.sender.transfer(amount.sub(availableAmount));\n', '            amount = availableAmount;\n', '        }\n', '\n', '        buyTokens(msg.sender,  amount);\n', '        checkGoals();\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens to user\n', '     */\n', '    function buyTokens(\n', '        address user,\n', '        uint256 amount\n', '    ) internal {\n', '        require(amount <= hardFundingGoal.sub(amountRaised));\n', '\n', '        uint256 passedSeconds = getTime().sub(started);\n', '        uint256 week = 0;\n', '        if (passedSeconds >= 604800){\n', '            week = passedSeconds.div(604800);\n', '        }\n', '        Debug(week);\n', '\n', '        uint256 tokenPrice;\n', '        if (state == State.Ico){\n', '            uint256 cup = amountRaised.mul(4).div(hardFundingGoal);\n', '            if (cup > week)\n', '                week = cup;\n', '            if (week >= 4)\n', '                 week = 3;\n', '            tokenPrice = price.mul(icoTokenPrice[week]).div(100);\n', '        } else {\n', '            if (week >= 2)\n', '                 week = 1;\n', '            tokenPrice = price.mul(preIcoTokenPrice[week]).div(100);\n', '        }\n', '\n', '        Debug(tokenPrice);\n', '\n', '        uint256 count = amount.div(tokenPrice);\n', '        uint256 discount = getDiscountOf(amount);\n', '        uint256 discountBonus = discount.mul(count).div(100);\n', '        count = count.add(discountBonus);\n', '        count = ceilTokens(count);\n', '\n', '        require(tokenReward.transfer(user, count));\n', '        balances[user] = balances[user].add(amount);\n', '        amountRaised = amountRaised.add(amount);\n', '        TokenPurchased(user, amount, count, discountBonus);\n', '    }\n', '\n', '    /**\n', '     * Define distount percents for different token amounts\n', '     */\n', '    function ceilTokens(\n', '        uint256 num\n', '    ) \n', '        public\n', '        pure\n', '        returns(uint256) \n', '    {\n', '        uint256 part = num % 1000000;\n', '        return part > 0 ? num.div(1000000).mul(1000000) + 1000000 : num;\n', '    }\n', '\n', '    /**\n', '     * ICO is finished successfully\n', '     */\n', '    function successed() \n', '        public \n', '        view \n', '        returns(bool) \n', '    {\n', '        return state == State.IcoFinished && amountRaised >= softFundingGoal;\n', '    }\n', '\n', '    /**\n', '     * Define distount percents for different token amounts\n', '     */\n', '    function initDiscounts(\n', '        uint256[] discountEthers,\n', '        uint256[] discountValues\n', '    ) internal {\n', '        for (uint256 i = 0; i < discountEthers.length; i++) {\n', '            discounts.push(Discount(discountEthers[i].mul(1 ether), discountValues[i]));\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Get discount percent for number of tokens\n', '     */\n', '    function getDiscountOf(\n', '        uint256 _amount\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        if (discounts.length > 0)\n', '            for (uint256 i = 0; i < discounts.length; i++) {\n', '                if (_amount >= discounts[i].amount) {\n', '                    return discounts[i].value;\n', '                }\n', '            }\n', '        return 0;\n', '    }\n', '\n', '    /**\n', '     * Check ICO goals achievement\n', '     */\n', '    function checkGoals() internal {\n', '        if (state == State.PreIco) {\n', '            if (amountRaised >= hardFundingGoal) {\n', '                PreIcoLimitReached(amountRaised);\n', '                state = State.PreIcoFinished;\n', '            }\n', '        } else {\n', '            if (!softCapReached && amountRaised >= softFundingGoal){\n', '                softCapReached = true;\n', '                SoftGoalReached(amountRaised);\n', '            }\n', '            if (amountRaised >= hardFundingGoal) {\n', '                finishTime = now;\n', '                HardGoalReached(amountRaised);\n', '                state = State.IcoFinished;\n', '            }\n', '        }\n', '    }\n', '\n', '    function getTime() internal view returns (uint) {\n', '        return now;\n', '    }\n', '}']
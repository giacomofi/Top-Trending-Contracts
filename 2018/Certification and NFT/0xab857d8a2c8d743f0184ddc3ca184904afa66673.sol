['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath for performing valid mathematics.\n', ' */\n', 'library SafeMath {\n', ' \n', '  function Mul(uint a, uint b) internal pure returns (uint) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function Div(uint a, uint b) internal pure returns (uint) {\n', '    //assert(b > 0); // Solidity automatically throws when Dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function Sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  } \n', '\n', '  function Add(uint a, uint b) internal pure returns (uint) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  } \n', '}\n', '\n', '/**\n', '* @title Contract that will work with ERC223 tokens.\n', '*/\n', 'contract ERC223ReceivingContract { \n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '/**\n', ' * Contract "Ownable"\n', ' * Purpose: Defines Owner for contract and provide functionality to transfer ownership to another account\n', ' */\n', 'contract Ownable {\n', '\n', '  //owner variable to store contract owner account\n', '  address public owner;\n', '  //add another owner to transfer ownership\n', '  address oldOwner;\n', '\n', "  //Constructor for the contract to store owner's account on deployement\n", '  function Ownable() public {\n', '    owner = msg.sender;\n', '    oldOwner = msg.sender;\n', '  }\n', '\n', '  //modifier to check transaction initiator is only owner\n', '  modifier onlyOwner() {\n', '    require (msg.sender == owner || msg.sender == oldOwner);\n', '      _;\n', '  }\n', '\n', "  //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner's account\n", '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require (newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', 'contract ERC20 is Ownable {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) public view returns (uint256 value);\n', '    function transfer(address _to, uint256 _value) public returns (bool _success);\n', '    function allowance(address owner, address spender) public view returns (uint256 _value);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool _success);\n', '    function approve(address spender, uint256 value) public returns (bool _success);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '}\n', '\n', 'contract CTV is ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '    //The name of the  token\n', '    string public constant name = "Coin TV";\n', '    //The token symbol\n', '    string public constant symbol = "CTV";\n', '    //To denote the locking on transfer of tokens among token holders\n', '    bool public locked;\n', '    //The precision used in the calculations in contract\n', '    uint8 public constant decimals = 18;\n', '    //maximum number of tokens\n', '    uint256 constant MAXCAP = 29999990e18;\n', '    // maximum number of tokens that can be supplied by referrals\n', '    uint public constant MAX_REFERRAL_TOKENS = 2999999e18;\n', '    //set the softcap of ether received\n', '    uint256 constant SOFTCAP = 70 ether;\n', '    //Refund eligible or not\n', '    // 0: sale not started yet, refunding invalid\n', '    // 1: refund not required\n', '    // 2: softcap not reached, refund required\n', '    // 3: Refund in progress\n', '    // 4: Everyone refunded\n', '    uint256 public refundStatus = 0;\n', '    //the account which will receive all balance\n', '    address public ethCollector;\n', '    //to save total number of ethers received\n', '    uint256 public totalWeiReceived;\n', '    //count tokens earned by referrals\n', '    uint256 public tokensSuppliedFromReferral = 0;\n', '\n', '    //Mapping to relate owner and spender to the tokens allowed to transfer from owner\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    //to manage referrals\n', '    mapping(address => address) public referredBy;\n', '    //Mapping to relate number of  token to the account\n', '    mapping(address => uint256) balances;\n', '\n', '    //Structure for investors; holds received wei amount and Token sent\n', '    struct Investor {\n', '        //wei received during PreSale\n', '        uint weiReceived;\n', '        //Tokens sent during CrowdSale\n', '        uint tokensPurchased;\n', '        //user has been refunded or not\n', '        bool refunded;\n', '        //Uniquely identify an investor(used for iterating)\n', '        uint investorID;\n', '    }\n', '\n', '    //time when the sale starts\n', '    uint256 public startTime;\n', '    //time when the presale ends\n', '    uint256 public endTime;\n', '    //to check the sale status\n', '    bool public saleRunning;\n', '    //investors indexed by their ETH address\n', '    mapping(address => Investor) public investors;\n', '    //investors indexed by their IDs\n', '    mapping (uint256 => address) public investorList;\n', '    //count number of investors\n', '    uint256 public countTotalInvestors;\n', '    //to keep track of how many investors have been refunded\n', '    uint256 countInvestorsRefunded;\n', '\n', '    //events\n', '    event StateChanged(bool);\n', '\n', '    function CTV() public{\n', '        totalSupply = 0;\n', '        startTime = 0;\n', '        endTime = 0;\n', '        saleRunning = false;\n', '        locked = true;\n', '        setEthCollector(0xAf3BBf663769De9eEb6C2b235262Cf704eD4EA4b);\n', '        mintAlreadyBoughtTokens(0x19566f85835e52e78edcfba440aea5e28783050b,66650000000000000000);\n', '        mintAlreadyBoughtTokens(0xcb969c937e724f1d36ea2fb576148d8286399806,666500000000000000000);\n', '        mintAlreadyBoughtTokens(0x43feda65c918642faf6186c8575fdbb582f4ecd5,2932600000000000000000);\n', '        mintAlreadyBoughtTokens(0x0c94e8579ab97dc2dd805bed3fa72af9cbe8e37c,1466300000000000000000);\n', '        mintAlreadyBoughtTokens(0xaddc8429aa246fedc40005ae4c7f340d94cbb05b,733150000000000000000);\n', '        \n', '        mintAlreadyBoughtTokens(0x99ea6d3bd3f4dd4447d0083d906d64cbeadba33a,733150000000000000000);\n', '        mintAlreadyBoughtTokens(0x99f9493b162ac63d2c61514739a701731ac72398,3665750000000000000000);\n', '        mintAlreadyBoughtTokens(0xa7e919d4d655d86382f76eb5e8151e99ecb4a0da,3470694090746885970870);\n', '        mintAlreadyBoughtTokens(0x1aa18bf38d97a1a68a0119d2287041909b4e6680,1626260000000000000000);\n', '        mintAlreadyBoughtTokens(0x90702a5432f97d01770365d52c312f96dc108e90,1466300000000000000000);\n', '        \n', '        mintAlreadyBoughtTokens(0x562ebcdfe25cfb1985f94836cdc23d3a1d32d8b5,733150000000000000000);\n', '        mintAlreadyBoughtTokens(0x437b405657f4ec00a34ce8b212e52b8a78a14b31,2932600000000000000000);\n', '        mintAlreadyBoughtTokens(0x23c36686b733acdd5266e429b5b132d3da607394,733150000000000000000);\n', '        mintAlreadyBoughtTokens(0xaf933e90e7cf328edeece1f043faed2c5856745e,733150000000000000000);\n', '        mintAlreadyBoughtTokens(0x1d3c7bb8a95ad08740fe2726dd183aa85ffc42f8,1466300000000000000000);\n', '        \n', '        mintAlreadyBoughtTokens(0xd01362b2d59276f8d5d353d180a8f30e2282a23e,733150000000000000);\n', '    }\n', '    //To handle ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    modifier onlyUnlocked() { \n', '        require (!locked); \n', '        _; \n', '    }\n', '\n', '    modifier validTimeframe(){\n', '        require(saleRunning && now >=startTime && now < endTime);\n', '        _;\n', '    }\n', '    \n', '    function setEthCollector(address _ethCollector) public onlyOwner{\n', '        require(_ethCollector != address(0));\n', '        ethCollector = _ethCollector;\n', '    }\n', '    \n', '    function startSale() public onlyOwner{\n', '        require(startTime == 0);\n', '        startTime = now;\n', '        endTime = startTime.Add(7 weeks);\n', '        saleRunning = true;\n', '    }\n', '\n', '    //To enable transfer of tokens\n', '    function unlockTransfer() external onlyOwner{\n', '        locked = false;\n', '    }\n', '\n', '    /**\n', '    * @dev Check if the address being passed belongs to a contract\n', '    *\n', '    * @param _address The address which you want to verify\n', '    * @return A bool specifying if the address is that of contract or not\n', '    */\n', '    function isContract(address _address) private view returns(bool _isContract){\n', '        assert(_address != address(0) );\n', '        uint length;\n', '        //inline assembly code to check the length of address\n', '        assembly{\n', '            length := extcodesize(_address)\n', '        }\n', '        if(length > 0){\n', '            return true;\n', '        }\n', '        else{\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Check balance of given account address\n', '    *\n', '    * @param _owner The address account whose balance you want to know\n', '    * @return balance of the account\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 _value){\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', "    * @dev Transfer sender's token to a given address\n", '    *\n', '    * @param _to The address which you want to transfer to\n', '    * @param _value the amount of tokens to be transferred\n', '    * @return A bool if the transfer was a success or not\n', '    */\n', '    function transfer(address _to, uint _value) onlyUnlocked onlyPayloadSize(2 * 32) public returns(bool _success) {\n', '        require( _to != address(0) );\n', '        bytes memory _empty;\n', '        if((balances[msg.sender] > _value) && _value > 0 && _to != address(0)){\n', '            balances[msg.sender] = balances[msg.sender].Sub(_value);\n', '            balances[_to] = balances[_to].Add(_value);\n', '            if(isContract(_to)){\n', '                ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '                receiver.tokenFallback(msg.sender, _value, _empty);\n', '            }\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else{\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens to an address given by sender. To make ERC223 compliant\n', '    *\n', '    * @param _to The address which you want to transfer to\n', '    * @param _value the amount of tokens to be transferred\n', '    * @param _data additional information of account from where to transfer from\n', '    * @return A bool if the transfer was a success or not\n', '    */\n', '    function transfer(address _to, uint _value, bytes _data) onlyUnlocked onlyPayloadSize(3 * 32) public returns(bool _success) {\n', '        if((balances[msg.sender] > _value) && _value > 0 && _to != address(0)){\n', '            balances[msg.sender] = balances[msg.sender].Sub(_value);\n', '            balances[_to] = balances[_to].Add(_value);\n', '            if(isContract(_to)){\n', '                ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '                receiver.tokenFallback(msg.sender, _value, _data);\n', '            }\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else{\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another, for ERC20.\n', '    *\n', '    * @param _from The address which you want to send tokens from\n', '    * @param _to The address which you want to transfer to\n', '    * @param _value the amount of tokens to be transferred\n', '    * @return A bool if the transfer was a success or not \n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3*32) public onlyUnlocked returns (bool){\n', '        bytes memory _empty;\n', '        if((_value > 0)\n', '           && (_to != address(0))\n', '       && (_from != address(0))\n', '       && (allowed[_from][msg.sender] > _value )){\n', '           balances[_from] = balances[_from].Sub(_value);\n', '           balances[_to] = balances[_to].Add(_value);\n', '           allowed[_from][msg.sender] = allowed[_from][msg.sender].Sub(_value);\n', '           if(isContract(_to)){\n', '               ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '               receiver.tokenFallback(msg.sender, _value, _empty);\n', '           }\n', '           Transfer(_from, _to, _value);\n', '           return true;\n', '       }\n', '       else{\n', '           return false;\n', '       }\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner has allowed a spender to recieve from owner.\n', '    *\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender to spend.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256){\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    *\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool){\n', '        if( (_value > 0) && (_spender != address(0)) && (balances[msg.sender] >= _value)){\n', '            allowed[msg.sender][_spender] = _value;\n', '            Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        }\n', '        else{\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Calculate number of tokens that will be received in one ether\n', '    * \n', '    */\n', '    function getPrice() public view returns(uint256) {\n', '        uint256 price;\n', '        if(totalSupply <= 1e6*1e18)\n', '            price = 13330;\n', '        else if(totalSupply <= 5e6*1e18)\n', '            price = 12500;\n', '        else if(totalSupply <= 9e6*1e18)\n', '            price = 11760;\n', '        else if(totalSupply <= 13e6*1e18)\n', '            price = 11110;\n', '        else if(totalSupply <= 17e6*1e18)\n', '            price = 10520;\n', '        else if(totalSupply <= 21e6*1e18)\n', '            price = 10000;\n', '        else{\n', '            //zero indicates that no tokens will be allocated when total supply\n', '            //of 21 million tokens is reached\n', '            price = 0;\n', '        }\n', '        return price;\n', '    }\n', '    \n', '    function mintAndTransfer(address beneficiary, uint256 numberOfTokensWithoutDecimal, bytes comment) public onlyOwner {\n', '        uint256 tokensToBeTransferred = numberOfTokensWithoutDecimal*1e18;\n', '        require(totalSupply.Add(tokensToBeTransferred) <= MAXCAP);\n', '        totalSupply = totalSupply.Add(tokensToBeTransferred);\n', '        Transfer(0x0, beneficiary ,tokensToBeTransferred);\n', '    }\n', '    \n', '    function mintAlreadyBoughtTokens(address beneficiary, uint256 tokensBought)internal{\n', '        //Make entry in Investor indexed with address\n', '        Investor storage investorStruct = investors[beneficiary];\n', '        //If it is a new investor, then create a new id\n', '        if(investorStruct.investorID == 0){\n', '            countTotalInvestors++;\n', '            investorStruct.investorID = countTotalInvestors;\n', '            investorList[countTotalInvestors] = beneficiary;\n', '        }\n', '        investorStruct.weiReceived = investorStruct.weiReceived + tokensBought/13330;\n', '        investorStruct.tokensPurchased = investorStruct.tokensPurchased + tokensBought;\n', '        balances[beneficiary] = balances[beneficiary] + tokensBought;\n', '        totalWeiReceived = totalWeiReceived + tokensBought/13330;\n', '        totalSupply = totalSupply + tokensBought;\n', '        \n', '        Transfer(0x0, beneficiary ,tokensBought);\n', '    }\n', '\n', '    /**\n', '    * @dev to enable pause sale for break in ICO and Pre-ICO\n', '    *\n', '    */\n', '    function pauseSale() public onlyOwner{\n', '        assert(saleRunning && startTime > 0 && now <= endTime);\n', '        saleRunning = false;\n', '    }\n', '\n', '    /**\n', '    * @dev to resume paused sale\n', '    *\n', '    */\n', '    function resumeSale() public onlyOwner{\n', '        assert(!saleRunning && startTime > 0 && now <= endTime);\n', '        saleRunning = true;\n', '    }\n', '\n', '    function buyTokens(address beneficiary) internal validTimeframe {\n', '        uint256 tokensBought = msg.value.Mul(getPrice());\n', '        balances[beneficiary] = balances[beneficiary].Add(tokensBought);\n', '        Transfer(0x0, beneficiary ,tokensBought);\n', '        totalSupply = totalSupply.Add(tokensBought);\n', '\n', '        //Make entry in Investor indexed with address\n', '        Investor storage investorStruct = investors[beneficiary];\n', '        //If it is a new investor, then create a new id\n', '        if(investorStruct.investorID == 0){\n', '            countTotalInvestors++;\n', '            investorStruct.investorID = countTotalInvestors;\n', '            investorList[countTotalInvestors] = beneficiary;\n', '        }\n', '        investorStruct.weiReceived = investorStruct.weiReceived.Add(msg.value);\n', '        investorStruct.tokensPurchased = investorStruct.tokensPurchased.Add(tokensBought);\n', '    \n', '        \n', '        //Award referral tokens\n', '        if(referredBy[msg.sender] != address(0) && tokensSuppliedFromReferral.Add(tokensBought/10) < MAX_REFERRAL_TOKENS){\n', '            //give 10% referral tokens\n', '            balances[referredBy[msg.sender]] = balances[referredBy[msg.sender]].Add(tokensBought/10);\n', '            tokensSuppliedFromReferral = tokensSuppliedFromReferral.Add(tokensBought/10);\n', '            totalSupply = totalSupply.Add(tokensBought/10);\n', '            Transfer(0x0, referredBy[msg.sender] ,tokensBought);\n', '        }\n', '        //if referrer was also referred by someone\n', '        if(referredBy[referredBy[msg.sender]] != address(0) && tokensSuppliedFromReferral.Add(tokensBought/100) < MAX_REFERRAL_TOKENS){\n', '            tokensSuppliedFromReferral = tokensSuppliedFromReferral.Add(tokensBought/100);\n', '            //give 1% tokens to 2nd generation referrer\n', '            balances[referredBy[referredBy[msg.sender]]] = balances[referredBy[referredBy[msg.sender]]].Add(tokensBought/100);\n', '            totalSupply = totalSupply.Add(tokensBought/100);\n', '            Transfer(0x0, referredBy[referredBy[msg.sender]] ,tokensBought);\n', '        }\n', '        \n', '        assert(totalSupply <= MAXCAP);\n', '        totalWeiReceived = totalWeiReceived.Add(msg.value);\n', '        ethCollector.transfer(msg.value);\n', '    }\n', '\n', '    /**\n', '     * @dev This function is used to register a referral.\n', '     * Whoever calls this function, is telling contract,\n', '     * that "I was referred by referredByAddress"\n', '     * Whenever I am going to buy tokens, 10% will be awarded to referredByAddress\n', '     * \n', '     * @param referredByAddress The address of person who referred the person calling this function\n', '     */\n', '    function registerReferral (address referredByAddress) public {\n', '        require(msg.sender != referredByAddress && referredByAddress != address(0));\n', '        referredBy[msg.sender] = referredByAddress;\n', '    }\n', '    \n', '    /**\n', '     * @dev Owner is allowed to manually register who was referred by whom\n', '     * @param heWasReferred The address of person who was referred\n', '     * @param I_referred_this_person The person who referred the above address\n', '     */\n', '    function referralRegistration(address heWasReferred, address I_referred_this_person) public onlyOwner {\n', '        require(heWasReferred != address(0) && I_referred_this_person != address(0));\n', '        referredBy[heWasReferred] = I_referred_this_person;\n', '    }\n', '\n', '    /**\n', '    * Finalize the crowdsale\n', '    */\n', '    function finalize() public onlyOwner {\n', '        //Make sure Sale is running\n', '        assert(saleRunning);\n', '        if(MAXCAP.Sub(totalSupply) <= 1 ether || now > endTime){\n', '            //now sale can be finished\n', '            saleRunning = false;\n', '        }\n', '\n', '        //Refund eligible or not\n', '        // 0: sale not started yet, refunding invalid\n', '        // 1: refund not required\n', '        // 2: softcap not reached, refund required\n', '        // 3: Refund in progress\n', '        // 4: Everyone refunded\n', '\n', '        //Checks if the fundraising goal is reached in crowdsale or not\n', '        if (totalWeiReceived < SOFTCAP)\n', '            refundStatus = 2;\n', '        else\n', '            refundStatus = 1;\n', '\n', '        //crowdsale is ended\n', '        saleRunning = false;\n', '        //enable transferring of tokens among token holders\n', '        locked = false;\n', '        //Emit event when crowdsale state changes\n', '        StateChanged(true);\n', '    }\n', '\n', '    /**\n', '    * Refund the investors in case target of crowdsale not achieved\n', '    */\n', '    function refund() public onlyOwner {\n', '        assert(refundStatus == 2 || refundStatus == 3);\n', '        uint batchSize = countInvestorsRefunded.Add(30) < countTotalInvestors ? countInvestorsRefunded.Add(30): countTotalInvestors;\n', '        for(uint i=countInvestorsRefunded.Add(1); i <= batchSize; i++){\n', '            address investorAddress = investorList[i];\n', '            Investor storage investorStruct = investors[investorAddress];\n', '            //If purchase has been made during CrowdSale\n', '            if(investorStruct.tokensPurchased > 0 && investorStruct.tokensPurchased <= balances[investorAddress]){\n', '                //return everything\n', '                investorAddress.transfer(investorStruct.weiReceived);\n', '                //Reduce totalWeiReceived\n', '                totalWeiReceived = totalWeiReceived.Sub(investorStruct.weiReceived);\n', '                //Update totalSupply\n', '                totalSupply = totalSupply.Sub(investorStruct.tokensPurchased);\n', '                // reduce balances\n', '                balances[investorAddress] = balances[investorAddress].Sub(investorStruct.tokensPurchased);\n', '                //set everything to zero after transfer successful\n', '                investorStruct.weiReceived = 0;\n', '                investorStruct.tokensPurchased = 0;\n', '                investorStruct.refunded = true;\n', '            }\n', '        }\n', '        //Update the number of investors that have recieved refund\n', '        countInvestorsRefunded = batchSize;\n', '        if(countInvestorsRefunded == countTotalInvestors){\n', '            refundStatus = 4;\n', '        }\n', '        StateChanged(true);\n', '    }\n', '    \n', '    function extendSale(uint56 numberOfDays) public onlyOwner{\n', '        saleRunning = true;\n', '        endTime = now.Add(numberOfDays*86400);\n', '        StateChanged(true);\n', '    }\n', '\n', '    /**\n', '    * @dev This will receive ether from owner so that the contract has balance while refunding\n', '    *\n', '    */\n', '    function prepareForRefund() public payable {}\n', '\n', '    function () public payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '    * Failsafe drain\n', '    */\n', '    function drain() public onlyOwner {\n', '        owner.transfer(this.balance);\n', '    }\n', '}']
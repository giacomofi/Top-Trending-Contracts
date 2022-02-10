['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner,newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface token {\n', '    function balanceOf(address who) external constant returns (uint256);\n', '\t  function transfer(address to, uint256 value) external returns (bool);\n', '\t  function getTotalSupply() external view returns (uint256);\n', '}\n', '\n', 'contract ApolloSeptemBaseCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    // The token being sold\n', '    token public tokenReward;\n', '\t\n', '    // start and end timestamps where investments are allowed (both inclusive)\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '    // address where funds are collected\n', '    address public wallet;\n', '\t\n', '    // token address\n', '    address public tokenAddress;\n', '\n', '    // amount of raised money in wei\n', '    uint256 public weiRaised;\n', '    \n', '    // ICO period (includes holidays)\n', '    uint public constant  ICO_PERIOD = 180 days;\n', '\n', '    /**\n', '    * event for token purchase logging\n', '    * @param purchaser who paid for the tokens\n', '    * @param beneficiary who got the tokens\n', '    * @param value weis paid for purchase\n', '    * @param amount amount of tokens purchased\n', '    */\n', '    event ApolloSeptemTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '    event ApolloSeptemTokenSpecialPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);\n', '\n', '    function ApolloSeptemBaseCrowdsale(address _wallet, address _tokens) public{\t\t\n', '        require(_wallet != address(0));\n', '        tokenAddress = _tokens;\n', '        tokenReward = token(tokenAddress);\n', '        wallet = _wallet;\n', '\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function () public payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address beneficiary) public payable {\n', '        require(beneficiary != address(0));\n', '        require(validPurchase());\n', '\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // calculate token to be substracted\n', '        uint256 tokens = computeTokens(weiAmount);\n', '\n', '        require(isWithinTokenAllocLimit(tokens));\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        // send tokens to beneficiary\n', '        tokenReward.transfer(beneficiary, tokens);\n', '\n', '        ApolloSeptemTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '        forwardFunds();\n', '    }\n', '\n', '    //transfer used for special contribuitions\n', '    function specialTransfer(address _to, uint _amount) internal returns(bool){\n', '        require(_to != address(0));\n', '        require(_amount > 0);\n', '      \n', '        // calculate token to be substracted\n', '        uint256 tokens = _amount * (10 ** 18);\n', '      \n', '        tokenReward.transfer(_to, tokens);\t\t\n', '        ApolloSeptemTokenSpecialPurchase(msg.sender, _to, tokens);\n', '      \n', '        return true;\n', '    }\n', '\n', '    // @return true if crowdsale event has ended\n', '    function hasEnded() public constant returns (bool) {\n', '        return now > endTime;\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    function forwardFunds() internal {\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '    // @return true if the transaction can buy tokens\n', '    function validPurchase() internal view returns (bool) {\n', '        bool withinPeriod = now >= startTime && now <= endTime;\n', '        bool nonZeroPurchase = msg.value != 0;\n', '\t\t\n', '        return withinPeriod && nonZeroPurchase && isWithinICOTimeLimit();\n', '    }\n', '    \n', '    function isWithinICOTimeLimit() internal view returns (bool) {\n', '        return now <= endTime;\n', '    }\n', '\t\n', '    function isWithinICOLimit(uint256 _tokens) internal view returns (bool) {\t\t\t\n', '        return tokenReward.balanceOf(this).sub(_tokens) >= 0;\n', '    }\n', '\n', '    function isWithinTokenAllocLimit(uint256 _tokens) internal view returns (bool) {\n', '        return (isWithinICOTimeLimit() && isWithinICOLimit(_tokens));\n', '    }\n', '\t\n', '    function sendAllToOwner(address beneficiary) internal returns(bool){\n', '        tokenReward.transfer(beneficiary, tokenReward.balanceOf(this));\n', '        return true;\n', '    }\n', '\n', '    function computeTokens(uint256 weiAmount) internal pure returns (uint256) {\n', '\t\t    // 1 ETH = 4200 APO \n', '        return weiAmount.mul(4200);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ApolloSeptemCappedCrowdsale\n', ' * @dev Extension of ApolloSeptemBaseCrowdsale with a max amount of funds raised\n', ' */\n', 'contract ApolloSeptemCappedCrowdsale is ApolloSeptemBaseCrowdsale{\n', '    using SafeMath for uint256;\n', '\n', '    // HARD_CAP = 30,000 ether \n', '    uint256 public constant HARD_CAP = (3 ether)*(10**4);\n', '\n', '    function ApolloSeptemCappedCrowdsale() public {}\n', '\n', '    // overriding ApolloSeptemBaseCrowdsale#validPurchase to add extra cap logic\n', '    // @return true if investors can buy at the moment\n', '    function validPurchase() internal view returns (bool) {\n', '        bool withinCap = weiRaised.add(msg.value) <= HARD_CAP;\n', '\n', '        return super.validPurchase() && withinCap;\n', '    }\n', '\n', '    // overriding Crowdsale#hasEnded to add cap logic\n', '    // @return true if crowdsale event has ended\n', '    function hasEnded() public constant returns (bool) {\n', '        bool capReached = weiRaised >= HARD_CAP;\n', '        return super.hasEnded() || capReached;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ApolloSeptemCrowdsaleExtended\n', ' * @dev This is ApolloSeptem&#39;s crowdsale contract.\n', ' */\n', 'contract ApolloSeptemCrowdsaleExtended is ApolloSeptemCappedCrowdsale, Ownable {\n', '\n', '    bool public isFinalized = false;\n', '    bool public isStarted = false;\n', '\n', '    event ApolloSeptemStarted();\n', '    event ApolloSeptemFinalized();\n', '\n', '    function ApolloSeptemCrowdsaleExtended(address _wallet,address _tokensAddress) public\n', '        ApolloSeptemCappedCrowdsale()\n', '        ApolloSeptemBaseCrowdsale(_wallet,_tokensAddress) \n', '    {}\n', '\t\n', '  \t/**\n', '    * @dev Must be called to start the crowdsale. \n', '    */\n', '    function start(uint256 _weiRaised) onlyOwner public {\n', '        require(!isStarted);\n', '\n', '        starting(_weiRaised);\n', '        ApolloSeptemStarted();\n', '\n', '        isStarted = true;\n', '    }\n', '\n', '    function starting(uint256 _weiRaised) internal {\n', '        startTime = now;\n', '        weiRaised = _weiRaised;\n', '        endTime = startTime + ICO_PERIOD;\n', '    }\n', '\t\n', '    /**\n', '    * @dev Must be called after crowdsale ends, to do some extra finalization\n', '    * work. Calls the contract&#39;s finalization function.\n', '    */\n', '    function finalize() onlyOwner public {\n', '        require(!isFinalized);\n', '        require(hasEnded());\n', '\n', '        ApolloSeptemFinalized();\n', '\n', '        isFinalized = true;\n', '    }\t\n', '\t\n', '    /**\n', '    * @dev Must be called only in special cases \n', '    */\n', '    function apolloSpecialTransfer(address _beneficiary, uint _amount) onlyOwner public {\t\t \n', '        specialTransfer(_beneficiary, _amount);\n', '    }\n', '\t\n', '    /**\n', '    *@dev Must be called after the crowdsale ends, to send the remaining tokens back to owner\n', '    **/\n', '    function sendRemaningBalanceToOwner(address _tokenOwner) onlyOwner public {\n', '        require(_tokenOwner != address(0));\n', '        \n', '        sendAllToOwner(_tokenOwner);\t\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner,newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface token {\n', '    function balanceOf(address who) external constant returns (uint256);\n', '\t  function transfer(address to, uint256 value) external returns (bool);\n', '\t  function getTotalSupply() external view returns (uint256);\n', '}\n', '\n', 'contract ApolloSeptemBaseCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    // The token being sold\n', '    token public tokenReward;\n', '\t\n', '    // start and end timestamps where investments are allowed (both inclusive)\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '    // address where funds are collected\n', '    address public wallet;\n', '\t\n', '    // token address\n', '    address public tokenAddress;\n', '\n', '    // amount of raised money in wei\n', '    uint256 public weiRaised;\n', '    \n', '    // ICO period (includes holidays)\n', '    uint public constant  ICO_PERIOD = 180 days;\n', '\n', '    /**\n', '    * event for token purchase logging\n', '    * @param purchaser who paid for the tokens\n', '    * @param beneficiary who got the tokens\n', '    * @param value weis paid for purchase\n', '    * @param amount amount of tokens purchased\n', '    */\n', '    event ApolloSeptemTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '    event ApolloSeptemTokenSpecialPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);\n', '\n', '    function ApolloSeptemBaseCrowdsale(address _wallet, address _tokens) public{\t\t\n', '        require(_wallet != address(0));\n', '        tokenAddress = _tokens;\n', '        tokenReward = token(tokenAddress);\n', '        wallet = _wallet;\n', '\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function () public payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address beneficiary) public payable {\n', '        require(beneficiary != address(0));\n', '        require(validPurchase());\n', '\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // calculate token to be substracted\n', '        uint256 tokens = computeTokens(weiAmount);\n', '\n', '        require(isWithinTokenAllocLimit(tokens));\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        // send tokens to beneficiary\n', '        tokenReward.transfer(beneficiary, tokens);\n', '\n', '        ApolloSeptemTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '        forwardFunds();\n', '    }\n', '\n', '    //transfer used for special contribuitions\n', '    function specialTransfer(address _to, uint _amount) internal returns(bool){\n', '        require(_to != address(0));\n', '        require(_amount > 0);\n', '      \n', '        // calculate token to be substracted\n', '        uint256 tokens = _amount * (10 ** 18);\n', '      \n', '        tokenReward.transfer(_to, tokens);\t\t\n', '        ApolloSeptemTokenSpecialPurchase(msg.sender, _to, tokens);\n', '      \n', '        return true;\n', '    }\n', '\n', '    // @return true if crowdsale event has ended\n', '    function hasEnded() public constant returns (bool) {\n', '        return now > endTime;\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    function forwardFunds() internal {\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '    // @return true if the transaction can buy tokens\n', '    function validPurchase() internal view returns (bool) {\n', '        bool withinPeriod = now >= startTime && now <= endTime;\n', '        bool nonZeroPurchase = msg.value != 0;\n', '\t\t\n', '        return withinPeriod && nonZeroPurchase && isWithinICOTimeLimit();\n', '    }\n', '    \n', '    function isWithinICOTimeLimit() internal view returns (bool) {\n', '        return now <= endTime;\n', '    }\n', '\t\n', '    function isWithinICOLimit(uint256 _tokens) internal view returns (bool) {\t\t\t\n', '        return tokenReward.balanceOf(this).sub(_tokens) >= 0;\n', '    }\n', '\n', '    function isWithinTokenAllocLimit(uint256 _tokens) internal view returns (bool) {\n', '        return (isWithinICOTimeLimit() && isWithinICOLimit(_tokens));\n', '    }\n', '\t\n', '    function sendAllToOwner(address beneficiary) internal returns(bool){\n', '        tokenReward.transfer(beneficiary, tokenReward.balanceOf(this));\n', '        return true;\n', '    }\n', '\n', '    function computeTokens(uint256 weiAmount) internal pure returns (uint256) {\n', '\t\t    // 1 ETH = 4200 APO \n', '        return weiAmount.mul(4200);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ApolloSeptemCappedCrowdsale\n', ' * @dev Extension of ApolloSeptemBaseCrowdsale with a max amount of funds raised\n', ' */\n', 'contract ApolloSeptemCappedCrowdsale is ApolloSeptemBaseCrowdsale{\n', '    using SafeMath for uint256;\n', '\n', '    // HARD_CAP = 30,000 ether \n', '    uint256 public constant HARD_CAP = (3 ether)*(10**4);\n', '\n', '    function ApolloSeptemCappedCrowdsale() public {}\n', '\n', '    // overriding ApolloSeptemBaseCrowdsale#validPurchase to add extra cap logic\n', '    // @return true if investors can buy at the moment\n', '    function validPurchase() internal view returns (bool) {\n', '        bool withinCap = weiRaised.add(msg.value) <= HARD_CAP;\n', '\n', '        return super.validPurchase() && withinCap;\n', '    }\n', '\n', '    // overriding Crowdsale#hasEnded to add cap logic\n', '    // @return true if crowdsale event has ended\n', '    function hasEnded() public constant returns (bool) {\n', '        bool capReached = weiRaised >= HARD_CAP;\n', '        return super.hasEnded() || capReached;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ApolloSeptemCrowdsaleExtended\n', " * @dev This is ApolloSeptem's crowdsale contract.\n", ' */\n', 'contract ApolloSeptemCrowdsaleExtended is ApolloSeptemCappedCrowdsale, Ownable {\n', '\n', '    bool public isFinalized = false;\n', '    bool public isStarted = false;\n', '\n', '    event ApolloSeptemStarted();\n', '    event ApolloSeptemFinalized();\n', '\n', '    function ApolloSeptemCrowdsaleExtended(address _wallet,address _tokensAddress) public\n', '        ApolloSeptemCappedCrowdsale()\n', '        ApolloSeptemBaseCrowdsale(_wallet,_tokensAddress) \n', '    {}\n', '\t\n', '  \t/**\n', '    * @dev Must be called to start the crowdsale. \n', '    */\n', '    function start(uint256 _weiRaised) onlyOwner public {\n', '        require(!isStarted);\n', '\n', '        starting(_weiRaised);\n', '        ApolloSeptemStarted();\n', '\n', '        isStarted = true;\n', '    }\n', '\n', '    function starting(uint256 _weiRaised) internal {\n', '        startTime = now;\n', '        weiRaised = _weiRaised;\n', '        endTime = startTime + ICO_PERIOD;\n', '    }\n', '\t\n', '    /**\n', '    * @dev Must be called after crowdsale ends, to do some extra finalization\n', "    * work. Calls the contract's finalization function.\n", '    */\n', '    function finalize() onlyOwner public {\n', '        require(!isFinalized);\n', '        require(hasEnded());\n', '\n', '        ApolloSeptemFinalized();\n', '\n', '        isFinalized = true;\n', '    }\t\n', '\t\n', '    /**\n', '    * @dev Must be called only in special cases \n', '    */\n', '    function apolloSpecialTransfer(address _beneficiary, uint _amount) onlyOwner public {\t\t \n', '        specialTransfer(_beneficiary, _amount);\n', '    }\n', '\t\n', '    /**\n', '    *@dev Must be called after the crowdsale ends, to send the remaining tokens back to owner\n', '    **/\n', '    function sendRemaningBalanceToOwner(address _tokenOwner) onlyOwner public {\n', '        require(_tokenOwner != address(0));\n', '        \n', '        sendAllToOwner(_tokenOwner);\t\n', '    }\n', '}']
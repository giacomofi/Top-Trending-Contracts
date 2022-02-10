['pragma solidity ^0.4.15;\n', '\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address who) constant returns (uint256);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev modifier to allow actions only when the contract IS paused\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev modifier to allow actions only when the contract IS NOT paused\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', '\n', 'contract CashPokerProPreICO is Ownable, Pausable {\n', '    using SafeMath for uint;\n', '\n', '    /* The party who holds the full token pool and has approve()&#39;ed tokens for this crowdsale */\n', '    address public tokenWallet = 0x774d91ac35f4e2f94f0e821a03c6eaff8ad4c138;\n', '\t\n', '    uint public tokensSold;\n', '\n', '    uint public weiRaised;\n', '\n', '    mapping (address => uint256) public purchasedTokens;\n', '     \n', '    uint public investorCount;\n', '\n', '    Token public token = Token(0xA8F93FAee440644F89059a2c88bdC9BF3Be5e2ea);\n', '\n', '    uint public constant minInvest = 0.01 ether;\n', '\n', '    uint public constant tokensLimit = 8000000 * 1 ether;\n', '\n', '    // start and end timestamps where investments are allowed (both inclusive)\n', '    uint256 public startTime = 1503770400; // 26 August 2017\n', '    \n', '    uint256 public endTime = 1504893600; // 8 September 2017\n', '\n', '    uint public price = 0.00017 * 1 ether;\n', '\n', '    /**\n', '     * event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address beneficiary) whenNotPaused payable {\n', '        require(startTime <= now && now <= endTime);\n', '\n', '        uint weiAmount = msg.value;\n', '\n', '        require(weiAmount >= minInvest);\n', '\n', '        uint tokenAmountEnable = tokensLimit.sub(tokensSold);\n', '\n', '        require(tokenAmountEnable > 0);\n', '\n', '        uint tokenAmount = weiAmount / price * 1 ether;\n', '\n', '        if (tokenAmount > tokenAmountEnable) {\n', '            tokenAmount = tokenAmountEnable;\n', '            weiAmount = tokenAmount * price / 1 ether;\n', '            msg.sender.transfer(msg.value - weiAmount);\n', '        }\n', '\n', '        if (purchasedTokens[beneficiary] == 0) investorCount++;\n', '        \n', '        purchasedTokens[beneficiary] = purchasedTokens[beneficiary].add(tokenAmount);\n', '\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        require(token.transferFrom(tokenWallet, beneficiary, tokenAmount));\n', '\n', '        tokensSold = tokensSold.add(tokenAmount);\n', '\n', '        TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);\n', '    }\n', '\n', '    function withdrawal(address to) onlyOwner {\n', '        to.transfer(this.balance);\n', '    }\n', '\n', '    function transfer(address to, uint amount) onlyOwner {\n', '        uint tokenAmountEnable = tokensLimit.sub(tokensSold);\n', '\n', '        if (amount > tokenAmountEnable) amount = tokenAmountEnable;\n', '\n', '        require(token.transferFrom(tokenWallet, to, amount));\n', '\n', '        tokensSold = tokensSold.add(amount);\n', '    }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address who) constant returns (uint256);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev modifier to allow actions only when the contract IS paused\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev modifier to allow actions only when the contract IS NOT paused\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', '\n', 'contract CashPokerProPreICO is Ownable, Pausable {\n', '    using SafeMath for uint;\n', '\n', "    /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */\n", '    address public tokenWallet = 0x774d91ac35f4e2f94f0e821a03c6eaff8ad4c138;\n', '\t\n', '    uint public tokensSold;\n', '\n', '    uint public weiRaised;\n', '\n', '    mapping (address => uint256) public purchasedTokens;\n', '     \n', '    uint public investorCount;\n', '\n', '    Token public token = Token(0xA8F93FAee440644F89059a2c88bdC9BF3Be5e2ea);\n', '\n', '    uint public constant minInvest = 0.01 ether;\n', '\n', '    uint public constant tokensLimit = 8000000 * 1 ether;\n', '\n', '    // start and end timestamps where investments are allowed (both inclusive)\n', '    uint256 public startTime = 1503770400; // 26 August 2017\n', '    \n', '    uint256 public endTime = 1504893600; // 8 September 2017\n', '\n', '    uint public price = 0.00017 * 1 ether;\n', '\n', '    /**\n', '     * event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address beneficiary) whenNotPaused payable {\n', '        require(startTime <= now && now <= endTime);\n', '\n', '        uint weiAmount = msg.value;\n', '\n', '        require(weiAmount >= minInvest);\n', '\n', '        uint tokenAmountEnable = tokensLimit.sub(tokensSold);\n', '\n', '        require(tokenAmountEnable > 0);\n', '\n', '        uint tokenAmount = weiAmount / price * 1 ether;\n', '\n', '        if (tokenAmount > tokenAmountEnable) {\n', '            tokenAmount = tokenAmountEnable;\n', '            weiAmount = tokenAmount * price / 1 ether;\n', '            msg.sender.transfer(msg.value - weiAmount);\n', '        }\n', '\n', '        if (purchasedTokens[beneficiary] == 0) investorCount++;\n', '        \n', '        purchasedTokens[beneficiary] = purchasedTokens[beneficiary].add(tokenAmount);\n', '\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        require(token.transferFrom(tokenWallet, beneficiary, tokenAmount));\n', '\n', '        tokensSold = tokensSold.add(tokenAmount);\n', '\n', '        TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);\n', '    }\n', '\n', '    function withdrawal(address to) onlyOwner {\n', '        to.transfer(this.balance);\n', '    }\n', '\n', '    function transfer(address to, uint amount) onlyOwner {\n', '        uint tokenAmountEnable = tokensLimit.sub(tokensSold);\n', '\n', '        if (amount > tokenAmountEnable) amount = tokenAmountEnable;\n', '\n', '        require(token.transferFrom(tokenWallet, to, amount));\n', '\n', '        tokensSold = tokensSold.add(amount);\n', '    }\n', '}']
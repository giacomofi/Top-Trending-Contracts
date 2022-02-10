['pragma solidity ^0.4.15;\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/LockableToken.sol\n', '\n', 'contract LockableToken is ERC20 {\n', '    function addToTimeLockedList(address addr) external returns (bool);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/PricingStrategy.sol\n', '\n', 'contract PricingStrategy {\n', '\n', '    using SafeMath for uint;\n', '\n', '    uint[] public rates;\n', '    uint[] public limits;\n', '\n', '    function PricingStrategy(\n', '        uint[] _rates,\n', '        uint[] _limits\n', '    ) public\n', '    {\n', '        require(_rates.length == _limits.length);\n', '        rates = _rates;\n', '        limits = _limits;\n', '    }\n', '\n', '    /** Interface declaration. */\n', '    function isPricingStrategy() public view returns (bool) {\n', '        return true;\n', '    }\n', '\n', '    /** Calculate the current price for buy in amount. */\n', '    function calculateTokenAmount(uint weiAmount, uint weiRaised) public view returns (uint tokenAmount) {\n', '        if (weiAmount == 0) {\n', '            return 0;\n', '        }\n', '\n', '        var (rate, index) = currentRate(weiRaised);\n', '        tokenAmount = weiAmount.mul(rate);\n', '\n', '        // if we crossed slot border, recalculate remaining tokens according to next slot price\n', '        if (weiRaised.add(weiAmount) > limits[index]) {\n', '            uint currentSlotWei = limits[index].sub(weiRaised);\n', '            uint currentSlotTokens = currentSlotWei.mul(rate);\n', '            uint remainingWei = weiAmount.sub(currentSlotWei);\n', '            tokenAmount = currentSlotTokens.add(calculateTokenAmount(remainingWei, limits[index]));\n', '        }\n', '    }\n', '\n', '    function currentRate(uint weiRaised) public view returns (uint rate, uint8 index) {\n', '        rate = rates[0];\n', '        index = 0;\n', '\n', '        while (weiRaised >= limits[index]) {\n', '            rate = rates[++index];\n', '        }\n', '    }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Contactable.sol\n', '\n', '/**\n', ' * @title Contactable token\n', ' * @dev Basic version of a contactable contract, allowing the owner to provide a string with their\n', ' * contact information.\n', ' */\n', 'contract Contactable is Ownable{\n', '\n', '    string public contactInformation;\n', '\n', '    /**\n', '     * @dev Allows the owner to set a string with their contact information.\n', '     * @param info The contact information to attach to the contract.\n', '     */\n', '    function setContactInformation(string info) onlyOwner public {\n', '         contactInformation = info;\n', '     }\n', '}\n', '\n', '// File: contracts/Sale.sol\n', '\n', '/**\n', ' * @title Sale\n', ' * @dev Sale is a contract for managing a token crowdsale.\n', ' * Sales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract Sale is Pausable, Contactable {\n', '    using SafeMath for uint;\n', '  \n', '    // The token being sold\n', '    LockableToken public token;\n', '  \n', '    // start and end timestamps where investments are allowed (both inclusive)\n', '    uint public startTime;\n', '    uint public endTime;\n', '  \n', '    // address where funds are collected\n', '    address public wallet;\n', '  \n', '    // the contract, which determine how many token units a buyer gets per wei\n', '    PricingStrategy public pricingStrategy;\n', '  \n', '    // amount of raised money in wei\n', '    uint public weiRaised;\n', '\n', '    // amount of tokens that was sold on the crowdsale\n', '    uint public tokensSold;\n', '\n', '    // maximum amount of wei in total, that can be invested\n', '    uint public weiMaximumGoal;\n', '\n', '    // if weiMinimumGoal will not be reached till endTime, investors will be able to refund ETH\n', '    uint public weiMinimumGoal;\n', '\n', '    // minimal amount of ether, that investor can invest\n', '    uint public minAmount;\n', '\n', '    // How many distinct addresses have invested\n', '    uint public investorCount;\n', '\n', '    // how much wei we have returned back to the contract after a failed crowdfund\n', '    uint public loadedRefund;\n', '\n', '    // how much wei we have given back to investors\n', '    uint public weiRefunded;\n', '\n', '    //How much ETH each address has invested to this crowdsale\n', '    mapping (address => uint) public investedAmountOf;\n', '\n', '    // Addresses that are allowed to invest before ICO offical opens\n', '    mapping (address => bool) public earlyParticipantWhitelist;\n', '\n', '    // whether a buyer bought tokens through other currencies\n', '    mapping (address => bool) public isExternalBuyer;\n', '\n', '    address public admin;\n', '\n', '    modifier onlyOwnerOrAdmin() {\n', '        require(msg.sender == owner || msg.sender == admin); \n', '        _;\n', '    }\n', '  \n', '    /**\n', '     * event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param tokenAmount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(\n', '        address indexed purchaser,\n', '        address indexed beneficiary,\n', '        uint value,\n', '        uint tokenAmount\n', '    );\n', '\n', '    // a refund was processed for an investor\n', '    event Refund(address investor, uint weiAmount);\n', '\n', '    function Sale(\n', '        uint _startTime,\n', '        uint _endTime,\n', '        PricingStrategy _pricingStrategy,\n', '        LockableToken _token,\n', '        address _wallet,\n', '        uint _weiMaximumGoal,\n', '        uint _weiMinimumGoal,\n', '        uint _minAmount\n', '    ) {\n', '        require(_startTime >= now);\n', '        require(_endTime >= _startTime);\n', '        require(_pricingStrategy.isPricingStrategy());\n', '        require(address(_token) != 0x0);\n', '        require(_wallet != 0x0);\n', '        require(_weiMaximumGoal > 0);\n', '        require(_weiMinimumGoal > 0);\n', '\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        pricingStrategy = _pricingStrategy;\n', '        token = _token;\n', '        wallet = _wallet;\n', '        weiMaximumGoal = _weiMaximumGoal;\n', '        weiMinimumGoal = _weiMinimumGoal;\n', '        minAmount = _minAmount;\n', '}\n', '\n', '    // fallback function can be used to buy tokens\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address beneficiary) public whenNotPaused payable returns (bool) {\n', '        uint weiAmount = msg.value;\n', '        \n', '        require(beneficiary != 0x0);\n', '        require(validPurchase(weiAmount));\n', '    \n', '        transferTokenToBuyer(beneficiary, weiAmount);\n', '\n', '        wallet.transfer(weiAmount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferTokenToBuyer(address beneficiary, uint weiAmount) internal {\n', '        if (investedAmountOf[beneficiary] == 0) {\n', '            // A new investor\n', '            investorCount++;\n', '        }\n', '\n', '        // calculate token amount to be created\n', '        uint tokenAmount = pricingStrategy.calculateTokenAmount(weiAmount, weiRaised);\n', '\n', '        investedAmountOf[beneficiary] = investedAmountOf[beneficiary].add(weiAmount);\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        tokensSold = tokensSold.add(tokenAmount);\n', '    \n', '        token.transferFrom(owner, beneficiary, tokenAmount);\n', '        TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);\n', '    }\n', '\n', '   // return true if the transaction can buy tokens\n', '    function validPurchase(uint weiAmount) internal view returns (bool) {\n', '        bool withinPeriod = (now >= startTime || earlyParticipantWhitelist[msg.sender]) && now <= endTime;\n', '        bool withinCap = weiRaised.add(weiAmount) <= weiMaximumGoal;\n', '        bool moreThenMinimal = weiAmount >= minAmount;\n', '\n', '        return withinPeriod && withinCap && moreThenMinimal;\n', '    }\n', '\n', '    // return true if crowdsale event has ended\n', '    function hasEnded() external view returns (bool) {\n', '        bool capReached = weiRaised >= weiMaximumGoal;\n', '        bool afterEndTime = now > endTime;\n', '        \n', '        return capReached || afterEndTime;\n', '    }\n', '\n', '    // get the amount of unsold tokens allocated to this contract;\n', '    function getWeiLeft() external view returns (uint) {\n', '        return weiMaximumGoal - weiRaised;\n', '    }\n', '\n', '    // return true if the crowdsale has raised enough money to be a successful.\n', '    function isMinimumGoalReached() public view returns (bool) {\n', '        return weiRaised >= weiMinimumGoal;\n', '    }\n', '    \n', '    /**\n', '     * allows to add and exclude addresses from earlyParticipantWhitelist for owner\n', '     * @param isWhitelisted is true for adding address into whitelist, false - to exclude\n', '     */\n', '    function editEarlyParicipantWhitelist(address addr, bool isWhitelisted) external onlyOwnerOrAdmin returns (bool) {\n', '        earlyParticipantWhitelist[addr] = isWhitelisted;\n', '        return true;\n', '    }\n', '\n', '    // allows to update tokens rate for owner\n', '    function setPricingStrategy(PricingStrategy _pricingStrategy) external onlyOwner returns (bool) {\n', '        pricingStrategy = _pricingStrategy;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * Allow load refunds back on the contract for the refunding.\n', '    *\n', '    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..\n', '    */\n', '    function loadRefund() external payable {\n', '        require(msg.value > 0);\n', '        require(!isMinimumGoalReached());\n', '        \n', '        loadedRefund = loadedRefund.add(msg.value);\n', '    }\n', '\n', '    /**\n', '    * Investors can claim refund.\n', '    *\n', '    * Note that any refunds from proxy buyers should be handled separately,\n', '    * and not through this contract.\n', '    */\n', '    function refund() external {\n', '        uint256 weiValue = investedAmountOf[msg.sender];\n', '        \n', '        require(!isMinimumGoalReached() && loadedRefund > 0);\n', '        require(!isExternalBuyer[msg.sender]);\n', '        require(weiValue > 0);\n', '        \n', '        investedAmountOf[msg.sender] = 0;\n', '        weiRefunded = weiRefunded.add(weiValue);\n', '        Refund(msg.sender, weiValue);\n', '        msg.sender.transfer(weiValue);\n', '    }\n', '\n', '    function registerPayment(address beneficiary, uint weiAmount) external onlyOwnerOrAdmin {\n', '        require(validPurchase(weiAmount));\n', '        isExternalBuyer[beneficiary] = true;\n', '        transferTokenToBuyer(beneficiary, weiAmount);\n', '    }\n', '\n', '    function setAdmin(address adminAddress) external onlyOwner {\n', '        admin = adminAddress;\n', '    }\n', '}']
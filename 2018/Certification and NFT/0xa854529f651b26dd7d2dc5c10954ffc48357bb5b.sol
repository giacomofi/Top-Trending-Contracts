['pragma solidity ^0.4.18;\n', '\n', '// File: contracts/IPricingStrategy.sol\n', '\n', 'interface IPricingStrategy {\n', '\n', '    function isPricingStrategy() public view returns (bool);\n', '\n', '    /** Calculate the current price for buy in amount. */\n', '    function calculateTokenAmount(uint weiAmount, uint tokensSold) public view returns (uint tokenAmount);\n', '\n', '}\n', '\n', '// File: contracts/token/ERC223.sol\n', '\n', 'contract ERC223 {\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool);\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Contactable.sol\n', '\n', '/**\n', ' * @title Contactable token\n', ' * @dev Basic version of a contactable contract, allowing the owner to provide a string with their\n', ' * contact information.\n', ' */\n', 'contract Contactable is Ownable{\n', '\n', '    string public contactInformation;\n', '\n', '    /**\n', '     * @dev Allows the owner to set a string with their contact information.\n', '     * @param info The contact information to attach to the contract.\n', '     */\n', '    function setContactInformation(string info) onlyOwner public {\n', '         contactInformation = info;\n', '     }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/token/MintableToken.sol\n', '\n', 'contract MintableToken is ERC20, Contactable {\n', '    using SafeMath for uint;\n', '\n', '    mapping (address => uint) balances;\n', '    mapping (address => uint) public holderGroup;\n', '    bool public mintingFinished = false;\n', '    address public minter;\n', '\n', '    event MinterChanged(address indexed previousMinter, address indexed newMinter);\n', '    event Mint(address indexed to, uint amount);\n', '    event MintFinished();\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    modifier onlyMinter() {\n', '        require(msg.sender == minter);\n', '        _;\n', '    }\n', '\n', '      /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint _amount, uint _holderGroup) onlyMinter canMint public returns (bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        holderGroup[_to] = _holderGroup;\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() onlyMinter canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '\n', '    function changeMinter(address _minter) external onlyOwner {\n', '        require(_minter != 0x0);\n', '        MinterChanged(minter, _minter);\n', '        minter = _minter;\n', '    }\n', '}\n', '\n', '// File: contracts/token/TokenReciever.sol\n', '\n', '/*\n', ' * Contract that is working with ERC223 tokens\n', ' */\n', ' \n', ' contract TokenReciever {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '    }\n', '}\n', '\n', '// File: contracts/token/HeroCoin.sol\n', '\n', 'contract HeroCoin is ERC223, MintableToken {\n', '    using SafeMath for uint;\n', '\n', '    string constant public name = "HeroCoin";\n', '    string constant public symbol = "HRO";\n', '    uint constant public decimals = 18;\n', '\n', '    mapping(address => mapping (address => uint)) internal allowed;\n', '\n', '    mapping (uint => uint) public activationTime;\n', '\n', '    modifier activeForHolder(address holder) {\n', '        uint group = holderGroup[holder];\n', '        require(activationTime[group] <= now);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        bytes memory empty;\n', '        return transfer(_to, _value, empty);\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    * @param _data Optional metadata.\n', '    */\n', '    function transfer(address _to, uint _value, bytes _data) public activeForHolder(msg.sender) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        if (isContract(_to)) {\n', '            TokenReciever receiver = TokenReciever(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) activeForHolder(_from) public returns (bool) {\n', '        bytes memory empty;\n', '        return transferFrom(_from, _to, _value, empty);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint the amount of tokens to be transferred\n', '     * @param _data Optional metadata.\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        if (isContract(_to)) {\n', '            TokenReciever receiver = TokenReciever(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '\n', '        Transfer(_from, _to, _value);\n', '        Transfer(_from, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function setActivationTime(uint _holderGroup, uint _activationTime) external onlyOwner {\n', '        activationTime[_holderGroup] = _activationTime;\n', '    }\n', '\n', '    function setHolderGroup(address _holder, uint _holderGroup) external onlyOwner {\n', '        holderGroup[_holder] = _holderGroup;\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool) {\n', '        uint length;\n', '        assembly {\n', '              //retrieve the size of the code on target address, this needs assembly\n', '              length := extcodesize(_addr)\n', '        }\n', '        return (length>0);\n', '    }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '// File: contracts/SaleBase.sol\n', '\n', 'contract SaleBase is Pausable, Contactable {\n', '    using SafeMath for uint;\n', '  \n', '    // The token being sold\n', '    HeroCoin public token;\n', '  \n', '    // start and end timestamps where purchases are allowed (both inclusive)\n', '    uint public startTime;\n', '    uint public endTime;\n', '  \n', '    // address where funds are collected\n', '    address public wallet;\n', '  \n', '    // the contract, which determine how many token units a buyer gets per wei\n', '    IPricingStrategy public pricingStrategy;\n', '  \n', '    // amount of raised money in wei\n', '    uint public weiRaised;\n', '\n', '    // amount of tokens that was sold on the crowdsale\n', '    uint public tokensSold;\n', '\n', '    // maximum amount of wei in total, that can be bought\n', '    uint public weiMaximumGoal;\n', '\n', '    // if weiMinimumGoal will not be reached till endTime, buyers will be able to refund ETH\n', '    uint public weiMinimumGoal;\n', '\n', '    // minimum amount of wel, that can be contributed\n', '    uint public weiMinimumAmount;\n', '\n', '    // How many distinct addresses have bought\n', '    uint public buyerCount;\n', '\n', '    // how much wei we have returned back to the contract after a failed crowdfund\n', '    uint public loadedRefund;\n', '\n', '    // how much wei we have given back to buyers\n', '    uint public weiRefunded;\n', '\n', '    // how much ETH each address has bought to this crowdsale\n', '    mapping (address => uint) public boughtAmountOf;\n', '\n', '    // holder group of sale buyers, must be defined in child contract\n', '    function holderGroupNumber() pure returns (uint) {\n', '        return 0;\n', '    }\n', '\n', '    /**\n', '     * event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param tokenAmount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(\n', '        address indexed purchaser,\n', '        address indexed beneficiary,\n', '        uint value,\n', '        uint tokenAmount\n', '    );\n', '\n', '    // a refund was processed for an buyer\n', '    event Refund(address buyer, uint weiAmount);\n', '\n', '    function SaleBase(\n', '        uint _startTime,\n', '        uint _endTime,\n', '        IPricingStrategy _pricingStrategy,\n', '        HeroCoin _token,\n', '        address _wallet,\n', '        uint _weiMaximumGoal,\n', '        uint _weiMinimumGoal,\n', '        uint _weiMinimumAmount\n', '    ) public\n', '    {\n', '        require(_pricingStrategy.isPricingStrategy());\n', '        require(address(_token) != 0x0);\n', '        require(_wallet != 0x0);\n', '        require(_weiMaximumGoal > 0);\n', '\n', '        setStartTime(_startTime);\n', '        setEndTime(_endTime);\n', '        pricingStrategy = _pricingStrategy;\n', '        token = _token;\n', '        wallet = _wallet;\n', '        weiMaximumGoal = _weiMaximumGoal;\n', '        weiMinimumGoal = _weiMinimumGoal;\n', '        weiMinimumAmount = _weiMinimumAmount;\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address beneficiary) public whenNotPaused payable returns (bool) {\n', '        uint weiAmount = msg.value;\n', '\n', '        require(beneficiary != 0x0);\n', '        require(validPurchase(weiAmount));\n', '    \n', '        // calculate token amount to be created\n', '        uint tokenAmount = pricingStrategy.calculateTokenAmount(weiAmount, tokensSold);\n', '        \n', '        mintTokenToBuyer(beneficiary, tokenAmount, weiAmount);\n', '        \n', '        wallet.transfer(msg.value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function mintTokenToBuyer(address beneficiary, uint tokenAmount, uint weiAmount) internal {\n', '        if (boughtAmountOf[beneficiary] == 0) {\n', '            // A new buyer\n', '            buyerCount++;\n', '        }\n', '\n', '        boughtAmountOf[beneficiary] = boughtAmountOf[beneficiary].add(weiAmount);\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        tokensSold = tokensSold.add(tokenAmount);\n', '    \n', '        token.mint(beneficiary, tokenAmount, holderGroupNumber());\n', '        TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);\n', '    }\n', '\n', '    // return true if the transaction can buy tokens\n', '    function validPurchase(uint weiAmount) internal constant returns (bool) {\n', '        bool withinPeriod = now >= startTime && now <= endTime;\n', '        bool withinCap = weiRaised.add(weiAmount) <= weiMaximumGoal;\n', '        bool moreThenMinimum = weiAmount >= weiMinimumAmount;\n', '\n', '        return withinPeriod && withinCap && moreThenMinimum;\n', '    }\n', '\n', '    // return true if crowdsale event has ended\n', '    function hasEnded() external constant returns (bool) {\n', '        bool capReached = weiRaised >= weiMaximumGoal;\n', '        bool afterEndTime = now > endTime;\n', '        \n', '        return capReached || afterEndTime;\n', '    }\n', '\n', '    // get the amount of unsold tokens allocated to this contract;\n', '    function getWeiLeft() external constant returns (uint) {\n', '        return weiMaximumGoal - weiRaised;\n', '    }\n', '\n', '    // return true if the crowdsale has raised enough money to be a successful.\n', '    function isMinimumGoalReached() public constant returns (bool) {\n', '        return weiRaised >= weiMinimumGoal;\n', '    }\n', '    \n', '    // allows to update tokens rate for owner\n', '    function setPricingStrategy(IPricingStrategy _pricingStrategy) external onlyOwner returns (bool) {\n', '        pricingStrategy = _pricingStrategy;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * Allow load refunds back on the contract for the refunding.\n', '    *\n', '    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..\n', '    */\n', '    function loadRefund() external payable {\n', '        require(msg.value > 0);\n', '        require(!isMinimumGoalReached());\n', '        \n', '        loadedRefund = loadedRefund.add(msg.value);\n', '    }\n', '\n', '    /**\n', '    * Buyers can claim refund.\n', '    *\n', '    * Note that any refunds from proxy buyers should be handled separately,\n', '    * and not through this contract.\n', '    */\n', '    function refund() external {\n', '        require(!isMinimumGoalReached() && loadedRefund > 0);\n', '        uint256 weiValue = boughtAmountOf[msg.sender];\n', '        require(weiValue > 0);\n', '        \n', '        boughtAmountOf[msg.sender] = 0;\n', '        weiRefunded = weiRefunded.add(weiValue);\n', '        Refund(msg.sender, weiValue);\n', '        msg.sender.transfer(weiValue);\n', '    }\n', '\n', '    function setStartTime(uint _startTime) public onlyOwner {\n', '        require(_startTime >= now);\n', '        startTime = _startTime;\n', '    }\n', '\n', '    function setEndTime(uint _endTime) public onlyOwner {\n', '        require(_endTime >= startTime);\n', '        endTime = _endTime;\n', '    }\n', '}\n', '\n', '// File: contracts/presale/Presale.sol\n', '\n', '/**\n', ' * @title Presale\n', ' * @dev Presale is a contract for managing a token crowdsale.\n', ' * Presales have a start and end timestamps, where buyers can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract Presale is SaleBase {\n', '    function Presale(\n', '        uint _startTime,\n', '        uint _endTime,\n', '        IPricingStrategy _pricingStrategy,\n', '        HeroCoin _token,\n', '        address _wallet,\n', '        uint _weiMaximumGoal,\n', '        uint _weiMinimumGoal,\n', '        uint _weiMinimumAmount\n', '    ) public SaleBase(\n', '        _startTime,\n', '        _endTime,\n', '        _pricingStrategy,\n', '        _token,\n', '        _wallet,\n', '        _weiMaximumGoal,\n', '        _weiMinimumGoal,\n', '        _weiMinimumAmount) \n', '    {\n', '\n', '    }\n', '\n', '    function holderGroupNumber() public pure returns (uint) {\n', '        return 1;\n', '    }\n', '}']
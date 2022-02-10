['pragma solidity ^0.4.21;\n', '\n', '// File: contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/token/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts/token/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/BurnableToken.sol\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '}\n', '\n', '// File: contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/token/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/MintableToken.sol\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   *\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: contracts/token/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '// File: contracts/BitexToken.sol\n', '\n', 'contract BitexToken is MintableToken, BurnableToken {\n', '    using SafeERC20 for ERC20;\n', '\n', '    string public constant name = "Bitex Coin";\n', '\n', '    string public constant symbol = "XBX";\n', '\n', '    uint8 public decimals = 18;\n', '\n', '    bool public tradingStarted = false;\n', '\n', '    // allow exceptional transfer fro sender address - this mapping  can be modified only before the starting rounds\n', '    mapping (address => bool) public transferable;\n', '\n', '    /**\n', '     * @dev modifier that throws if spender address is not allowed to transfer\n', '     * and the trading is not enabled\n', '     */\n', '    modifier allowTransfer(address _spender) {\n', '\n', '        require(tradingStarted || transferable[_spender]);\n', '        _;\n', '    }\n', '    /**\n', '    *\n', '    * Only the owner of the token smart contract can add allow token to be transfer before the trading has started\n', '    *\n', '    */\n', '\n', '    function modifyTransferableHash(address _spender, bool value) onlyOwner public {\n', '        transferable[_spender] = value;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the owner to enable the trading.\n', '     */\n', '    function startTrading() onlyOwner public {\n', '        tradingStarted = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows anyone to transfer the tokens once trading has started\n', '     * @param _to the recipient address of the tokens.\n', '     * @param _value number of tokens to be transfered.\n', '     */\n', '    function transfer(address _to, uint _value) allowTransfer(msg.sender) public returns (bool){\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows anyone to transfer the  tokens once trading has started or if the spender is part of the mapping\n', '\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint the amout of tokens to be transfered\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) allowTransfer(_from) public returns (bool){\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '    function approve(address _spender, uint256 _value) public allowTransfer(_spender) returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    /**\n', '     * Adding whenNotPaused\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public allowTransfer(_spender) returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    /**\n', '     * Adding whenNotPaused\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public allowTransfer(_spender) returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/KnowYourCustomer.sol\n', '\n', 'contract KnowYourCustomer is Ownable\n', '{\n', '    //\n', '    // with this structure\n', '    //\n', '    struct Contributor {\n', '        // kyc cleared or not\n', '        bool cleared;\n', '\n', '        // % more for the contributor bring on board in 1/100 of %\n', '        // 2.51 % --> 251\n', '        // 100% --> 10000\n', '        uint16 contributor_get;\n', '\n', '        // eth address of the referer if any - the contributor address is the key of the hash\n', '        address ref;\n', '\n', '        // % more for the referrer\n', '        uint16 affiliate_get;\n', '    }\n', '\n', '\n', '    mapping (address => Contributor) public whitelist;\n', '    //address[] public whitelistArray;\n', '\n', '    /**\n', '    *    @dev Populate the whitelist, only executed by whiteListingAdmin\n', '    *  whiteListingAdmin /\n', '    */\n', '\n', '    function setContributor(address _address, bool cleared, uint16 contributor_get, uint16 affiliate_get, address ref) onlyOwner public{\n', '\n', '        // not possible to give an exorbitant bonus to be more than 100% (100x100 = 10000)\n', '        require(contributor_get<10000);\n', '        require(affiliate_get<10000);\n', '\n', '        Contributor storage contributor = whitelist[_address];\n', '\n', '        contributor.cleared = cleared;\n', '        contributor.contributor_get = contributor_get;\n', '\n', '        contributor.ref = ref;\n', '        contributor.affiliate_get = affiliate_get;\n', '\n', '    }\n', '\n', '    function getContributor(address _address) view public returns (bool, uint16, address, uint16 ) {\n', '        return (whitelist[_address].cleared, whitelist[_address].contributor_get, whitelist[_address].ref, whitelist[_address].affiliate_get);\n', '    }\n', '\n', '    function getClearance(address _address) view public returns (bool) {\n', '        return whitelist[_address].cleared;\n', '    }\n', '}\n', '\n', '// File: contracts/crowdsale/Crowdsale.sol\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  MintableToken public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {\n', '    require(_startTime >= now);\n', '    require(_endTime >= _startTime);\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '\n', '    token = createTokenContract();\n', '    startTime = _startTime;\n', '    endTime = _endTime;\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '  }\n', '\n', '  // creates the token to be sold.\n', '  // override this method to have crowdsale of a specific mintable token.\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new MintableToken();\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  // overrided to create custom buy\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != address(0));\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(rate);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(beneficiary, tokens);\n', '    emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // overrided to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal view returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime ;\n', '    bool nonZeroPurchase = msg.value != 0 ;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public view returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '\n', '}\n', '\n', '// File: contracts/crowdsale/FinalizableCrowdsale.sol\n', '\n', '/**\n', ' * @title FinalizableCrowdsale\n', ' * @dev Extension of Crowdsale where an owner can do extra work\n', ' * after finishing.\n', ' */\n', 'contract FinalizableCrowdsale is Crowdsale, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  bool public isFinalized = false;\n', '\n', '  event Finalized();\n', '\n', '  /**\n', '   * @dev Must be called after crowdsale ends, to do some extra finalization\n', '   * work. Calls the contract&#39;s finalization function.\n', '   */\n', '  function finalize() onlyOwner public {\n', '    require(!isFinalized);\n', '    require(hasEnded());\n', '\n', '    finalization();\n', '    emit Finalized();\n', '\n', '    isFinalized = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Can be overridden to add finalization logic. The overriding function\n', '   * should call super.finalization() to ensure the chain of finalization is\n', '   * executed entirely.\n', '   */\n', '  function finalization() internal{\n', '  }\n', '}\n', '\n', '// File: contracts/crowdsale/RefundVault.sol\n', '\n', '/**\n', ' * @title RefundVault\n', ' * @dev This contract is used for storing funds while a crowdsale\n', ' * is in progress. Supports refunding the money if crowdsale fails,\n', ' * and forwarding it if crowdsale is successful.\n', ' */\n', 'contract RefundVault is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  enum State { Active, Refunding, Closed }\n', '\n', '  mapping (address => uint256) public deposited;\n', '  address public wallet;\n', '  State public state;\n', '\n', '  event Closed();\n', '  event RefundsEnabled();\n', '  event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '  function RefundVault(address _wallet) public {\n', '    require(_wallet != address(0));\n', '    wallet = _wallet;\n', '    state = State.Active;\n', '  }\n', '\n', '  function deposit(address investor) onlyOwner public payable {\n', '    require(state == State.Active);\n', '    deposited[investor] = deposited[investor].add(msg.value);\n', '  }\n', '\n', '  function close() onlyOwner public {\n', '    // this is this part that shall be removed, that way if called later it run the wallet transfer in any case\n', '    // require(state == State.Active);\n', '    state = State.Closed;\n', '    emit Closed();\n', '    wallet.transfer(address(this).balance);\n', '  }\n', '\n', '  function enableRefunds() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Refunding;\n', '    emit RefundsEnabled();\n', '  }\n', '\n', '  function refund(address investor) public {\n', '    require(state == State.Refunding);\n', '    uint256 depositedValue = deposited[investor];\n', '    deposited[investor] = 0;\n', '    investor.transfer(depositedValue);\n', '    emit Refunded(investor, depositedValue);\n', '  }\n', '}\n', '\n', '// File: contracts/crowdsale/RefundableCrowdsale.sol\n', '\n', '/**\n', ' * @title RefundableCrowdsale\n', ' * @dev Extension of Crowdsale contract that adds a funding goal, and\n', ' * the possibility of users getting a refund if goal is not met.\n', ' * Uses a RefundVault as the crowdsale&#39;s vault.\n', ' */\n', 'contract RefundableCrowdsale is FinalizableCrowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // minimum amount of funds to be raised in weis\n', '  uint256 public goal;\n', '\n', '  // refund vault used to hold funds while crowdsale is running\n', '  RefundVault public vault;\n', '\n', '  function RefundableCrowdsale(uint256 _goal) public {\n', '    require(_goal > 0);\n', '    vault = new RefundVault(wallet);\n', '    goal = _goal;\n', '  }\n', '\n', '  // We&#39;re overriding the fund forwarding from Crowdsale.\n', '  // In addition to sending the funds, we want to call\n', '  // the RefundVault deposit function\n', '  function forwardFunds() internal {\n', '    vault.deposit.value(msg.value)(msg.sender);\n', '  }\n', '\n', '  // if crowdsale is unsuccessful, investors can claim refunds here\n', '  function claimRefund() public {\n', '    require(isFinalized);\n', '    require(!goalReached());\n', '\n', '    vault.refund(msg.sender);\n', '  }\n', '\n', '  // vault finalization task, called when owner calls finalize()\n', '  function finalization() internal {\n', '    if (goalReached()) {\n', '      vault.close();\n', '    } else {\n', '      vault.enableRefunds();\n', '    }\n', '\n', '    super.finalization();\n', '  }\n', '\n', '  function goalReached() public view returns (bool) {\n', '    return weiRaised >= goal;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/BitexTokenCrowdSale.sol\n', '\n', 'contract BitexTokenCrowdSale is Crowdsale, RefundableCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    // number of participants\n', '    uint256 public numberOfPurchasers = 0;\n', '\n', '    // maximum tokens that can be minted in this crowd sale - initialised later by the constructor\n', '    uint256 public maxTokenSupply = 0;\n', '\n', '    // amounts of tokens already minted at the begining of this crowd sale - initialised later by the constructor\n', '    uint256 public initialTokenAmount = 0;\n', '\n', '    // Minimum amount to been able to contribute - initialised later by the constructor\n', '    uint256 public minimumAmount = 0;\n', '\n', '    // to compute the bonus\n', '    bool public preICO;\n', '\n', '    // the token\n', '    BitexToken public token;\n', '\n', '    // the kyc and affiliation management\n', '    KnowYourCustomer public kyc;\n', '\n', '    // remaining token are sent to this address\n', '    address public walletRemaining;\n', '\n', '    // this is the owner of the token, when the finalize function is called\n', '    address public pendingOwner;\n', '\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint256 rate, address indexed referral, uint256 referredBonus );\n', '    event TokenPurchaseAffiliate(address indexed ref, uint256 amount );\n', '\n', '    function BitexTokenCrowdSale(\n', '        uint256 _startTime,\n', '        uint256 _endTime,\n', '        uint256 _rate,\n', '        uint256 _goal,\n', '        uint256 _minimumAmount,\n', '        uint256 _maxTokenSupply,\n', '        address _wallet,\n', '        BitexToken _token,\n', '        KnowYourCustomer _kyc,\n', '        bool _preICO,\n', '        address _walletRemaining,\n', '        address _pendingOwner\n', '    )\n', '    FinalizableCrowdsale()\n', '    RefundableCrowdsale(_goal)\n', '    Crowdsale(_startTime, _endTime, _rate, _wallet) public\n', '    { \n', '        require(_minimumAmount >= 0);\n', '        require(_maxTokenSupply > 0);\n', '        require(_walletRemaining != address(0));\n', '\n', '        minimumAmount = _minimumAmount;\n', '        maxTokenSupply = _maxTokenSupply;\n', '\n', '        preICO = _preICO;\n', '\n', '        walletRemaining = _walletRemaining;\n', '        pendingOwner = _pendingOwner;\n', '\n', '        kyc = _kyc;\n', '        token = _token;\n', '\n', '        //\n', '        // record the amount of already minted token to been able to compute the delta with the tokens\n', '        // minted during the pre sale, this is useful only for the pre - ico\n', '        //\n', '        if (preICO)\n', '        {\n', '            initialTokenAmount = token.totalSupply();\n', '        }\n', '    }\n', '\n', '    /**\n', '    *\n', '    * Create the token on the fly, owner is the contract, not the contract owner yet\n', '    *\n', '    **/\n', '    function createTokenContract() internal returns (MintableToken) {\n', '        return token;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Calculates the amount of  coins the buyer gets\n', '    * @param weiAmount uint the amount of wei send to the contract\n', '    * @return uint the amount of tokens the buyer gets\n', '    */\n', '    function computeTokenWithBonus(uint256 weiAmount) public view returns(uint256) {\n', '        uint256 tokens_ = 0;\n', '        if (preICO)\n', '        {\n', '            if (weiAmount >= 50000 ether  ) {\n', '\n', '                tokens_ = weiAmount.mul(34).div(100);\n', '\n', '            }\n', '            else if (weiAmount<50000 ether && weiAmount >= 10000 ether) {\n', '\n', '                tokens_ = weiAmount.mul(26).div(100);\n', '\n', '            } else if (weiAmount<10000 ether && weiAmount >= 5000 ether) {\n', '\n', '                tokens_ = weiAmount.mul(20).div(100);\n', '\n', '            } else if (weiAmount<5000 ether && weiAmount >= 1000 ether) {\n', '\n', '                tokens_ = weiAmount.mul(16).div(100);\n', '            }\n', '\n', '        }else{\n', '            if (weiAmount >= 50000 ether  ) {\n', '\n', '                tokens_ = weiAmount.mul(17).div(100);\n', '\n', '            }\n', '            else if (weiAmount<50000 ether && weiAmount >= 10000 ether) {\n', '\n', '                tokens_ = weiAmount.mul(13).div(100);\n', '\n', '            } else if (weiAmount<10000 ether && weiAmount >= 5000 ether) {\n', '\n', '                tokens_ = weiAmount.mul(10).div(100);\n', '\n', '            } else if (weiAmount<5000 ether && weiAmount >= 1000 ether) {\n', '\n', '                tokens_ = weiAmount.mul(8).div(100);\n', '            }\n', '\n', '        }\n', '\n', '        return tokens_;\n', '    }\n', '    //\n', '    // override the claimRefund, so only user that have burn their token can claim for a refund\n', '    //\n', '    function claimRefund() public {\n', '\n', '        // get the number of token from this sender\n', '        uint256 tokenBalance = token.balanceOf(msg.sender);\n', '\n', '        // the refund can be run  only if the tokens has been burn\n', '        require(tokenBalance == 0);\n', '\n', '        // run the refund\n', '        super.claimRefund();\n', '\n', '    }\n', '\n', '     // transfer the token owner ship to the crowdsale contract\n', '    //        token.transferOwnership(currentIco);\n', '    function finalization() internal {\n', '\n', '        if (!preICO)\n', '        {\n', '            uint256 remainingTokens = maxTokenSupply.sub(token.totalSupply());\n', '\n', '            // mint the remaining amount and assign them to the beneficiary\n', '            // --> here we can manage the vesting of the remaining tokens\n', '            //\n', '            token.mint(walletRemaining, remainingTokens);\n', '\n', '        }\n', '\n', '         // finalize the refundable inherited contract\n', '        super.finalization();\n', '\n', '        if (!preICO)\n', '        {\n', '            // no more minting allowed - immutable\n', '            token.finishMinting();\n', '        }\n', '\n', '        // transfer the token owner ship from the contract address to the pendingOwner icoController\n', '        token.transferOwnership(pendingOwner);\n', '\n', '    }\n', '\n', '\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address beneficiary) public payable {\n', '        require(beneficiary != address(0));\n', '        require(validPurchase());\n', '\n', '        // validate KYC here\n', '        // if not part of kyc then throw\n', '        bool cleared;\n', '        uint16 contributor_get;\n', '        address ref;\n', '        uint16 affiliate_get;\n', '\n', '        (cleared,contributor_get,ref,affiliate_get) = kyc.getContributor(beneficiary);\n', '\n', '        // Transaction do not happen if the contributor is not KYC cleared\n', '        require(cleared);\n', '\n', '        // how much the contributor sent in wei\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // Compute the number of tokens per wei using the rate\n', '        uint256 tokens = weiAmount.mul(rate);\n', '\n', '         // compute the amount of bonus, from the contribution amount\n', '        uint256 bonus = computeTokenWithBonus(tokens);\n', '\n', '        // compute the amount of token bonus for the contributor thank to his referral\n', '        uint256 contributorGet = tokens.mul(contributor_get).div(100*100);\n', '\n', '        // Sum it all\n', '        tokens = tokens.add(bonus);\n', '        tokens = tokens.add(contributorGet);\n', '\n', '        // capped to a maxTokenSupply\n', '        // make sure we can not mint more token than expected\n', '        // require(((token.totalSupply()-initialTokenAmount) + tokens) <= maxTokenSupply);\n', '        require((minted().add(tokens)) <= maxTokenSupply);\n', '\n', '\n', '        // Mint the token\n', '        token.mint(beneficiary, tokens);\n', '\n', '        // log the event\n', '        emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, rate, ref, contributorGet);\n', '\n', '        // update wei raised and number of purchasers\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        numberOfPurchasers = numberOfPurchasers + 1;\n', '\n', '        forwardFunds();\n', '\n', '        // ------------------------------------------------------------------\n', '        // compute the amount of token bonus that the referral get :\n', '        // only if KYC cleared, only if enough tokens still available\n', '        // ------------------------------------------------------------------\n', '        bool refCleared;\n', '        (refCleared) = kyc.getClearance(ref);\n', '        if (refCleared && ref != beneficiary)\n', '        {\n', '            // recompute the tokens amount using only the rate\n', '            tokens = weiAmount.mul(rate);\n', '\n', '            // compute the amount of token for the affiliate\n', '            uint256 affiliateGet = tokens.mul(affiliate_get).div(100*100);\n', '\n', '            // capped to a maxTokenSupply\n', '            // make sure we can not mint more token than expected\n', '            // we do not throw here as if this edge case happens it can be dealt with of chain\n', '            // if ( (token.totalSupply()-initialTokenAmount) + affiliateGet <= maxTokenSupply)\n', '            if ( minted().add(affiliateGet) <= maxTokenSupply)\n', '\n', '            {\n', '                // Mint the token\n', '                token.mint(ref, affiliateGet);\n', '                emit TokenPurchaseAffiliate(ref, tokens );\n', '            }\n', '\n', '        }\n', '    }\n', '\n', '    // overriding Crowdsale#validPurchase to add extra cap logic\n', '    // @return true if investors can buy at the moment\n', '    function validPurchase() internal view returns (bool) {\n', '\n', '        // make sure we accept only the minimum contribution\n', '        bool minAmount = (msg.value >= minimumAmount);\n', '\n', '        // make sure that the purchase follow each rules to be valid\n', '        return super.validPurchase() && minAmount;\n', '    }\n', '\n', '    function minted() public view returns(uint256)\n', '    {\n', '        return token.totalSupply().sub(initialTokenAmount); \n', '    }\n', '\n', '    // overriding Crowdsale#hasEnded to add cap logic\n', '    // @return true if crowdsale event has ended\n', '    function hasEnded() public view returns (bool) {\n', '        // bool capReached = (token.totalSupply() - initialTokenAmount) >= maxTokenSupply;\n', '        // bool capReached = minted() >= maxTokenSupply;\n', '        return super.hasEnded() || (minted() >= maxTokenSupply);\n', '    }\n', '\n', '    /**\n', '      *\n', '      * Admin functions only executed by owner:\n', '      * Can change minimum amount\n', '      *\n', '      */\n', '    function changeMinimumAmount(uint256 _minimumAmount) onlyOwner public {\n', '        require(_minimumAmount > 0);\n', '\n', '        minimumAmount = _minimumAmount;\n', '    }\n', '\n', '     /**\n', '      *\n', '      * Admin functions only executed by owner:\n', '      * Can change rate\n', '      *\n', '      * We do not use an oracle here as oracle need to be paid each time, and if the oracle is not responding\n', '      * or hacked the rate could be detrimentally modified from an contributor perspective.\n', '      *\n', '      */\n', '    function changeRate(uint256 _rate) onlyOwner public {\n', '        require(_rate > 0);\n', '        \n', '        rate = _rate;\n', '    }\n', '\n', '    /**\n', '      *\n', '      * Admin functions only called by owner:\n', '      * Can change events dates\n', '      *\n', '      */\n', '    function changeDates(uint256 _startTime, uint256 _endTime) onlyOwner public {\n', '        require(_startTime >= now);\n', '        require(_endTime >= _startTime);\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '    }\n', '\n', '    function modifyTransferableHash(address _spender, bool value) onlyOwner public {\n', '        token.modifyTransferableHash(_spender,value);\n', '    }\n', '\n', '    /**\n', '      *\n', '      * Admin functions only called by owner:\n', '      * Can transfer the owner ship of the vault, so a close can be called\n', '      * only by the owner ....\n', '      *\n', '      */\n', '    function transferVault(address newOwner) onlyOwner public {\n', '        vault.transferOwnership(newOwner);\n', '\n', '    }\n', '   \n', '}']
['/*\n', ' * This file was generated by MyWish Platform (https://mywish.io/)\n', ' * The complete code could be found at https://github.com/MyWishPlatform/\n', ' * Copyright (C) 2018 MyWish\n', ' *\n', ' * This program is free software: you can redistribute it and/or modify\n', ' * it under the terms of the GNU Lesser General Public License as published by\n', ' * the Free Software Foundation, either version 3 of the License, or\n', ' * (at your option) any later version.\n', ' *\n', ' * This program is distributed in the hope that it will be useful,\n', ' * but WITHOUT ANY WARRANTY; without even the implied warranty of\n', ' * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', ' * GNU Lesser General Public License for more details.\n', ' *\n', ' * You should have received a copy of the GNU Lesser General Public License\n', ' * along with this program. If not, see <http://www.gnu.org/licenses/>.\n', ' */\n', '\n', 'pragma solidity ^0.4.20;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  MintableToken public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {\n', '    require(_startTime >= now);\n', '    require(_endTime >= _startTime);\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '\n', '    token = createTokenContract();\n', '    startTime = _startTime;\n', '    endTime = _endTime;\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '  }\n', '\n', '  // creates the token to be sold.\n', '  // override this method to have crowdsale of a specific mintable token.\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new MintableToken();\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != address(0));\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(rate);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal view returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public view returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title FinalizableCrowdsale\n', ' * @dev Extension of Crowdsale where an owner can do extra work\n', ' * after finishing.\n', ' */\n', 'contract FinalizableCrowdsale is Crowdsale, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  bool public isFinalized = false;\n', '\n', '  event Finalized();\n', '\n', '  /**\n', '   * @dev Must be called after crowdsale ends, to do some extra finalization\n', "   * work. Calls the contract's finalization function.\n", '   */\n', '  function finalize() onlyOwner public {\n', '    require(!isFinalized);\n', '    require(hasEnded());\n', '\n', '    finalization();\n', '    Finalized();\n', '\n', '    isFinalized = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Can be overridden to add finalization logic. The overriding function\n', '   * should call super.finalization() to ensure the chain of finalization is\n', '   * executed entirely.\n', '   */\n', '  function finalization() internal {\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title RefundVault\n', ' * @dev This contract is used for storing funds while a crowdsale\n', ' * is in progress. Supports refunding the money if crowdsale fails,\n', ' * and forwarding it if crowdsale is successful.\n', ' */\n', 'contract RefundVault is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  enum State { Active, Refunding, Closed }\n', '\n', '  mapping (address => uint256) public deposited;\n', '  address public wallet;\n', '  State public state;\n', '\n', '  event Closed();\n', '  event RefundsEnabled();\n', '  event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '  function RefundVault(address _wallet) public {\n', '    require(_wallet != address(0));\n', '    wallet = _wallet;\n', '    state = State.Active;\n', '  }\n', '\n', '  function deposit(address investor) onlyOwner public payable {\n', '    require(state == State.Active);\n', '    deposited[investor] = deposited[investor].add(msg.value);\n', '  }\n', '\n', '  function close() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Closed;\n', '    Closed();\n', '    wallet.transfer(this.balance);\n', '  }\n', '\n', '  function enableRefunds() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Refunding;\n', '    RefundsEnabled();\n', '  }\n', '\n', '  function refund(address investor) public {\n', '    require(state == State.Refunding);\n', '    uint256 depositedValue = deposited[investor];\n', '    deposited[investor] = 0;\n', '    investor.transfer(depositedValue);\n', '    Refunded(investor, depositedValue);\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract FreezableToken is StandardToken {\n', '    // freezing chains\n', '    mapping (bytes32 => uint64) internal chains;\n', '    // freezing amounts for each chain\n', '    mapping (bytes32 => uint) internal freezings;\n', '    // total freezing balance per address\n', '    mapping (address => uint) internal freezingBalance;\n', '\n', '    event Freezed(address indexed to, uint64 release, uint amount);\n', '    event Released(address indexed owner, uint amount);\n', '\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address include freezing tokens.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return super.balanceOf(_owner) + freezingBalance[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address without freezing tokens.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function actualBalanceOf(address _owner) public view returns (uint256 balance) {\n', '        return super.balanceOf(_owner);\n', '    }\n', '\n', '    function freezingBalanceOf(address _owner) public view returns (uint256 balance) {\n', '        return freezingBalance[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev gets freezing count\n', '     * @param _addr Address of freeze tokens owner.\n', '     */\n', '    function freezingCount(address _addr) public view returns (uint count) {\n', '        uint64 release = chains[toKey(_addr, 0)];\n', '        while (release != 0) {\n', '            count ++;\n', '            release = chains[toKey(_addr, release)];\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev gets freezing end date and freezing balance for the freezing portion specified by index.\n', '     * @param _addr Address of freeze tokens owner.\n', '     * @param _index Freezing portion index. It ordered by release date descending.\n', '     */\n', '    function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {\n', '        for (uint i = 0; i < _index + 1; i ++) {\n', '            _release = chains[toKey(_addr, _release)];\n', '            if (_release == 0) {\n', '                return;\n', '            }\n', '        }\n', '        _balance = freezings[toKey(_addr, _release)];\n', '    }\n', '\n', '    /**\n', '     * @dev freeze your tokens to the specified address.\n', '     *      Be careful, gas usage is not deterministic,\n', '     *      and depends on how many freezes _to address already has.\n', '     * @param _to Address to which token will be freeze.\n', '     * @param _amount Amount of token to freeze.\n', '     * @param _until Release date, must be in future.\n', '     */\n', '    function freezeTo(address _to, uint _amount, uint64 _until) public {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '\n', '        bytes32 currentKey = toKey(_to, _until);\n', '        freezings[currentKey] = freezings[currentKey].add(_amount);\n', '        freezingBalance[_to] = freezingBalance[_to].add(_amount);\n', '\n', '        freeze(_to, _until);\n', '        Transfer(msg.sender, _to, _amount);\n', '        Freezed(_to, _until, _amount);\n', '    }\n', '\n', '    /**\n', '     * @dev release first available freezing tokens.\n', '     */\n', '    function releaseOnce() public {\n', '        bytes32 headKey = toKey(msg.sender, 0);\n', '        uint64 head = chains[headKey];\n', '        require(head != 0);\n', '        require(uint64(block.timestamp) > head);\n', '        bytes32 currentKey = toKey(msg.sender, head);\n', '\n', '        uint64 next = chains[currentKey];\n', '\n', '        uint amount = freezings[currentKey];\n', '        delete freezings[currentKey];\n', '\n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '        freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);\n', '\n', '        if (next == 0) {\n', '            delete chains[headKey];\n', '        }\n', '        else {\n', '            chains[headKey] = next;\n', '            delete chains[currentKey];\n', '        }\n', '        Released(msg.sender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev release all available for release freezing tokens. Gas usage is not deterministic!\n', '     * @return how many tokens was released\n', '     */\n', '    function releaseAll() public returns (uint tokens) {\n', '        uint release;\n', '        uint balance;\n', '        (release, balance) = getFreezing(msg.sender, 0);\n', '        while (release != 0 && block.timestamp > release) {\n', '            releaseOnce();\n', '            tokens += balance;\n', '            (release, balance) = getFreezing(msg.sender, 0);\n', '        }\n', '    }\n', '\n', '    function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {\n', '        // WISH masc to increase entropy\n', '        result = 0x5749534800000000000000000000000000000000000000000000000000000000;\n', '        assembly {\n', '            result := or(result, mul(_addr, 0x10000000000000000))\n', '            result := or(result, _release)\n', '        }\n', '    }\n', '\n', '    function freeze(address _to, uint64 _until) internal {\n', '        require(_until > block.timestamp);\n', '        bytes32 key = toKey(_to, _until);\n', '        bytes32 parentKey = toKey(_to, uint64(0));\n', '        uint64 next = chains[parentKey];\n', '\n', '        if (next == 0) {\n', '            chains[parentKey] = _until;\n', '            return;\n', '        }\n', '\n', '        bytes32 nextKey = toKey(_to, next);\n', '        uint parent;\n', '\n', '        while (next != 0 && _until > next) {\n', '            parent = next;\n', '            parentKey = nextKey;\n', '\n', '            next = chains[nextKey];\n', '            nextKey = toKey(_to, next);\n', '        }\n', '\n', '        if (_until == next) {\n', '            return;\n', '        }\n', '\n', '        if (next != 0) {\n', '            chains[key] = next;\n', '        }\n', '\n', '        chains[parentKey] = _until;\n', '    }\n', '}\n', '\n', '/**\n', '* @title Contract that will work with ERC223 tokens.\n', '*/\n', '\n', 'contract ERC223Receiver {\n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', 'contract ERC223Basic is ERC20Basic {\n', '    function transfer(address to, uint value, bytes data) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '}\n', '\n', '\n', 'contract SuccessfulERC223Receiver is ERC223Receiver {\n', '    event Invoked(address from, uint value, bytes data);\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) public {\n', '        Invoked(_from, _value, _data);\n', '    }\n', '}\n', '\n', 'contract FailingERC223Receiver is ERC223Receiver {\n', '    function tokenFallback(address, uint, bytes) public {\n', '        revert();\n', '    }\n', '}\n', '\n', 'contract ERC223ReceiverWithoutTokenFallback {\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract FreezableMintableToken is FreezableToken, MintableToken {\n', '    /**\n', '     * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.\n', '     *      Be careful, gas usage is not deterministic,\n', '     *      and depends on how many freezes _to address already has.\n', '     * @param _to Address to which token will be freeze.\n', '     * @param _amount Amount of token to mint and freeze.\n', '     * @param _until Release date, must be in future.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mintAndFreeze(address _to, uint _amount, uint64 _until) onlyOwner canMint public returns (bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '\n', '        bytes32 currentKey = toKey(_to, _until);\n', '        freezings[currentKey] = freezings[currentKey].add(_amount);\n', '        freezingBalance[_to] = freezingBalance[_to].add(_amount);\n', '\n', '        freeze(_to, _until);\n', '        Mint(_to, _amount);\n', '        Freezed(_to, _until, _amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Consts {\n', '    uint constant TOKEN_DECIMALS = 18;\n', '    uint8 constant TOKEN_DECIMALS_UINT8 = 18;\n', '    uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;\n', '\n', '    string constant TOKEN_NAME = "token22";\n', '    string constant TOKEN_SYMBOL = "token22";\n', '    bool constant PAUSED = true;\n', '    address constant TARGET_USER = 0x008024069546651883a2b948AE67b345D7c42B19;\n', '    \n', '    uint constant START_TIME = 1524839861;\n', '    \n', '    bool constant CONTINUE_MINTING = false;\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Reference implementation of the ERC223 standard token.\n', ' */\n', 'contract ERC223Token is ERC223Basic, BasicToken, FailingERC223Receiver {\n', '    using SafeMath for uint;\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      Invokes the `tokenFallback` function if the recipient is a contract.\n', '     *      The token transfer fails if the recipient is a contract\n', '     *      but does not implement the `tokenFallback` function\n', '     *      or the fallback function to receive funds.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool) {\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly.\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength > 0) {\n', '            ERC223Receiver receiver = ERC223Receiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      This function works the same with the previous one\n', "     *      but doesn't contain `_data` param.\n", '     *      Added due to backwards compatibility reasons.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        bytes memory empty;\n', '        return transfer(_to, _value, empty);\n', '    }\n', '}\n', '\n', '\n', 'contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable\n', '    \n', '{\n', '    \n', '\n', '    function name() pure public returns (string _name) {\n', '        return TOKEN_NAME;\n', '    }\n', '\n', '    function symbol() pure public returns (string _symbol) {\n', '        return TOKEN_SYMBOL;\n', '    }\n', '\n', '    function decimals() pure public returns (uint8 _decimals) {\n', '        return TOKEN_DECIMALS_UINT8;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {\n', '        require(!paused);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool _success) {\n', '        require(!paused);\n', '        return super.transfer(_to, _value);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title CappedCrowdsale\n', ' * @dev Extension of Crowdsale with a max amount of funds raised\n', ' */\n', 'contract CappedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public cap;\n', '\n', '  function CappedCrowdsale(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can buy at the moment\n', '  function validPurchase() internal view returns (bool) {\n', '    bool withinCap = weiRaised.add(msg.value) <= cap;\n', '    return super.validPurchase() && withinCap;\n', '  }\n', '\n', '  // overriding Crowdsale#hasEnded to add cap logic\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public view returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return super.hasEnded() || capReached;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title RefundableCrowdsale\n', ' * @dev Extension of Crowdsale contract that adds a funding goal, and\n', ' * the possibility of users getting a refund if goal is not met.\n', " * Uses a RefundVault as the crowdsale's vault.\n", ' */\n', 'contract RefundableCrowdsale is FinalizableCrowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // minimum amount of funds to be raised in weis\n', '  uint256 public goal;\n', '\n', '  // refund vault used to hold funds while crowdsale is running\n', '  RefundVault public vault;\n', '\n', '  function RefundableCrowdsale(uint256 _goal) public {\n', '    require(_goal > 0);\n', '    vault = new RefundVault(wallet);\n', '    goal = _goal;\n', '  }\n', '\n', "  // We're overriding the fund forwarding from Crowdsale.\n", '  // In addition to sending the funds, we want to call\n', '  // the RefundVault deposit function\n', '  function forwardFunds() internal {\n', '    vault.deposit.value(msg.value)(msg.sender);\n', '  }\n', '\n', '  // if crowdsale is unsuccessful, investors can claim refunds here\n', '  function claimRefund() public {\n', '    require(isFinalized);\n', '    require(!goalReached());\n', '\n', '    vault.refund(msg.sender);\n', '  }\n', '\n', '  // vault finalization task, called when owner calls finalize()\n', '  function finalization() internal {\n', '    if (goalReached()) {\n', '      vault.close();\n', '    } else {\n', '      vault.enableRefunds();\n', '    }\n', '\n', '    super.finalization();\n', '  }\n', '\n', '  function goalReached() public view returns (bool) {\n', '    return weiRaised >= goal;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract MainCrowdsale is Consts, FinalizableCrowdsale {\n', '    function hasStarted() public constant returns (bool) {\n', '        return now >= startTime;\n', '    }\n', '\n', '    function finalization() internal {\n', '        super.finalization();\n', '\n', '        if (PAUSED) {\n', '            MainToken(token).unpause();\n', '        }\n', '\n', '        if (!CONTINUE_MINTING) {\n', '            token.finishMinting();\n', '        }\n', '\n', '        token.transferOwnership(TARGET_USER);\n', '    }\n', '\n', '    function buyTokens(address beneficiary) public payable {\n', '        require(beneficiary != address(0));\n', '        require(validPurchase());\n', '\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = weiAmount.mul(rate).div(1 ether);\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        token.mint(beneficiary, tokens);\n', '        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '        forwardFunds();\n', '    }\n', '}\n', '\n', '\n', 'contract Checkable {\n', '    address private serviceAccount;\n', '    /**\n', '     * Flag means that contract accident already occurs.\n', '     */\n', '    bool private triggered = false;\n', '\n', '    /**\n', '     * Occurs when accident happened.\n', '     */\n', '    event Triggered(uint balance);\n', '    /**\n', '     * Occurs when check finished.\n', '     */\n', '    event Checked(bool isAccident);\n', '\n', '    function Checkable() public {\n', '        serviceAccount = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Replace service account with new one.\n', '     * @param _account Valid service account address.\n', '     */\n', '    function changeServiceAccount(address _account) onlyService public {\n', '        assert(_account != 0);\n', '        serviceAccount = _account;\n', '    }\n', '\n', '    /**\n', '     * @dev Is caller (sender) service account.\n', '     */\n', '    function isServiceAccount() view public returns (bool) {\n', '        return msg.sender == serviceAccount;\n', '    }\n', '\n', '    /**\n', '     * Public check method.\n', '     */\n', '    function check() onlyService notTriggered payable public {\n', '        if (internalCheck()) {\n', '            Triggered(this.balance);\n', '            triggered = true;\n', '            internalAction();\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Do inner check.\n', '     * @return bool true of accident triggered, false otherwise.\n', '     */\n', '    function internalCheck() internal returns (bool);\n', '\n', '    /**\n', '     * @dev Do inner action if check was success.\n', '     */\n', '    function internalAction() internal;\n', '\n', '    modifier onlyService {\n', '        require(msg.sender == serviceAccount);\n', '        _;\n', '    }\n', '\n', '    modifier notTriggered() {\n', '        require(!triggered);\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract BonusableCrowdsale is Consts, Crowdsale {\n', '\n', '    function buyTokens(address beneficiary) public payable {\n', '        require(beneficiary != address(0));\n', '        require(validPurchase());\n', '\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // calculate token amount to be created\n', '        uint256 bonusRate = getBonusRate(weiAmount);\n', '        uint256 tokens = weiAmount.mul(bonusRate).div(1 ether);\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        token.mint(beneficiary, tokens);\n', '        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '        forwardFunds();\n', '    }\n', '\n', '    function getBonusRate(uint256 weiAmount) internal view returns (uint256) {\n', '        uint256 bonusRate = rate;\n', '\n', '        \n', '\n', '        \n', '        // apply amount\n', '        uint[2] memory weiAmountBoundaries = [uint(10000000000000000000000),uint(12000000000000000000)];\n', '        uint[2] memory weiAmountRates = [uint(0),uint(30)];\n', '\n', '        for (uint j = 0; j < 2; j++) {\n', '            if (weiAmount >= weiAmountBoundaries[j]) {\n', '                bonusRate += bonusRate * weiAmountRates[j] / 1000;\n', '                break;\n', '            }\n', '        }\n', '        \n', '\n', '        return bonusRate;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract TemplateCrowdsale is Consts, MainCrowdsale\n', '    \n', '    , BonusableCrowdsale\n', '    \n', '    \n', '    , RefundableCrowdsale\n', '    \n', '    , CappedCrowdsale\n', '    \n', '{\n', '    event Initialized();\n', '    bool public initialized = false;\n', '\n', '    function TemplateCrowdsale(MintableToken _token) public\n', '        Crowdsale(START_TIME > now ? START_TIME : now, 1527431861, 1000 * TOKEN_DECIMAL_MULTIPLIER, 0x48f73dc45bd3714e8c79a93d7619a737260facfd)\n', '        CappedCrowdsale(10000000000000000000000)\n', '        \n', '        RefundableCrowdsale(10000000000000000000)\n', '        \n', '    {\n', '        token = _token;\n', '    }\n', '\n', '    function init() public onlyOwner {\n', '        require(!initialized);\n', '        initialized = true;\n', '\n', '        if (PAUSED) {\n', '            MainToken(token).pause();\n', '        }\n', '\n', '        \n', '\n', '        transferOwnership(TARGET_USER);\n', '\n', '        Initialized();\n', '    }\n', '\n', '    /**\n', '     * @dev override token creation to set token address in constructor.\n', '     */\n', '    function createTokenContract() internal returns (MintableToken) {\n', '        return MintableToken(0);\n', '    }\n', '\n', '    \n', '\n', '    \n', '\n', '    \n', '\n', '}']
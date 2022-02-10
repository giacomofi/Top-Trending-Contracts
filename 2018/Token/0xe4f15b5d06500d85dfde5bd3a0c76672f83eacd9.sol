['pragma solidity ^0.4.18;\n', '\n', '// File: contracts/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/MintableToken.sol\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: contracts/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '// File: contracts/CanReclaimToken.sol\n', '\n', '/**\n', ' * @title Contracts that should be able to recover tokens\n', ' * @author SylTi\n', ' * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.\n', ' * This will prevent any accidental loss of tokens.\n', ' */\n', 'contract CanReclaimToken is Ownable {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  /**\n', '   * @dev Reclaim all ERC20Basic compatible tokens\n', '   * @param token ERC20Basic The address of the token contract\n', '   */\n', '  function reclaimToken(ERC20Basic token) external onlyOwner {\n', '    uint256 balance = token.balanceOf(this);\n', '    token.safeTransfer(owner, balance);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/HasNoTokens.sol\n', '\n', '/**\n', ' * @title Contracts that should not own Tokens\n', ' * @author Remco Bloemen <remco@2π.com>\n', ' * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.\n', ' * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the\n', ' * owner to reclaim the tokens.\n', ' */\n', 'contract HasNoTokens is CanReclaimToken {\n', '\n', ' /**\n', '  * @dev Reject all ERC223 compatible tokens\n', '  * @param from_ address The address that is transferring the tokens\n', '  * @param value_ uint256 the amount of the specified token\n', '  * @param data_ Bytes The data passed from the caller.\n', '  */\n', '  function tokenFallback(address from_, uint256 value_, bytes data_) external pure {\n', '    from_;\n', '    value_;\n', '    data_;\n', '    revert();\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/Vesting.sol\n', '\n', '/**\n', ' * @title Standalone Vesting  logic to be added in token\n', ' * @dev Beneficiary can have at most one VestingGrant only, we do not support adding two vesting grants of vesting grant to same address.\n', ' *      Token transfer related logic is not handled in this class for simplicity and modularity purpose\n', ' */\n', 'contract Vesting {\n', '  using SafeMath for uint256;\n', '\n', '  struct VestingGrant {\n', '    uint256 grantedAmount;       // 32 bytes\n', '    uint64 start;\n', '    uint64 cliff;\n', '    uint64 vesting;             // 3 * 8 = 24 bytes\n', '  } // total 56 bytes = 2 sstore per operation (32 per sstore)\n', '\n', '  mapping (address => VestingGrant) public grants;\n', '\n', '  event VestingGrantSet(address indexed to, uint256 grantedAmount, uint64 vesting);\n', '\n', '  function getVestingGrantAmount(address _to) public view returns (uint256) {\n', '    return grants[_to].grantedAmount;\n', '  }\n', '\n', '  /**\n', '   * @dev Set vesting grant to a specified address\n', '   * @param _to address The address which the vesting amount will be granted to.\n', '   * @param _grantedAmount uint256 The amount to be granted.\n', '   * @param _start uint64 Time of the beginning of the grant.\n', '   * @param _cliff uint64 Time of the cliff period.\n', '   * @param _vesting uint64 The vesting period.\n', '   * @param _override bool Must be true if you are overriding vesting grant that has been set before\n', '   *          this is to prevent accidental overwriting vesting grant\n', '   */\n', '  function setVestingGrant(address _to, uint256 _grantedAmount, uint64 _start, uint64 _cliff, uint64 _vesting, bool _override) public {\n', '\n', '    // Check for date inconsistencies that may cause unexpected behavior\n', '    require(_cliff >= _start && _vesting >= _cliff);\n', '    // only one vesting logic per address, and once set to update _override flag is required\n', '    require(grants[_to].grantedAmount == 0 || _override);\n', '    grants[_to] = VestingGrant(_grantedAmount, _start, _cliff, _vesting);\n', '\n', '    VestingGrantSet(_to, _grantedAmount, _vesting);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate amount of vested amounts at a specific time (monthly graded)\n', '   * @param grantedAmount uint256 The amount of amounts granted\n', '   * @param time uint64 The time to be checked\n', '   * @param start uint64 The time representing the beginning of the grant\n', '   * @param cliff uint64  The cliff period, the period before nothing can be paid out\n', '   * @param vesting uint64 The vesting period\n', '   * @return An uint256 representing the vested amounts\n', '   *   |                         _/--------   vestedTokens rect\n', '   *   |                       _/\n', '   *   |                     _/\n', '   *   |                   _/\n', '   *   |                 _/\n', '   *   |                /\n', '   *   |              .|\n', '   *   |            .  |\n', '   *   |          .    |\n', '   *   |        .      |\n', '   *   |      .        |\n', '   *   |    .          |\n', '   *   +===+===========+---------+----------> time\n', '   *      Start       Cliff    Vesting\n', '   */\n', '  function calculateVested (\n', '    uint256 grantedAmount,\n', '    uint256 time,\n', '    uint256 start,\n', '    uint256 cliff,\n', '    uint256 vesting) internal pure returns (uint256)\n', '    {\n', '      // Shortcuts for before cliff and after vesting cases.\n', '      if (time < cliff) return 0;\n', '      if (time >= vesting) return grantedAmount;\n', '\n', '      // Interpolate all vested amounts.\n', '      // As before cliff the shortcut returns 0, we can use just calculate a value\n', "      // in the vesting rect (as shown in above's figure)\n", '\n', '      // vestedAmounts = (grantedAmount * (time - start)) / (vesting - start)   <-- this is the original formula\n', '      // vestedAmounts = (grantedAmount * ( (time - start) / (30 days) ) / ( (vesting - start) / (30 days) )   <-- this is made\n', '\n', '      uint256 vestedAmounts = grantedAmount.mul(time.sub(start).div(30 days)).div(vesting.sub(start).div(30 days));\n', '\n', '      //if (vestedAmounts > grantedAmount) return amounts; // there is no possible case where this is true\n', '\n', '      return vestedAmounts;\n', '  }\n', '\n', '  function calculateLocked (\n', '    uint256 grantedAmount,\n', '    uint256 time,\n', '    uint256 start,\n', '    uint256 cliff,\n', '    uint256 vesting) internal pure returns (uint256)\n', '    {\n', '      return grantedAmount.sub(calculateVested(grantedAmount, time, start, cliff, vesting));\n', '    }\n', '\n', '  /**\n', '   * @dev Gets the locked amount of a given beneficiary, ie. non vested amount, at a specific time.\n', '   * @param _to The beneficiary to be checked.\n', '   * @param _time uint64 The time to be checked\n', '   * @return An uint256 representing the non vested amounts of a specific grant on the\n', '   * passed time frame.\n', '   */\n', '  function getLockedAmountOf(address _to, uint256 _time) public view returns (uint256) {\n', '    VestingGrant storage grant = grants[_to];\n', '    if (grant.grantedAmount == 0) return 0;\n', '    return calculateLocked(grant.grantedAmount, uint256(_time), uint256(grant.start),\n', '      uint256(grant.cliff), uint256(grant.vesting));\n', '  }\n', '\n', '\n', '}\n', '\n', '// File: contracts/DirectToken.sol\n', '\n', 'contract DirectToken is MintableToken, HasNoTokens, Vesting {\n', '\n', '  string public constant name = "DIREC";\n', '  string public constant symbol = "DIR";\n', '  uint8 public constant decimals = 18;\n', '\n', '  bool public tradingStarted = false;   // target is TRADING_START date = 1533081600; // 2018-08-01 00:00:00 UTC\n', '\n', '  /**\n', '   * @dev Allows the owner to enable the trading.\n', '   */\n', '  function setTradingStarted(bool _tradingStarted) public onlyOwner {\n', '    tradingStarted = _tradingStarted;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows anyone to transfer the PAY tokens once trading has started\n', '   * @param _to the recipient address of the tokens.\n', '   * @param _value number of tokens to be transfered.\n', '   */\n', '  function transfer(address _to, uint256 _value) public returns (bool success) {\n', '    checkTransferAllowed(msg.sender, _to, _value);\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '   /**\n', '   * @dev Allows anyone to transfer the PAY tokens once trading has started\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '    checkTransferAllowed(msg.sender, _to, _value);\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * Throws if the transfer not allowed due to minting not finished, trading not started, or vesting\n', '   *   this should be called at the top of transfer functions and so as to refund unused gas\n', '   */\n', '  function checkTransferAllowed(address _sender, address _to, uint256 _value) private view {\n', '      if (mintingFinished && tradingStarted && isAllowableTransferAmount(_sender, _value)) {\n', '          // Everybody can transfer once the token is finalized and trading has started and is within allowable vested amount if applicable\n', '          return;\n', '      }\n', '\n', '      // Owner is allowed to transfer tokens before the sale is finalized.\n', '      // This allows the tokens to move from the TokenSale contract to a beneficiary.\n', '      // We also allow someone to send tokens back to the owner. This is useful among other\n', '      // cases, reclaimTokens etc.\n', '      require(_sender == owner || _to == owner);\n', '  }\n', '\n', '  function setVestingGrant(address _to, uint256 _grantedAmount, uint64 _start, uint64 _cliff, uint64 _vesting, bool _override) public onlyOwner {\n', '    return super.setVestingGrant(_to, _grantedAmount, _start, _cliff, _vesting, _override);\n', '  }\n', '\n', '  function isAllowableTransferAmount(address _sender, uint256 _value) private view returns (bool allowed) {\n', '     if (getVestingGrantAmount(_sender) == 0) {\n', '        return true;\n', '     }\n', '     // the address has vesting grant set, he can transfer up to the amount that vested\n', '     uint256 transferableAmount = balanceOf(_sender).sub(getLockedAmountOf(_sender, now));\n', '     return (_value <= transferableAmount);\n', '  }\n', '\n', '}']
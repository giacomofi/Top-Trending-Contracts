['pragma solidity ^0.4.19;\n', '\n', '\n', '\n', '/* ************************************************ */\n', '/* ********** Zeppelin Solidity - v1.5.0 ********** */\n', '/* ************************************************ */\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '\n', '\n', '/* *********************************** */\n', '/* ********** Xmoneta Token ********** */\n', '/* *********************************** */\n', '\n', '\n', '\n', '/**\n', ' * @title XmonetaToken\n', ' * @author Xmoneta.com\n', ' *\n', ' * ERC20 Compatible token\n', ' * Zeppelin Solidity - v1.5.0\n', ' */\n', '\n', 'contract XmonetaToken is StandardToken, Claimable {\n', '\n', '  /* ********** Token Predefined Information ********** */\n', '\n', '  string public constant name = "Xmoneta Token";\n', '  string public constant symbol = "XMN";\n', '  uint256 public constant decimals = 18;\n', '\n', '  /* ********** Defined Variables ********** */\n', '\n', '  // Total tokens supply 1 000 000 000\n', '  // For ethereum wallets we added decimals constant\n', '  uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** decimals);\n', '  // Vault where tokens are stored\n', '  address public vault = msg.sender;\n', '  // Sales agent who has permissions to manipulate with tokens\n', '  address public salesAgent;\n', '\n', '  /* ********** Events ********** */\n', '\n', '  event SalesAgentAppointed(address indexed previousSalesAgent, address indexed newSalesAgent);\n', '  event SalesAgentRemoved(address indexed currentSalesAgent);\n', '  event Burn(uint256 valueToBurn);\n', '\n', '  /* ********** Functions ********** */\n', '\n', '  // Contract constructor\n', '  function XmonetaToken() public {\n', '    owner = msg.sender;\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[vault] = totalSupply;\n', '  }\n', '\n', '  // Appoint sales agent of token\n', '  function setSalesAgent(address newSalesAgent) onlyOwner public {\n', '    SalesAgentAppointed(salesAgent, newSalesAgent);\n', '    salesAgent = newSalesAgent;\n', '  }\n', '\n', '  // Remove sales agent from token\n', '  function removeSalesAgent() onlyOwner public {\n', '    SalesAgentRemoved(salesAgent);\n', '    salesAgent = address(0);\n', '  }\n', '\n', '  // Transfer tokens from vault to account if sales agent is correct\n', '  function transferTokensFromVault(address fromAddress, address toAddress, uint256 tokensAmount) public {\n', '    require(salesAgent == msg.sender);\n', '    balances[vault] = balances[vault].sub(tokensAmount);\n', '    balances[toAddress] = balances[toAddress].add(tokensAmount);\n', '    Transfer(fromAddress, toAddress, tokensAmount);\n', '  }\n', '\n', '  // Allow the owner to burn a specific amount of tokens from the vault\n', '  function burn(uint256 valueToBurn) onlyOwner public {\n', '    require(valueToBurn > 0);\n', '    balances[vault] = balances[vault].sub(valueToBurn);\n', '    totalSupply = totalSupply.sub(valueToBurn);\n', '    Burn(valueToBurn);\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/* ************************************** */\n', '/* ********** Xmoneta Pre-sale ********** */\n', '/* ************************************** */\n', '\n', '\n', '\n', '/**\n', ' * @title XmonetaPresale\n', ' * @author Xmoneta.com\n', ' *\n', ' * Zeppelin Solidity - v1.5.0\n', ' */\n', '\n', 'contract XmonetaPresale {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  /* ********** Defined Variables ********** */\n', '\n', '  // The token being sold\n', '  XmonetaToken public token;\n', '  // Crowdsale start timestamp - 01/25/2018 at 12:00pm (UTC)\n', '  uint256 public startTime = 1516881600;\n', '  // Crowdsale end timestamp - 02/15/2018 at 12:00pm (UTC)\n', '  uint256 public endTime = 1519560000;\n', '  // Addresses where ETH are collected\n', '  address public wallet1 = 0x36A3c000f8a3dC37FCD261D1844efAF851F81556;\n', '  address public wallet2 = 0x8beDBE45Aa345938d70388E381E2B6199A15B3C3;\n', '  // How many token per wei\n', '  uint256 public rate = 2000;\n', '  // Cap in ethers\n', '  uint256 public cap = 16000 * 1 ether;\n', '  // Amount of raised wei\n', '  uint256 public weiRaised;\n', '\n', '  /* ********** Events ********** */\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 weiAmount, uint256 tokens);\n', '\n', '  /* ********** Functions ********** */\n', '\n', '  // Contract constructor\n', '  function XmonetaPresale() public {\n', '    token = XmonetaToken(0x99705A8B60d0fE21A4B8ee54DB361B3C573D18bb);\n', '  }\n', '\n', '  // Fallback function to buy tokens\n', '  function () public payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // Token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // Send spare wei back if investor sent more that cap\n', '    uint256 tempWeiRaised = weiRaised.add(weiAmount);\n', '    if (tempWeiRaised > cap) {\n', '      uint256 spareWeis = tempWeiRaised.sub(cap);\n', '      weiAmount = weiAmount.sub(spareWeis);\n', '      beneficiary.transfer(spareWeis);\n', '    }\n', '\n', '    // Current pre-sale bonus is 30%\n', '    uint256 bonusPercent = 30;\n', '\n', '    // If buyer send 5 or more ethers then bonus will be 50%\n', '    if (weiAmount >= 5 ether) {\n', '      bonusPercent = 50;\n', '    }\n', '\n', '    uint256 additionalPercentInWei = rate.div(100).mul(bonusPercent);\n', '    uint256 rateWithPercents = rate.add(additionalPercentInWei);\n', '\n', '    // Calculate token amount to be sold\n', '    uint256 tokens = weiAmount.mul(rateWithPercents);\n', '\n', '    // Update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    // Tranfer tokens from vault\n', '    token.transferTokensFromVault(msg.sender, beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds(weiAmount);\n', '  }\n', '\n', '  // Send wei to the fund collection wallets\n', '  function forwardFunds(uint256 weiAmount) internal {\n', '    uint256 value = weiAmount.div(2);\n', '\n', '    // If buyer send amount of wei that can not be divided to 2 without float point, send all weis to first wallet\n', '    if (value.mul(2) != weiAmount) {\n', '      wallet1.transfer(weiAmount);\n', '    } else {\n', '      wallet1.transfer(value);\n', '      wallet2.transfer(value);\n', '    }\n', '  }\n', '\n', '  // Validate if the transaction can be success\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinCap = weiRaised < cap;\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase && withinCap;\n', '  }\n', '\n', '  // Show if crowdsale has ended or no\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime || weiRaised >= cap;\n', '  }\n', '\n', '}']
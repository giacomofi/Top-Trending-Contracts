['pragma solidity 0.4.18;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control \n', ' * functions, this simplifies the implementation of "user permissions". \n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    require (msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Authorizable\n', ' * @dev Allows to authorize access to certain function calls\n', ' * \n', ' * ABI\n', ' * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]\n', ' */\n', 'contract Authorizable {\n', '\n', '  address[] authorizers;\n', '  mapping(address => uint) authorizerIndex;\n', '\n', '  /**\n', '   * @dev Throws if called by any account tat is not authorized. \n', '   */\n', '  modifier onlyAuthorized {\n', '    require(isAuthorized(msg.sender));\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Contructor that authorizes the msg.sender. \n', '   */\n', '  function Authorizable() public {\n', '    authorizers.length = 2;\n', '    authorizers[1] = msg.sender;\n', '    authorizerIndex[msg.sender] = 1;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to get a specific authorizer\n', '   * @param authorizerIndex index of the authorizer to be retrieved.\n', '   * @return The address of the authorizer.\n', '   */\n', '  function getAuthorizer(uint authorizerIndex) external constant returns(address) {\n', '    return address(authorizers[authorizerIndex + 1]);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check if an address is authorized\n', '   * @param _addr the address to check if it is authorized.\n', '   * @return boolean flag if address is authorized.\n', '   */\n', '  function isAuthorized(address _addr) public constant returns(bool) {\n', '    return authorizerIndex[_addr] > 0;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to add a new authorizer\n', '   * @param _addr the address to add as a new authorizer.\n', '   */\n', '  function addAuthorized(address _addr) external onlyAuthorized {\n', '    authorizerIndex[_addr] = authorizers.length;\n', '    authorizers.length++;\n', '    authorizers[authorizers.length - 1] = _addr;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ExchangeRate\n', ' * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens\n', ' *\n', ' * ABI\n', ' * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]\n', ' */\n', 'contract ExchangeRate is Ownable {\n', ' \n', '  event RateUpdated(uint timestamp, bytes32 symbol, uint rate);\n', '\n', '  mapping(bytes32 => uint) public rates;\n', '\n', '  /**\n', '   * @dev Allows the current owner to update a single rate.\n', '   * @param _symbol The symbol to be updated. \n', '   * @param _rate the rate for the symbol. \n', '   */\n', '  function updateRate(string _symbol, uint _rate) public onlyOwner {\n', '    rates[keccak256(_symbol)] = _rate;\n', '    RateUpdated(now, keccak256(_symbol), _rate);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to update multiple rates.\n', '   * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate . \n', '   */\n', '  function updateRates(uint[] data) public onlyOwner {\n', '    require (data.length % 2 <= 0);\n', '    uint i = 0;\n', '    while (i < data.length / 2) {\n', '      bytes32 symbol = bytes32(data[i * 2]);\n', '      uint rate = data[i * 2 + 1];\n', '      rates[symbol] = rate;\n', '      RateUpdated(now, symbol, rate);\n', '      i++;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the anyone to read the current rate.\n', '   * @param _symbol the symbol to be retrieved. \n', '   */\n', '  function getRate(string _symbol) public constant returns(uint) {\n', '    return rates[keccak256(_symbol)];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    require(assertion);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint);\n', '  function transfer(address to, uint value) public;\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '} \n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  /**\n', '   * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     require (size + 4 <= msg.data.length);\n', '     _;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implemantation of the basic standart token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint _value) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint value);\n', '  event MintFinished();\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  bool public mintingFinished = false;\n', '  uint public totalSupply = 0;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '   \n', '  \n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(address _who, uint256 _value) onlyOwner public {\n', '    _burn(_who, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    Burn(_who, _value);\n', '    Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title CBCToken\n', ' * @dev The main CBC token contract\n', ' * \n', ' * ABI \n', ' * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]\n', ' */\n', 'contract CBCToken is MintableToken {\n', '\n', '  string public name = "Crypto Boss Coin";\n', '  string public symbol = "CBC";\n', '  uint public decimals = 18;\n', '\n', '  bool public tradingStarted = false;\n', '  /**\n', '   * @dev modifier that throws if trading has not started yet\n', '   */\n', '  modifier hasStartedTrading() {\n', '    require(tradingStarted);\n', '    _;\n', '  }\n', ' \n', '\n', '  /**\n', '   * @dev Allows the owner to enable the trading. This can not be undone\n', '   */\n', '  function startTrading() onlyOwner {\n', '    tradingStarted = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows anyone to transfer the PAY tokens once trading has started\n', '   * @param _to the recipient address of the tokens. \n', '   * @param _value number of tokens to be transfered. \n', '   */\n', '  function transfer(address _to, uint _value) hasStartedTrading {\n', '    super.transfer(_to, _value);\n', '  }\n', '\n', '   /**\n', '   * @dev Allows anyone to transfer the CBC tokens once trading has started\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint _value) hasStartedTrading {\n', '    super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title MainSale\n', ' * @dev The main CBC token sale contract\n', ' * \n', ' * ABI\n', ' * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":!1,"inputs":[{"name":"victim","type":"address"},{"name":"amount","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":!1,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]\n', ' */\n', 'contract MainSale is Ownable, Authorizable {\n', '  using SafeMath for uint;\n', '  event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);\n', '  event AuthorizedCreate(address recipient, uint pay_amount);\n', '  event AuthorizedBurn(address receiver, uint value);\n', '  event AuthorizedStartTrading();\n', '  event MainSaleClosed();\n', '  CBCToken public token = new CBCToken();\n', '\n', '  address public multisigVault;\n', '\n', '  uint hardcap = 100000000000000 ether;\n', '  ExchangeRate public exchangeRate;\n', '\n', '  uint public altDeposits = 0;\n', '  uint public start = 1525996800;\n', '\n', '  /**\n', '   * @dev modifier to allow token creation only when the sale IS ON\n', '   */\n', '  modifier saleIsOn() {\n', '    require(now > start && now < start + 28 days);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow token creation only when the hardcap has not been reached\n', '   */\n', '  modifier isUnderHardCap() {\n', '    require(multisigVault.balance + altDeposits <= hardcap);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows anyone to create tokens by depositing ether.\n', '   * @param recipient the recipient to receive tokens. \n', '   */\n', '  function createTokens(address recipient) public isUnderHardCap saleIsOn payable {\n', '    uint rate = exchangeRate.getRate("ETH");\n', '    uint tokens = rate.mul(msg.value).div(1 ether);\n', '    token.mint(recipient, tokens);\n', '    require(multisigVault.send(msg.value));\n', '    TokenSold(recipient, msg.value, tokens, rate);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits\n', '   * @param totalAltDeposits total amount ETH equivalent\n', '   */\n', '  function setAltDeposit(uint totalAltDeposits) public onlyOwner {\n', '    altDeposits = totalAltDeposits;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits\n', '   * @param recipient the recipient to receive tokens.\n', '   * @param tokens number of tokens to be created. \n', '   */\n', '  function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {\n', '    token.mint(recipient, tokens);\n', '    AuthorizedCreate(recipient, tokens);\n', '  }\n', '  \n', '  function authorizedStartTrading() public onlyAuthorized {\n', '    token.startTrading();\n', '    AuthorizedStartTrading();\n', '  }\n', '  \n', '  /**\n', '   * @dev Allows authorized acces to burn tokens.\n', '   * @param receiver the receiver to receive tokens.\n', '   * @param value number of tokens to be created. \n', '   */\n', '  function authorizedBurnTokens(address receiver, uint value) public onlyAuthorized {\n', '    token.burn(receiver, value);\n', '    AuthorizedBurn(receiver, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to set the hardcap.\n', '   * @param _hardcap the new hardcap\n', '   */\n', '  function setHardCap(uint _hardcap) public onlyOwner {\n', '    hardcap = _hardcap;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to set the starting time.\n', '   * @param _start the new _start\n', '   */\n', '  function setStart(uint _start) public onlyOwner {\n', '    start = _start;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to set the multisig contract.\n', '   * @param _multisigVault the multisig contract address\n', '   */\n', '  function setMultisigVault(address _multisigVault) public onlyOwner {\n', '    if (_multisigVault != address(0)) {\n', '      multisigVault = _multisigVault;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to set the exchangerate contract.\n', '   * @param _exchangeRate the exchangerate address\n', '   */\n', '  function setExchangeRate(address _exchangeRate) public onlyOwner {\n', '    exchangeRate = ExchangeRate(_exchangeRate);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to finish the minting. This will create the \n', '   * restricted tokens and then close the minting.\n', '   * Then the ownership of the PAY token contract is transfered \n', '   * to this owner.\n', '   */\n', '  function finishMinting() public onlyOwner {\n', '    uint issuedTokenSupply = token.totalSupply();\n', '    uint restrictedTokens = issuedTokenSupply.mul(49).div(51);\n', '    token.mint(multisigVault, restrictedTokens);\n', '    token.finishMinting();\n', '    token.transferOwnership(owner);\n', '    MainSaleClosed();\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault\n', '   * @param _token the contract address of the ERC20 contract\n', '   */\n', '  function retrieveTokens(address _token) public onlyOwner {\n', '    ERC20 token = ERC20(_token);\n', '    token.transfer(multisigVault, token.balanceOf(this));\n', '  }\n', '  \n', '  /**\n', '   * @dev Fallback function which receives ether and created the appropriate number of tokens for the \n', '   * msg.sender.\n', '   */\n', '  function() external payable {\n', '    createTokens(msg.sender);\n', '  }\n', '\n', '}']
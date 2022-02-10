['pragma solidity ^0.4.16;\n', ' \n', '/* \n', '   Эквивалент белорусского рубля BYN,\n', '  cвободно конвертируемый в любые платежи по Беларуси через ЕРИП\n', '   и в балансы операторов сотовой связи Беларуси.\n', '   1 BYN (Belorussian Rubble) = 1 BYN в системе ЕРИП.\n', '   Комиссии при транзакциях (переводах) данного эквивалента уплачиваются сторонним майнерам Ethereum в валюте ETH, так как основаны на самом надежном блокчейне Ethereum\n', '   \n', '   Система не направлена на получении какой-либо прибыли, действует на некоммерческой основе. \n', '   Нет комиссий или иных способов получения прибыли пользователями или создателями системы.\n', '   Токен  1 BYN (Belorussian Rubble) не является ни денежным суррогатом, ни ценной бумагой.\n', '  BYN (Belorussian Rubble) - это учетная единица имеющихся у участников системы свободных средств в системе ЕРИП.\n', '  Покупка или продажа токенов системы  BYN (Belorussian Rubble) является покупкой или продажей белорусских рублей в системе ЕРИП. \n', '  Контракт системы хранится на серверах блокчейна Ethereum и не подлежит изменению, редактированию  ввиду невозможности редактирования истории изменений состояния блокчейна.\n', '  Переводы внутри системы невозможно отменить, вернуть или невозможно закрыть каким-либо участникам права на использование системы.\n', '  У системы нет ни модератора, ни хозяина, создана для благотворительных целей без целей извлечения какой-либо прибыли. Участники системы действуют на добровольной основе, самостоятельно и без необходимости согласия создателями системы. \n', '  BYN (Belorussian Rubble) является смартконтрактом (скрпитом) на блокчейне и не подлежит регулированию. \n', '  \n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', ' \n', '/*\n', '   ERC20 interface\n', '  see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', ' \n', '/*  SafeMath - the lowest gas library\n', '  Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', ' \n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', ' \n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', ' \n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', ' \n', '/*\n', 'Basic token\n', ' Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    \n', '  using SafeMath for uint256;\n', ' \n', '  mapping(address => uint256) balances;\n', ' \n', ' function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', ' \n', '  /*\n', '  Gets the balance of the specified address.\n', '   param _owner The address to query the the balance of. \n', '   return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', ' \n', '}\n', ' \n', '/* Implementation of the basic standard token.\n', '  https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', ' \n', '  mapping (address => mapping (address => uint256)) allowed;\n', ' \n', '  /*\n', '    Transfer tokens from one address to another\n', '    param _from address The address which you want to send tokens from\n', '    param _to address The address which you want to transfer to\n', '    param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', ' \n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', ' \n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', ' \n', '  /*\n', '  Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   param _spender The address which will spend the funds.\n', '   param _value The amount of Roman Lanskoj&#39;s tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', ' \n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', ' \n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', ' \n', '  /*\n', '  Function to check the amount of tokens that an owner allowed to a spender.\n', '  param _owner address The address which owns the funds.\n', '  param _spender address The address which will spend the funds.\n', '  return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '}\n', '}\n', ' \n', '/*\n', 'The Ownable contract has an owner address, and provides basic authorization control\n', ' functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', ' \n', ' \n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', ' \n', '  /*\n', '  Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', ' \n', '  /*\n', '  Allows the current owner to transfer control of the contract to a newOwner.\n', '  param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', ' \n', '}\n', ' \n', 'contract TheLiquidToken is StandardToken, Ownable {\n', '    // mint can be finished and token become fixed for forever\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '  bool mintingFinished = false;\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', ' \n', ' function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', ' \n', '  /*\n', '  Function to stop minting new tokens.\n', '  return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {}\n', '  \n', '  function burn(uint _value)\n', '        public\n', '    {\n', '        require(_value > 0);\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '\n', '    event Burn(address indexed burner, uint indexed value);\n', '  \n', '}\n', '    \n', 'contract BYN is TheLiquidToken {\n', '  string public constant name = "Belorussian Rubble";\n', '  string public constant symbol = "BYN";\n', '  uint public constant decimals = 2;\n', '  uint256 public initialSupply;\n', '    \n', '  function BYN () { \n', '     totalSupply = 1200 * 10 ** decimals;\n', '      balances[msg.sender] = totalSupply;\n', '      initialSupply = totalSupply; \n', '        Transfer(0, this, totalSupply);\n', '        Transfer(this, msg.sender, totalSupply);\n', '  }\n', '}']
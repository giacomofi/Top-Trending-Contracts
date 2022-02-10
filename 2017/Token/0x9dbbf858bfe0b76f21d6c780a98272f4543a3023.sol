['pragma solidity ^0.4.13;\n', ' \n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    \n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    \n', '  event Mint(address indexed to, uint256 amount);\n', '  \n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '  \n', '}\n', '\n', 'contract RomanovEmpireTokenCoin is MintableToken {\n', '    \n', '    string public constant name = " Romanov Empire Imperium Token";\n', '    \n', '    string public constant symbol = "REI";\n', '    \n', '    uint32 public constant decimals = 0;\n', '    \n', '}\n', '\n', '\n', 'contract Crowdsale is Ownable {\n', '    \n', '    using SafeMath for uint;\n', '    \n', '    address multisig;\n', '    \n', '    address manager;\n', '\n', '    uint restrictedPercent;\n', '\n', '    address restricted;\n', '\n', '    RomanovEmpireTokenCoin public token = new RomanovEmpireTokenCoin();\n', '\n', '    uint start;\n', '\n', '    uint preIcoEnd;\n', '    \n', '    uint preICOhardcap;\n', '\n', '    uint public ETHUSD;\n', '    \n', '    uint public hardcapUSD;\n', '    \n', '    uint public collectedFunds;\n', '    \n', '    bool pause;\n', '\n', '    function Crowdsale() {\n', '        //кошелек на который зачисляются средства\n', '        multisig = 0x1e129862b37Fe605Ef2099022F497caab7Db194c;//msg.sender;\n', '        //кошелек куда будет перечислен процент наших токенов\n', '        restricted = 0x1e129862b37Fe605Ef2099022F497caab7Db194c;//msg.sender;\n', '        //адрес кошелька управляющего контрактом\n', '        manager = msg.sender;\n', '        //процент, от проданных токенов, который мы оставляем себе \n', '        restrictedPercent = 1200;\n', '        //курс эфира к токенам \n', '        ETHUSD = 70000;\n', '        //время старта  \n', '        start = now;\n', '\t//время завершения prICO\n', '        preIcoEnd = 1546300800; //Tue, 01 Jan 2019 00:00:00 GMT\n', '        //период ICO в минутах\n', '        //period = 25;\n', '        //максимальное число сбора в токенах на PreICO\n', '        preICOhardcap = 42000;\t\t\n', '        //максимальное число сбора в токенах\n', '        //hardcap = 42000;\n', '        //максимальное число сбора в центах\n', '        hardcapUSD = 500000000;\n', '        //собрано средство в центах\n', '        collectedFunds = 0;\n', '        //пауза \n', '        pause = false;\n', '    }\n', '\n', '    modifier saleIsOn() {\n', '    \trequire(now > start && now < preIcoEnd);\n', '    \trequire(pause!=true);\n', '    \t_;\n', '    }\n', '\t\n', '    modifier isUnderHardCap() {\n', '        require(token.totalSupply() < preICOhardcap);\n', '        //если набран hardcapUSD\n', '        require(collectedFunds < hardcapUSD);\n', '        _;\n', '    }\n', '\n', '    function finishMinting() public {\n', '        require(msg.sender == manager);\n', '        \n', '        uint issuedTokenSupply = token.totalSupply();\n', '        uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(10000);\n', '        token.mint(restricted, restrictedTokens);\n', '        token.transferOwnership(restricted);\n', '    }\n', '\n', '    function createTokens() isUnderHardCap saleIsOn payable {\n', '\n', '        require(msg.value > 0);\n', '        \n', '        uint256 totalSupply = token.totalSupply();\n', '        \n', '        uint256 numTokens = 0;\n', '        uint256 summ1 = 1800000;\n', '        uint256 summ2 = 3300000;\n', '          \n', '        uint256 price1 = 18000;\n', '        uint256 price2 = 15000;\n', '        uint256 price3 = 12000;\n', '          \n', '        uint256 usdValue = msg.value.mul(ETHUSD).div(1000000000000000000);\n', '          \n', '        uint256 spendMoney = 0; \n', '        \n', '        uint256 tokenRest = 0;\n', '        uint256 rest = 0;\n', '        \n', '          require(totalSupply < preICOhardcap);\n', '          \n', '          tokenRest = preICOhardcap.sub(totalSupply);\n', '\n', '          require(tokenRest > 0);\n', '            \n', '          \n', '          if(usdValue>summ2 && tokenRest > 200 ){\n', '              numTokens = (usdValue.sub(summ2)).div(price3).add(200);\n', '              if(numTokens > tokenRest)\n', '                numTokens = tokenRest;              \n', '              spendMoney = summ2.add((numTokens.sub(200)).mul(price3));\n', '          }else if(usdValue>summ1 && tokenRest > 100 ) {\n', '              numTokens = (usdValue.sub(summ1)).div(price2).add(100);\n', '              if(numTokens > tokenRest)\n', '                numTokens = tokenRest;\n', '              spendMoney = summ1.add((numTokens.sub(100)).mul(price2));\n', '          }else {\n', '              numTokens = usdValue.div(price1);\n', '              if(numTokens > tokenRest)\n', '                numTokens = tokenRest;\n', '              spendMoney = numTokens.mul(price1);\n', '          }\n', '    \n', '          rest = (usdValue.sub(spendMoney)).mul(1000000000000000000).div(ETHUSD);\n', '    \n', '         msg.sender.transfer(rest);\n', '         if(rest<msg.value){\n', '            multisig.transfer(msg.value.sub(rest));\n', '            collectedFunds = collectedFunds + msg.value.sub(rest).mul(ETHUSD).div(1000000000000000000); \n', '         }\n', '         \n', '          token.mint(msg.sender, numTokens);\n', '          \n', '        \n', '        \n', '    }\n', '\n', '    function() external payable {\n', '        createTokens();\n', '    }\n', '\n', '    function mint(address _to, uint _value) {\n', '        require(msg.sender == manager);\n', '        token.mint(_to, _value);   \n', '    }    \n', '    \n', '    function setETHUSD( uint256 _newPrice ) {\n', '        require(msg.sender == manager);\n', '        ETHUSD = _newPrice;\n', '    }    \n', '    \n', '    function setPause( bool _newPause ) {\n', '        require(msg.sender == manager);\n', '        pause = _newPause;\n', '    }\n', '\n', '    \n', '}']
['pragma solidity ^0.4.16;\n', '\n', '/**\n', '* @title ERC20Basic\n', '* @dev Simpler version of ERC20 interface\n', '* @dev see https://github.com/ethereum/EIPs/issues/179\n', '*/\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', '* @title ERC20 interface\n', '* @dev see https://github.com/ethereum/EIPs/issues/20\n', '*/\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '/**\n', '* @title Basic token\n', '* @dev Basic version of StandardToken, with no allowances.\n', '*/\n', 'contract BasicToken is ERC20Basic {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', '* @title Standard ERC20 token\n', '*\n', '* @dev Implementation of the basic standard token.\n', '* @dev https://github.com/ethereum/EIPs/issues/20\n', '* @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '*/\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '  * @dev Transfer tokens from one address to another\n', '  * @param _from address The address which you want to send tokens from\n', '  * @param _to address The address which you want to transfer to\n', '  * @param _value uint256 the amout of tokens to be transfered\n', '  */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '  * @param _spender The address which will spend the funds.\n', '  * @param _value The amount of tokens to be spent.\n', '  */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '  * @param _owner address The address which owns the funds.\n', '  * @param _spender address The address which will spend the funds.\n', '  * @return A uint256 specifing the amount of tokens still available for the spender.\n', '  */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', '* @title Ownable\n', '* @dev The Ownable contract has an owner address, and provides basic authorization control\n', '* functions, this simplifies the implementation of "user permissions".\n', '*/\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  /**\n', '  * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '  * account.\n', '  */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '  * @dev Throws if called by any account other than the owner.\n', '  */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '  * @param newOwner The address to transfer ownership to.\n', '  */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', '* @title Mintable token\n', '* @dev Simple ERC20 Token example, with mintable token creation\n', '* @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', '* Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', '*/\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @dev Function to mint tokens\n', '  * @param _to The address that will recieve the minted tokens.\n', '  * @param _amount The amount of tokens to mint.\n', '  * @return A boolean that indicates if the operation was successful.\n', '  */\n', '  function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Function to stop minting new tokens.\n', '  * @return True if the operation was successful.\n', '  */\n', '  function finishMinting() public onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract DbiCapitalToken is MintableToken {\n', '\n', '  string public constant name = "DBI Capital Token";\n', '\n', '  string public constant symbol = "DBI";\n', '\n', '  uint32 public constant decimals = 18;\n', '\n', '}\n', '\n', 'contract Crowdsale is Ownable {\n', '\n', '  using SafeMath for uint;\n', '\n', '  address multisig; //address for ETH\n', '  address bounty;   //address for bounty tokens\n', '  uint bountyCount = 1000000000000000000000; //1,000 tokens for bounty\n', '\n', '  DbiCapitalToken public token = new DbiCapitalToken();\n', '\n', '  uint startDate = 0; //UNIX timestamp\n', '  uint endDate = 0;   //UNIX timestamp\n', '  uint hardcap = 0;   //in ether\n', '  uint rate = 0;      //tokens for 1 eth\n', '\n', '  uint tokensSold = 0;\n', '  uint etherReceived = 0;\n', '\n', '  uint hardcapStage1 = 2000 ether;  //Pre-ICO, Research & Lega\n', '  uint hardcapStage2 = 20000 ether; //Pre-ICO, MVP + START\n', '  uint hardcapStage3 = 150000 ether; //ICO, SCALE\n', '\n', '  uint rateStage1 = 100; //Pre-ICO, Research & Lega\n', '  uint rateStage2 = 70;  //Pre-ICO, MVP + START\n', '  uint rateStage3 = 50;  //ICO, SCALE\n', '\n', '  uint crowdsaleStage = 0;\n', '  bool crowdsaleStarted = false;\n', '  bool crowdsaleFinished = false;\n', '\n', '  event CrowdsaleStageStarted(uint stage, uint startDate, uint endDate, uint rate, uint hardcap);\n', '  event CrowdsaleFinished(uint tokensSold, uint etherReceived);\n', '  event TokenSold(uint tokens, uint ethFromTokens, uint rate, uint hardcap);\n', '  event HardcapGoalReached(uint tokensSold, uint etherReceived, uint hardcap, uint stage);\n', '\n', '\n', '  function Crowdsale() public {\n', '    multisig = 0x70C39CC41a3852e20a8B1a59A728305758e3aa37;\n', '    bounty = 0x11404c733254d66612765B5A94fB4b1f0937639c;\n', '    token.mint(bounty, bountyCount);\n', '  }\n', '\n', '  modifier saleIsOn() {\n', '    require(now >= startDate && now <= endDate && crowdsaleStarted && !crowdsaleFinished && crowdsaleStage > 0 && crowdsaleStage <= 3);\n', '    _;\n', '  }\n', '\n', '  modifier isUnderHardCap() {\n', '    require(etherReceived <= hardcap);\n', '    _;\n', '  }\n', '\n', '  function nextStage(uint _startDate, uint _endDate) public onlyOwner {\n', '    crowdsaleStarted = true;\n', '    crowdsaleStage += 1;\n', '    startDate = _startDate;\n', '    endDate = _endDate;\n', '    if (crowdsaleStage == 1) {\n', '      rate = rateStage1;\n', '      hardcap = hardcapStage1;\n', '      CrowdsaleStageStarted(crowdsaleStage, startDate, endDate, rate, hardcap);\n', '    } else if (crowdsaleStage == 2) {\n', '      rate = rateStage2;\n', '      hardcap = hardcapStage2;\n', '      CrowdsaleStageStarted(crowdsaleStage, startDate, endDate, rate, hardcap);\n', '    } else if (crowdsaleStage == 3) {\n', '      rate = rateStage3;\n', '      hardcap = hardcapStage3;\n', '      CrowdsaleStageStarted(crowdsaleStage, startDate, endDate, rate, hardcap);\n', '    } else {\n', '      finishMinting();\n', '    }\n', '  }\n', '\n', '  function finishMinting() public onlyOwner {\n', '    crowdsaleFinished = true;\n', '    token.finishMinting();\n', '    CrowdsaleFinished(tokensSold, etherReceived);\n', '  }\n', '\n', '  function createTokens() public isUnderHardCap saleIsOn payable {\n', '    multisig.transfer(msg.value);\n', '    uint tokens = rate.mul(msg.value);\n', '    tokensSold += tokens;\n', '    etherReceived += msg.value;\n', '    TokenSold(tokens, msg.value, rate, hardcap);\n', '    token.mint(msg.sender, tokens);\n', '    if (etherReceived >= hardcap) {\n', '      HardcapGoalReached(tokensSold, etherReceived, hardcap, crowdsaleStage);\n', '    }\n', '  }\n', '\n', '  function() external payable {\n', '    createTokens();\n', '  }\n', '\n', '  function getTokensSold() public view returns (uint) {\n', '    return tokensSold;\n', '  }\n', '\n', '  function getEtherReceived() public view returns (uint) {\n', '    return etherReceived;\n', '  }\n', '\n', '  function getCurrentHardcap() public view returns (uint) {\n', '    return hardcap;\n', '  }\n', '\n', '  function getCurrentRate() public view returns (uint) {\n', '    return rate;\n', '  }\n', '\n', '  function getStartDate() public view returns (uint) {\n', '    return startDate;\n', '  }\n', '\n', '  function getEndDate() public view returns (uint) {\n', '    return endDate;\n', '  }\n', '\n', '  function getStage() public view returns (uint) {\n', '    return crowdsaleStage;\n', '  }\n', '\n', '  function isStarted() public view returns (bool) {\n', '    return crowdsaleStarted;\n', '  }\n', '\n', '  function isFinished() public view returns (bool) {\n', '    return crowdsaleFinished;\n', '  }\n', '\n', '}']
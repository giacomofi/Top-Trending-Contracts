['pragma solidity ^0.4.10;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract MigrationAgent {\n', '    function migrateFrom(address _from, uint256 _value);\n', '}\n', '\n', '/**\n', '    BlockChain Board Of Derivatives Token. \n', ' */\n', 'contract BBDToken is StandardToken, Ownable {\n', '\n', '    // Metadata\n', '    string public constant name = "BlockChain Board Of Derivatives Token";\n', '    string public constant symbol = "BBD";\n', '    uint256 public constant decimals = 18;\n', '    string public constant version = &#39;1.0.0&#39;;\n', '\n', '    // Presale parameters\n', '    uint256 public presaleStartTime;\n', '    uint256 public presaleEndTime;\n', '\n', '    bool public presaleFinalized = false;\n', '\n', '    uint256 public constant presaleTokenCreationCap = 40000 * 10 ** decimals;// amount on presale\n', '    uint256 public constant presaleTokenCreationRate = 20000; // 2 BDD per 1 ETH\n', '\n', '    // Sale parameters\n', '    uint256 public saleStartTime;\n', '    uint256 public saleEndTime;\n', '\n', '    bool public saleFinalized = false;\n', '\n', '    uint256 public constant totalTokenCreationCap = 240000 * 10 ** decimals; //total amount on ale and presale\n', '    uint256 public constant saleStartTokenCreationRate = 16600; // 1.66 BDD per 1 ETH\n', '    uint256 public constant saleEndTokenCreationRate = 10000; // 1 BDD per 1 ETH\n', '\n', '    // Migration information\n', '    address public migrationAgent;\n', '    uint256 public totalMigrated;\n', '\n', '    // Team accounts\n', '    address public constant qtAccount = 0x87a9131485cf8ed8E9bD834b46A12D7f3092c263;\n', '    address public constant coreTeamMemberOne = 0xe43088E823eA7422D77E32a195267aE9779A8B07;\n', '    address public constant coreTeamMemberTwo = 0xad00884d1E7D0354d16fa8Ab083208c2cC3Ed515;\n', '\n', '    uint256 public constant divisor = 10000;\n', '\n', '    // ETH amount rised\n', '    uint256 raised = 0;\n', '\n', '    // Events\n', '    event Migrate(address indexed _from, address indexed _to, uint256 _value);\n', '    event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount);\n', '\n', '    function() payable {\n', '        require(!presaleFinalized || !saleFinalized); //todo\n', '\n', '        if (!presaleFinalized) {\n', '            buyPresaleTokens(msg.sender);\n', '        }\n', '        else{\n', '            buySaleTokens(msg.sender);\n', '        }\n', '    }\n', '\n', '    function BBDToken(uint256 _presaleStartTime, uint256 _presaleEndTime, uint256 _saleStartTime, uint256 _saleEndTime) {\n', '        require(_presaleStartTime >= now);\n', '        require(_presaleEndTime >= _presaleStartTime);\n', '        require(_saleStartTime >= _presaleEndTime);\n', '        require(_saleEndTime >= _saleStartTime);\n', '\n', '        presaleStartTime = _presaleStartTime;\n', '        presaleEndTime = _presaleEndTime;\n', '        saleStartTime = _saleStartTime;\n', '        saleEndTime = _saleEndTime;\n', '    }\n', '\n', '    // Get token creation rate\n', '    function getTokenCreationRate() constant returns (uint256) {\n', '        require(!presaleFinalized || !saleFinalized);\n', '\n', '        uint256 creationRate;\n', '\n', '        if (!presaleFinalized) {\n', '            //The rate on presales is constant\n', '            creationRate = presaleTokenCreationRate;\n', '        } else {\n', '            //The rate on sale is changing lineral while time is passing. On sales start it is 1.66 and on end 1.0 \n', '            uint256 rateRange = saleStartTokenCreationRate - saleEndTokenCreationRate;\n', '            uint256 timeRange = saleEndTime - saleStartTime;\n', '            creationRate = saleStartTokenCreationRate.sub(rateRange.mul(now.sub(saleStartTime)).div(timeRange));\n', '        }\n', '\n', '        return creationRate;\n', '    }\n', '    \n', '    // Buy presale tokens\n', '    function buyPresaleTokens(address _beneficiary) payable {\n', '        require(!presaleFinalized);\n', '        require(msg.value != 0);\n', '        require(now <= presaleEndTime);\n', '        require(now >= presaleStartTime);\n', '\n', '        uint256 bbdTokens = msg.value.mul(getTokenCreationRate()).div(divisor);\n', '        uint256 checkedSupply = totalSupply.add(bbdTokens);\n', '        require(presaleTokenCreationCap >= checkedSupply);\n', '\n', '        totalSupply = totalSupply.add(bbdTokens);\n', '        balances[_beneficiary] = balances[_beneficiary].add(bbdTokens);\n', '\n', '        raised += msg.value;\n', '        TokenPurchase(msg.sender, _beneficiary, msg.value, bbdTokens);\n', '    }\n', '\n', '    // Finalize presale\n', '    function finalizePresale() onlyOwner external {\n', '        require(!presaleFinalized);\n', '        require(now >= presaleEndTime || totalSupply == presaleTokenCreationCap);\n', '\n', '        presaleFinalized = true;\n', '\n', '        uint256 ethForCoreMember = this.balance.mul(500).div(divisor);\n', '\n', '        coreTeamMemberOne.transfer(ethForCoreMember); // 5%\n', '        coreTeamMemberTwo.transfer(ethForCoreMember); // 5%\n', '        qtAccount.transfer(this.balance); // Quant Technology 90%\n', '    }\n', '\n', '    // Buy sale tokens\n', '    function buySaleTokens(address _beneficiary) payable {\n', '        require(!saleFinalized);\n', '        require(msg.value != 0);\n', '        require(now <= saleEndTime);\n', '        require(now >= saleStartTime);\n', '\n', '        uint256 bbdTokens = msg.value.mul(getTokenCreationRate()).div(divisor);\n', '        uint256 checkedSupply = totalSupply.add(bbdTokens);\n', '        require(totalTokenCreationCap >= checkedSupply);\n', '\n', '        totalSupply = totalSupply.add(bbdTokens);\n', '        balances[_beneficiary] = balances[_beneficiary].add(bbdTokens);\n', '\n', '        raised += msg.value;\n', '        TokenPurchase(msg.sender, _beneficiary, msg.value, bbdTokens);\n', '    }\n', '\n', '    // Finalize sale\n', '    function finalizeSale() onlyOwner external {\n', '        require(!saleFinalized);\n', '        require(now >= saleEndTime || totalSupply == totalTokenCreationCap);\n', '\n', '        saleFinalized = true;\n', '\n', '        //Add aditional 25% tokens to the Quant Technology and development team\n', '        uint256 additionalBBDTokensForQTAccount = totalSupply.mul(2250).div(divisor); // 22.5%\n', '        totalSupply = totalSupply.add(additionalBBDTokensForQTAccount);\n', '        balances[qtAccount] = balances[qtAccount].add(additionalBBDTokensForQTAccount);\n', '\n', '        uint256 additionalBBDTokensForCoreTeamMember = totalSupply.mul(125).div(divisor); // 1.25%\n', '        totalSupply = totalSupply.add(2 * additionalBBDTokensForCoreTeamMember);\n', '        balances[coreTeamMemberOne] = balances[coreTeamMemberOne].add(additionalBBDTokensForCoreTeamMember);\n', '        balances[coreTeamMemberTwo] = balances[coreTeamMemberTwo].add(additionalBBDTokensForCoreTeamMember);\n', '\n', '        uint256 ethForCoreMember = this.balance.mul(500).div(divisor);\n', '\n', '        coreTeamMemberOne.transfer(ethForCoreMember); // 5%\n', '        coreTeamMemberTwo.transfer(ethForCoreMember); // 5%\n', '        qtAccount.transfer(this.balance); // Quant Technology 90%\n', '    }\n', '\n', '    // Allow migrate contract\n', '    function migrate(uint256 _value) external {\n', '        require(saleFinalized);\n', '        require(migrationAgent != 0x0);\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalMigrated = totalMigrated.add(_value);\n', '        MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);\n', '        Migrate(msg.sender, migrationAgent, _value);\n', '    }\n', '\n', '    function setMigrationAgent(address _agent) onlyOwner external {\n', '        require(saleFinalized);\n', '        require(migrationAgent == 0x0);\n', '\n', '        migrationAgent = _agent;\n', '    }\n', '\n', '    // ICO Status overview. Used for BBOD landing page\n', '    function icoOverview() constant returns (uint256 currentlyRaised, uint256 currentlyTotalSupply, uint256 currentlyTokenCreationRate){\n', '        currentlyRaised = raised;\n', '        currentlyTotalSupply = totalSupply;\n', '        currentlyTokenCreationRate = getTokenCreationRate();\n', '    }\n', '}']
['pragma solidity ^0.4.10;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract MigrationAgent {\n', '    function migrateFrom(address _from, uint256 _value);\n', '}\n', '\n', '/**\n', '    BlockChain Board Of Derivatives Token. \n', ' */\n', 'contract BBDToken is StandardToken, Ownable {\n', '\n', '    // Metadata\n', '    string public constant name = "BlockChain Board Of Derivatives Token";\n', '    string public constant symbol = "BBD";\n', '    uint256 public constant decimals = 18;\n', "    string public constant version = '1.0.0';\n", '\n', '    // Presale parameters\n', '    uint256 public presaleStartTime;\n', '    uint256 public presaleEndTime;\n', '\n', '    bool public presaleFinalized = false;\n', '\n', '    uint256 public constant presaleTokenCreationCap = 40000 * 10 ** decimals;// amount on presale\n', '    uint256 public constant presaleTokenCreationRate = 20000; // 2 BDD per 1 ETH\n', '\n', '    // Sale parameters\n', '    uint256 public saleStartTime;\n', '    uint256 public saleEndTime;\n', '\n', '    bool public saleFinalized = false;\n', '\n', '    uint256 public constant totalTokenCreationCap = 240000 * 10 ** decimals; //total amount on ale and presale\n', '    uint256 public constant saleStartTokenCreationRate = 16600; // 1.66 BDD per 1 ETH\n', '    uint256 public constant saleEndTokenCreationRate = 10000; // 1 BDD per 1 ETH\n', '\n', '    // Migration information\n', '    address public migrationAgent;\n', '    uint256 public totalMigrated;\n', '\n', '    // Team accounts\n', '    address public constant qtAccount = 0x87a9131485cf8ed8E9bD834b46A12D7f3092c263;\n', '    address public constant coreTeamMemberOne = 0xe43088E823eA7422D77E32a195267aE9779A8B07;\n', '    address public constant coreTeamMemberTwo = 0xad00884d1E7D0354d16fa8Ab083208c2cC3Ed515;\n', '\n', '    uint256 public constant divisor = 10000;\n', '\n', '    // ETH amount rised\n', '    uint256 raised = 0;\n', '\n', '    // Events\n', '    event Migrate(address indexed _from, address indexed _to, uint256 _value);\n', '    event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount);\n', '\n', '    function() payable {\n', '        require(!presaleFinalized || !saleFinalized); //todo\n', '\n', '        if (!presaleFinalized) {\n', '            buyPresaleTokens(msg.sender);\n', '        }\n', '        else{\n', '            buySaleTokens(msg.sender);\n', '        }\n', '    }\n', '\n', '    function BBDToken(uint256 _presaleStartTime, uint256 _presaleEndTime, uint256 _saleStartTime, uint256 _saleEndTime) {\n', '        require(_presaleStartTime >= now);\n', '        require(_presaleEndTime >= _presaleStartTime);\n', '        require(_saleStartTime >= _presaleEndTime);\n', '        require(_saleEndTime >= _saleStartTime);\n', '\n', '        presaleStartTime = _presaleStartTime;\n', '        presaleEndTime = _presaleEndTime;\n', '        saleStartTime = _saleStartTime;\n', '        saleEndTime = _saleEndTime;\n', '    }\n', '\n', '    // Get token creation rate\n', '    function getTokenCreationRate() constant returns (uint256) {\n', '        require(!presaleFinalized || !saleFinalized);\n', '\n', '        uint256 creationRate;\n', '\n', '        if (!presaleFinalized) {\n', '            //The rate on presales is constant\n', '            creationRate = presaleTokenCreationRate;\n', '        } else {\n', '            //The rate on sale is changing lineral while time is passing. On sales start it is 1.66 and on end 1.0 \n', '            uint256 rateRange = saleStartTokenCreationRate - saleEndTokenCreationRate;\n', '            uint256 timeRange = saleEndTime - saleStartTime;\n', '            creationRate = saleStartTokenCreationRate.sub(rateRange.mul(now.sub(saleStartTime)).div(timeRange));\n', '        }\n', '\n', '        return creationRate;\n', '    }\n', '    \n', '    // Buy presale tokens\n', '    function buyPresaleTokens(address _beneficiary) payable {\n', '        require(!presaleFinalized);\n', '        require(msg.value != 0);\n', '        require(now <= presaleEndTime);\n', '        require(now >= presaleStartTime);\n', '\n', '        uint256 bbdTokens = msg.value.mul(getTokenCreationRate()).div(divisor);\n', '        uint256 checkedSupply = totalSupply.add(bbdTokens);\n', '        require(presaleTokenCreationCap >= checkedSupply);\n', '\n', '        totalSupply = totalSupply.add(bbdTokens);\n', '        balances[_beneficiary] = balances[_beneficiary].add(bbdTokens);\n', '\n', '        raised += msg.value;\n', '        TokenPurchase(msg.sender, _beneficiary, msg.value, bbdTokens);\n', '    }\n', '\n', '    // Finalize presale\n', '    function finalizePresale() onlyOwner external {\n', '        require(!presaleFinalized);\n', '        require(now >= presaleEndTime || totalSupply == presaleTokenCreationCap);\n', '\n', '        presaleFinalized = true;\n', '\n', '        uint256 ethForCoreMember = this.balance.mul(500).div(divisor);\n', '\n', '        coreTeamMemberOne.transfer(ethForCoreMember); // 5%\n', '        coreTeamMemberTwo.transfer(ethForCoreMember); // 5%\n', '        qtAccount.transfer(this.balance); // Quant Technology 90%\n', '    }\n', '\n', '    // Buy sale tokens\n', '    function buySaleTokens(address _beneficiary) payable {\n', '        require(!saleFinalized);\n', '        require(msg.value != 0);\n', '        require(now <= saleEndTime);\n', '        require(now >= saleStartTime);\n', '\n', '        uint256 bbdTokens = msg.value.mul(getTokenCreationRate()).div(divisor);\n', '        uint256 checkedSupply = totalSupply.add(bbdTokens);\n', '        require(totalTokenCreationCap >= checkedSupply);\n', '\n', '        totalSupply = totalSupply.add(bbdTokens);\n', '        balances[_beneficiary] = balances[_beneficiary].add(bbdTokens);\n', '\n', '        raised += msg.value;\n', '        TokenPurchase(msg.sender, _beneficiary, msg.value, bbdTokens);\n', '    }\n', '\n', '    // Finalize sale\n', '    function finalizeSale() onlyOwner external {\n', '        require(!saleFinalized);\n', '        require(now >= saleEndTime || totalSupply == totalTokenCreationCap);\n', '\n', '        saleFinalized = true;\n', '\n', '        //Add aditional 25% tokens to the Quant Technology and development team\n', '        uint256 additionalBBDTokensForQTAccount = totalSupply.mul(2250).div(divisor); // 22.5%\n', '        totalSupply = totalSupply.add(additionalBBDTokensForQTAccount);\n', '        balances[qtAccount] = balances[qtAccount].add(additionalBBDTokensForQTAccount);\n', '\n', '        uint256 additionalBBDTokensForCoreTeamMember = totalSupply.mul(125).div(divisor); // 1.25%\n', '        totalSupply = totalSupply.add(2 * additionalBBDTokensForCoreTeamMember);\n', '        balances[coreTeamMemberOne] = balances[coreTeamMemberOne].add(additionalBBDTokensForCoreTeamMember);\n', '        balances[coreTeamMemberTwo] = balances[coreTeamMemberTwo].add(additionalBBDTokensForCoreTeamMember);\n', '\n', '        uint256 ethForCoreMember = this.balance.mul(500).div(divisor);\n', '\n', '        coreTeamMemberOne.transfer(ethForCoreMember); // 5%\n', '        coreTeamMemberTwo.transfer(ethForCoreMember); // 5%\n', '        qtAccount.transfer(this.balance); // Quant Technology 90%\n', '    }\n', '\n', '    // Allow migrate contract\n', '    function migrate(uint256 _value) external {\n', '        require(saleFinalized);\n', '        require(migrationAgent != 0x0);\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalMigrated = totalMigrated.add(_value);\n', '        MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);\n', '        Migrate(msg.sender, migrationAgent, _value);\n', '    }\n', '\n', '    function setMigrationAgent(address _agent) onlyOwner external {\n', '        require(saleFinalized);\n', '        require(migrationAgent == 0x0);\n', '\n', '        migrationAgent = _agent;\n', '    }\n', '\n', '    // ICO Status overview. Used for BBOD landing page\n', '    function icoOverview() constant returns (uint256 currentlyRaised, uint256 currentlyTotalSupply, uint256 currentlyTokenCreationRate){\n', '        currentlyRaised = raised;\n', '        currentlyTotalSupply = totalSupply;\n', '        currentlyTokenCreationRate = getTokenCreationRate();\n', '    }\n', '}']

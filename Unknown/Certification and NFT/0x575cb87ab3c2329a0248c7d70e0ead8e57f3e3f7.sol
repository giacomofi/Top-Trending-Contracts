['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/*\n', ' * Haltable\n', ' *\n', ' * Abstract contract that allows children to implement an\n', ' * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.\n', ' *\n', ' *\n', ' * Originally envisioned in FirstBlood ICO contract.\n', ' */\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    require (!halted);\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    require (halted);\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title SimpleToken\n', ' * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. \n', ' * Note they can later distribute these tokens as they wish using `transfer` and other\n', ' * `StandardToken` functions.\n', ' */\n', 'contract AhooleeToken is StandardToken {\n', '\n', '  string public name = "Ahoolee Token";\n', '  string public symbol = "AHT";\n', '  uint256 public decimals = 18;\n', '  uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;\n', '\n', '  /**\n', '   * @dev Contructor that gives msg.sender all of existing tokens. \n', '   */\n', '  function AhooleeToken() {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract AhooleeTokenSale is Haltable {\n', '    using SafeMath for uint;\n', '\n', '    string public name = "Ahoolee Token Sale";\n', '\n', '    AhooleeToken public token;\n', '    address public beneficiary;\n', '\n', '    uint public hardCapLow;\n', '    uint public hardCapHigh;\n', '    uint public softCap;\n', '    uint public hardCapLowUsd;\n', '    uint public hardCapHighUsd;\n', '    uint public softCapUsd;\n', '    uint public collected;\n', '    uint public priceETH;\n', '    \n', '    uint public investorCount = 0;\n', '    uint public weiRefunded = 0;\n', '\n', '    uint public startTime;\n', '    uint public endTime;\n', '\n', '    bool public softCapReached = false;\n', '    bool public crowdsaleFinished = false;\n', '    \n', '    uint constant HARD_CAP_TOKENS = 25000000;\n', '\n', '    mapping (address => bool) refunded;\n', '    mapping (address => uint256) saleBalances ;  \n', '    mapping (address => bool) claimed;   \n', '\n', '    event GoalReached(uint amountRaised);\n', '    event SoftCapReached(uint softCap);\n', '    event NewContribution(address indexed holder, uint256 etherAmount);\n', '    event Refunded(address indexed holder, uint256 amount);\n', '    event LogClaim(address indexed holder, uint256 amount, uint price);\n', '\n', '    modifier onlyAfter(uint time) {\n', '        require (now > time);\n', '        _;\n', '    }\n', '\n', '    modifier onlyBefore(uint time) {\n', '        require (now < time);\n', '        _;\n', '    }\n', '\n', '    function AhooleeTokenSale(\n', '        uint _hardCapLowUSD,\n', '        uint _hardCapHighUSD,\n', '        uint _softCapUSD,\n', '        address _token,\n', '        address _beneficiary,\n', '        uint _priceETH,\n', '\n', '        uint _startTime,\n', '        uint _durationHours\n', '    ) {\n', '        priceETH = _priceETH;\n', '        hardCapLowUsd = _hardCapLowUSD;\n', '        hardCapHighUsd = _hardCapHighUSD;\n', '        softCapUsd = _softCapUSD;\n', '        \n', '        calculatePrice();\n', '        \n', '        token = AhooleeToken(_token);\n', '        beneficiary = _beneficiary;\n', '\n', '        startTime = _startTime;\n', '        endTime = _startTime + _durationHours * 1 hours;\n', '    }\n', '\n', '    function calculatePrice() internal{\n', '        hardCapLow = hardCapLowUsd  * 1 ether / priceETH;\n', '        hardCapHigh = hardCapHighUsd  * 1 ether / priceETH;\n', '        softCap = softCapUsd * 1 ether / priceETH;\n', '    }\n', '\n', '    function setEthPrice(uint _priceETH) onlyBefore(startTime) onlyOwner {\n', '        priceETH = _priceETH;\n', '        calculatePrice();\n', '    }\n', '\n', '    function () payable stopInEmergency{\n', '        assert (msg.value > 0.01 * 1 ether || msg.value == 0);\n', '        if(msg.value > 0.01 * 1 ether) doPurchase(msg.sender);\n', '    }\n', '\n', '    function saleBalanceOf(address _owner) constant returns (uint256) {\n', '      return saleBalances[_owner];\n', '    }\n', '\n', '    function claimedOf(address _owner) constant returns (bool) {\n', '      return claimed[_owner];\n', '    }\n', '\n', '    function doPurchase(address _owner) private onlyAfter(startTime) onlyBefore(endTime) {\n', '        \n', '        require(crowdsaleFinished == false);\n', '\n', '        require (collected.add(msg.value) <= hardCapHigh);\n', '\n', '        if (!softCapReached && collected < softCap && collected.add(msg.value) >= softCap) {\n', '            softCapReached = true;\n', '            SoftCapReached(softCap);\n', '        }\n', '\n', '        if (saleBalances[msg.sender] == 0) investorCount++;\n', '      \n', '        collected = collected.add(msg.value);\n', '\n', '        saleBalances[msg.sender] = saleBalances[msg.sender].add(msg.value);\n', '\n', '        NewContribution(_owner, msg.value);\n', '\n', '        if (collected == hardCapHigh) {\n', '            GoalReached(hardCapHigh);\n', '        }\n', '    }\n', '\n', '    function claim() {\n', '        require (crowdsaleFinished);\n', '        require (!claimed[msg.sender]);\n', '        \n', '        uint price = HARD_CAP_TOKENS * 1 ether / hardCapLow;\n', '        if(collected > hardCapLow){\n', '          price = HARD_CAP_TOKENS * 1 ether / collected; \n', '        } \n', '        uint tokens = saleBalances[msg.sender] * price;\n', '\n', '        require(token.transfer(msg.sender, tokens));\n', '        claimed[msg.sender] = true;\n', '        LogClaim(msg.sender, tokens, price);\n', '    }\n', '\n', '    function returnTokens() onlyOwner {\n', '        require (crowdsaleFinished);\n', '\n', '        uint tokenAmount = token.balanceOf(this);\n', '        if(collected < hardCapLow){\n', '          tokenAmount = (hardCapLow - collected) * HARD_CAP_TOKENS * 1 ether / hardCapLow;\n', '        } \n', '        require (token.transfer(beneficiary, tokenAmount));\n', '    }\n', '\n', '    function withdraw() onlyOwner {\n', '        require (softCapReached);\n', '        require (beneficiary.send(collected));\n', '        crowdsaleFinished = true;\n', '    }\n', '\n', '    function refund() public onlyAfter(endTime) {\n', '        require (!softCapReached);\n', '        require (!refunded[msg.sender]);\n', '        require (saleBalances[msg.sender] != 0) ;\n', '\n', '        uint refund = saleBalances[msg.sender];\n', '        require (msg.sender.send(refund));\n', '        refunded[msg.sender] = true;\n', '        weiRefunded = weiRefunded.add(refund);\n', '        Refunded(msg.sender, refund);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/*\n', ' * Haltable\n', ' *\n', ' * Abstract contract that allows children to implement an\n', ' * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.\n', ' *\n', ' *\n', ' * Originally envisioned in FirstBlood ICO contract.\n', ' */\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    require (!halted);\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    require (halted);\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title SimpleToken\n', ' * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. \n', ' * Note they can later distribute these tokens as they wish using `transfer` and other\n', ' * `StandardToken` functions.\n', ' */\n', 'contract AhooleeToken is StandardToken {\n', '\n', '  string public name = "Ahoolee Token";\n', '  string public symbol = "AHT";\n', '  uint256 public decimals = 18;\n', '  uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;\n', '\n', '  /**\n', '   * @dev Contructor that gives msg.sender all of existing tokens. \n', '   */\n', '  function AhooleeToken() {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract AhooleeTokenSale is Haltable {\n', '    using SafeMath for uint;\n', '\n', '    string public name = "Ahoolee Token Sale";\n', '\n', '    AhooleeToken public token;\n', '    address public beneficiary;\n', '\n', '    uint public hardCapLow;\n', '    uint public hardCapHigh;\n', '    uint public softCap;\n', '    uint public hardCapLowUsd;\n', '    uint public hardCapHighUsd;\n', '    uint public softCapUsd;\n', '    uint public collected;\n', '    uint public priceETH;\n', '    \n', '    uint public investorCount = 0;\n', '    uint public weiRefunded = 0;\n', '\n', '    uint public startTime;\n', '    uint public endTime;\n', '\n', '    bool public softCapReached = false;\n', '    bool public crowdsaleFinished = false;\n', '    \n', '    uint constant HARD_CAP_TOKENS = 25000000;\n', '\n', '    mapping (address => bool) refunded;\n', '    mapping (address => uint256) saleBalances ;  \n', '    mapping (address => bool) claimed;   \n', '\n', '    event GoalReached(uint amountRaised);\n', '    event SoftCapReached(uint softCap);\n', '    event NewContribution(address indexed holder, uint256 etherAmount);\n', '    event Refunded(address indexed holder, uint256 amount);\n', '    event LogClaim(address indexed holder, uint256 amount, uint price);\n', '\n', '    modifier onlyAfter(uint time) {\n', '        require (now > time);\n', '        _;\n', '    }\n', '\n', '    modifier onlyBefore(uint time) {\n', '        require (now < time);\n', '        _;\n', '    }\n', '\n', '    function AhooleeTokenSale(\n', '        uint _hardCapLowUSD,\n', '        uint _hardCapHighUSD,\n', '        uint _softCapUSD,\n', '        address _token,\n', '        address _beneficiary,\n', '        uint _priceETH,\n', '\n', '        uint _startTime,\n', '        uint _durationHours\n', '    ) {\n', '        priceETH = _priceETH;\n', '        hardCapLowUsd = _hardCapLowUSD;\n', '        hardCapHighUsd = _hardCapHighUSD;\n', '        softCapUsd = _softCapUSD;\n', '        \n', '        calculatePrice();\n', '        \n', '        token = AhooleeToken(_token);\n', '        beneficiary = _beneficiary;\n', '\n', '        startTime = _startTime;\n', '        endTime = _startTime + _durationHours * 1 hours;\n', '    }\n', '\n', '    function calculatePrice() internal{\n', '        hardCapLow = hardCapLowUsd  * 1 ether / priceETH;\n', '        hardCapHigh = hardCapHighUsd  * 1 ether / priceETH;\n', '        softCap = softCapUsd * 1 ether / priceETH;\n', '    }\n', '\n', '    function setEthPrice(uint _priceETH) onlyBefore(startTime) onlyOwner {\n', '        priceETH = _priceETH;\n', '        calculatePrice();\n', '    }\n', '\n', '    function () payable stopInEmergency{\n', '        assert (msg.value > 0.01 * 1 ether || msg.value == 0);\n', '        if(msg.value > 0.01 * 1 ether) doPurchase(msg.sender);\n', '    }\n', '\n', '    function saleBalanceOf(address _owner) constant returns (uint256) {\n', '      return saleBalances[_owner];\n', '    }\n', '\n', '    function claimedOf(address _owner) constant returns (bool) {\n', '      return claimed[_owner];\n', '    }\n', '\n', '    function doPurchase(address _owner) private onlyAfter(startTime) onlyBefore(endTime) {\n', '        \n', '        require(crowdsaleFinished == false);\n', '\n', '        require (collected.add(msg.value) <= hardCapHigh);\n', '\n', '        if (!softCapReached && collected < softCap && collected.add(msg.value) >= softCap) {\n', '            softCapReached = true;\n', '            SoftCapReached(softCap);\n', '        }\n', '\n', '        if (saleBalances[msg.sender] == 0) investorCount++;\n', '      \n', '        collected = collected.add(msg.value);\n', '\n', '        saleBalances[msg.sender] = saleBalances[msg.sender].add(msg.value);\n', '\n', '        NewContribution(_owner, msg.value);\n', '\n', '        if (collected == hardCapHigh) {\n', '            GoalReached(hardCapHigh);\n', '        }\n', '    }\n', '\n', '    function claim() {\n', '        require (crowdsaleFinished);\n', '        require (!claimed[msg.sender]);\n', '        \n', '        uint price = HARD_CAP_TOKENS * 1 ether / hardCapLow;\n', '        if(collected > hardCapLow){\n', '          price = HARD_CAP_TOKENS * 1 ether / collected; \n', '        } \n', '        uint tokens = saleBalances[msg.sender] * price;\n', '\n', '        require(token.transfer(msg.sender, tokens));\n', '        claimed[msg.sender] = true;\n', '        LogClaim(msg.sender, tokens, price);\n', '    }\n', '\n', '    function returnTokens() onlyOwner {\n', '        require (crowdsaleFinished);\n', '\n', '        uint tokenAmount = token.balanceOf(this);\n', '        if(collected < hardCapLow){\n', '          tokenAmount = (hardCapLow - collected) * HARD_CAP_TOKENS * 1 ether / hardCapLow;\n', '        } \n', '        require (token.transfer(beneficiary, tokenAmount));\n', '    }\n', '\n', '    function withdraw() onlyOwner {\n', '        require (softCapReached);\n', '        require (beneficiary.send(collected));\n', '        crowdsaleFinished = true;\n', '    }\n', '\n', '    function refund() public onlyAfter(endTime) {\n', '        require (!softCapReached);\n', '        require (!refunded[msg.sender]);\n', '        require (saleBalances[msg.sender] != 0) ;\n', '\n', '        uint refund = saleBalances[msg.sender];\n', '        require (msg.sender.send(refund));\n', '        refunded[msg.sender] = true;\n', '        weiRefunded = weiRefunded.add(refund);\n', '        Refunded(msg.sender, refund);\n', '    }\n', '\n', '}']
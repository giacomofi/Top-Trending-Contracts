['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract AbstractStarbaseCrowdsale {\n', '    function workshop() constant returns (address) {}\n', '    function startDate() constant returns (uint256) {}\n', '    function endedAt() constant returns (uint256) {}\n', '    function isEnded() constant returns (bool);\n', '    function totalRaisedAmountInCny() constant returns (uint256);\n', '    function numOfPurchasedTokensOnCsBy(address purchaser) constant returns (uint256);\n', '    function numOfPurchasedTokensOnEpBy(address purchaser) constant returns (uint256);\n', '}\n', '\n', 'contract AbstractStarbaseMarketingCampaign {\n', '    function workshop() constant returns (address) {}\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract SynchroCoin is Ownable, StandardToken {\n', '\n', '    string public constant symbol = "SYC";\n', '\n', '    string public constant name = "SynchroCoin";\n', '\n', '    uint8 public constant decimals = 12;\n', '    \n', '\n', '    uint256 public STARTDATE;\n', '\n', '    uint256 public ENDDATE;\n', '\n', '    // 55% to distribute during CrowdSale\n', '    uint256 public crowdSale;\n', '\n', '    // 20% to pool to reward\n', '    // 25% to other business operations\n', '    address public multisig;\n', '\n', '    function SynchroCoin(\n', '    uint256 _initialSupply,\n', '    uint256 _start,\n', '    uint256 _end,\n', '    address _multisig) {\n', '        totalSupply = _initialSupply;\n', '        STARTDATE = _start;\n', '        ENDDATE = _end;\n', '        multisig = _multisig;\n', '        crowdSale = _initialSupply * 55 / 100;\n', '        balances[multisig] = _initialSupply;\n', '    }\n', '\n', '    // crowdsale statuses\n', '    uint256 public totalFundedEther;\n', '\n', '    //This includes the Ether raised during the presale.\n', '    uint256 public totalConsideredFundedEther = 338;\n', '\n', '    mapping (address => uint256) consideredFundedEtherOf;\n', '\n', '    mapping (address => bool) withdrawalStatuses;\n', '\n', '    function calcBonus() public constant returns (uint256){\n', '        return calcBonusAt(now);\n', '    }\n', '\n', '    function calcBonusAt(uint256 at) public constant returns (uint256){\n', '        if (at < STARTDATE) {\n', '            return 140;\n', '        }\n', '        else if (at < (STARTDATE + 1 days)) {\n', '            return 120;\n', '        }\n', '        else if (at < (STARTDATE + 7 days)) {\n', '            return 115;\n', '        }\n', '        else if (at < (STARTDATE + 14 days)) {\n', '            return 110;\n', '        }\n', '        else if (at < (STARTDATE + 21 days)) {\n', '            return 105;\n', '        }\n', '        else if (at <= ENDDATE) {\n', '            return 100;\n', '        }\n', '        else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '\n', '    function() public payable {\n', '        proxyPayment(msg.sender);\n', '    }\n', '\n', '    function proxyPayment(address participant) public payable {\n', '        require(now >= STARTDATE);\n', '\n', '        require(now <= ENDDATE);\n', '\n', '        //require msg.value >= 0.1 ether\n', '        require(msg.value >= 100 finney);\n', '\n', '        totalFundedEther = totalFundedEther.add(msg.value);\n', '\n', '        uint256 _consideredEther = msg.value.mul(calcBonus()).div(100);\n', '        totalConsideredFundedEther = totalConsideredFundedEther.add(_consideredEther);\n', '        consideredFundedEtherOf[participant] = consideredFundedEtherOf[participant].add(_consideredEther);\n', '        withdrawalStatuses[participant] = true;\n', '\n', '        // Log events\n', '        Fund(\n', '        participant,\n', '        msg.value,\n', '        totalFundedEther\n', '        );\n', '\n', '        // Move the funds to a safe wallet\n', '        multisig.transfer(msg.value);\n', '    }\n', '\n', '    event Fund(\n', '    address indexed buyer,\n', '    uint256 ethers,\n', '    uint256 totalEther\n', '    );\n', '\n', '    function withdraw() public returns (bool success){\n', '        return proxyWithdraw(msg.sender);\n', '    }\n', '\n', '    function proxyWithdraw(address participant) public returns (bool success){\n', '        require(now > ENDDATE);\n', '        require(withdrawalStatuses[participant]);\n', '        require(totalConsideredFundedEther > 1);\n', '\n', '        uint256 share = crowdSale.mul(consideredFundedEtherOf[participant]).div(totalConsideredFundedEther);\n', '        participant.transfer(share);\n', '        withdrawalStatuses[participant] = false;\n', '        return true;\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '        require(now > ENDDATE);\n', '        return super.transfer(_to, _amount);\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _amount) public\n', '    returns (bool success)\n', '    {\n', '        require(now > ENDDATE);\n', '        return super.transferFrom(_from, _to, _amount);\n', '    }\n', '\n', '}']
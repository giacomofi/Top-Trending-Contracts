['pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically revert()s when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  /**\n', '   * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       revert();\n', '     }\n', '     _;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implemantation of the basic standart token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) revert();\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint _value) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title LimitedTransferToken\n', ' * @dev LimitedTransferToken defines the generic interface and the implementation to limit token \n', ' * transferability for different events. It is intended to be used as a base class for other token \n', ' * contracts. \n', ' * LimitedTransferToken has been designed to allow for different limiting factors,\n', ' * this can be achieved by recursively calling super.transferableTokens() until the base class is \n', ' * hit. For example:\n', ' *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {\n', ' *       return min256(unlockedTokens, super.transferableTokens(holder, time));\n', ' *     }\n', ' * A working example is VestedToken.sol:\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol\n', ' */\n', '\n', 'contract LimitedTransferToken is ERC20 {\n', '\n', '  /**\n', '   * @dev Checks whether it can transfer or otherwise throws.\n', '   */\n', '  modifier canTransfer(address _sender, uint _value) {\n', '   if (_value > transferableTokens(_sender, uint64(now))) revert();\n', '   _;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks modifier and allows transfer if tokens are not locked.\n', '   * @param _to The address that will recieve the tokens.\n', '   * @param _value The amount of tokens to be transferred.\n', '   */\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {\n', '    super.transfer(_to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Checks modifier and allows transfer if tokens are not locked.\n', '  * @param _from The address that will send the tokens.\n', '  * @param _to The address that will recieve the tokens.\n', '  * @param _value The amount of tokens to be transferred.\n', '  */\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {\n', '    super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Default transferable tokens function returns all tokens for a holder (no limit).\n', '   * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the \n', '   * specific logic for limiting token transferability for a holder over time.\n', '   */\n', '  function transferableTokens(address holder, uint64 time) constant public returns (uint256) {\n', '    time;\n', '    return balanceOf(holder);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Vested token\n', ' * @dev Tokens that can be vested for a group of addresses.\n', ' */\n', 'contract VestedToken is StandardToken, LimitedTransferToken {\n', '\n', '  uint256 MAX_GRANTS_PER_ADDRESS = 20;\n', '\n', '  struct TokenGrant {\n', '    address granter;     // 20 bytes\n', '    uint256 value;       // 32 bytes\n', '    uint64 cliff;\n', '    uint64 vesting;\n', '    uint64 start;        // 3 * 8 = 24 bytes\n', '    bool revokable;\n', '    bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?\n', '  } // total 78 bytes = 3 sstore per operation (32 per sstore)\n', '\n', '  mapping (address => TokenGrant[]) public grants;\n', '\n', '  event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);\n', '\n', '  /**\n', '   * @dev Grant tokens to a specified address\n', '   * @param _to address The address which the tokens will be granted to.\n', '   * @param _value uint256 The amount of tokens to be granted.\n', '   * @param _start uint64 Time of the beginning of the grant.\n', '   * @param _cliff uint64 Time of the cliff period.\n', '   * @param _vesting uint64 The vesting period.\n', '   */\n', '  function grantVestedTokens(\n', '    address _to,\n', '    uint256 _value,\n', '    uint64 _start,\n', '    uint64 _cliff,\n', '    uint64 _vesting,\n', '    bool _revokable,\n', '    bool _burnsOnRevoke\n', '  ) public {\n', '\n', '    // Check for date inconsistencies that may cause unexpected behavior\n', '    if (_cliff < _start || _vesting < _cliff) {\n', '      revert();\n', '    }\n', '\n', '    if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) revert();   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).\n', '\n', '    uint count = grants[_to].push(\n', '                TokenGrant(\n', '                  _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable\n', '                  _value,\n', '                  _cliff,\n', '                  _vesting,\n', '                  _start,\n', '                  _revokable,\n', '                  _burnsOnRevoke\n', '                )\n', '              );\n', '\n', '    transfer(_to, _value);\n', '\n', '    NewTokenGrant(msg.sender, _to, _value, count - 1);\n', '  }\n', '\n', '  /**\n', '   * @dev Revoke the grant of tokens of a specifed address.\n', '   * @param _holder The address which will have its tokens revoked.\n', '   * @param _grantId The id of the token grant.\n', '   */\n', '  function revokeTokenGrant(address _holder, uint _grantId) public {\n', '    TokenGrant storage grant = grants[_holder][_grantId];\n', '\n', '    if (!grant.revokable) { // Check if grant was revokable\n', '      revert();\n', '    }\n', '\n', '    if (grant.granter != msg.sender) { // Only granter can revoke it\n', '      revert();\n', '    }\n', '\n', '    address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;\n', '\n', '    uint256 nonVested = nonVestedTokens(grant, uint64(now));\n', '\n', '    // remove grant from array\n', '    delete grants[_holder][_grantId];\n', '    grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];\n', '    grants[_holder].length -= 1;\n', '\n', '    balances[receiver] = balances[receiver].add(nonVested);\n', '    balances[_holder] = balances[_holder].sub(nonVested);\n', '\n', '    Transfer(_holder, receiver, nonVested);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Calculate the total amount of transferable tokens of a holder at a given time\n', '   * @param holder address The address of the holder\n', '   * @param time uint64 The specific time.\n', '   * @return An uint representing a holder&#39;s total amount of transferable tokens.\n', '   */\n', '  function transferableTokens(address holder, uint64 time) constant public returns (uint256) {\n', '    uint256 grantIndex = tokenGrantsCount(holder);\n', '\n', '    if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants\n', '\n', '    // Iterate through all the grants the holder has, and add all non-vested tokens\n', '    uint256 nonVested = 0;\n', '    for (uint256 i = 0; i < grantIndex; i++) {\n', '      nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));\n', '    }\n', '\n', '    // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time\n', '    uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);\n', '\n', '    // Return the minimum of how many vested can transfer and other value\n', '    // in case there are other limiting transferability factors (default is balanceOf)\n', '    return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));\n', '  }\n', '\n', '  /**\n', '   * @dev Check the amount of grants that an address has.\n', '   * @param _holder The holder of the grants.\n', '   * @return A uint representing the total amount of grants.\n', '   */\n', '  function tokenGrantsCount(address _holder) constant returns (uint index) {\n', '    return grants[_holder].length;\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate amount of vested tokens at a specifc time.\n', '   * @param tokens uint256 The amount of tokens grantted.\n', '   * @param time uint64 The time to be checked\n', '   * @param start uint64 A time representing the begining of the grant\n', '   * @param cliff uint64 The cliff period.\n', '   * @param vesting uint64 The vesting period.\n', '   * @return An uint representing the amount of vested tokensof a specif grant.\n', '   *  transferableTokens\n', '   *   |                         _/--------   vestedTokens rect\n', '   *   |                       _/\n', '   *   |                     _/\n', '   *   |                   _/\n', '   *   |                 _/\n', '   *   |                /\n', '   *   |              .|\n', '   *   |            .  |\n', '   *   |          .    |\n', '   *   |        .      |\n', '   *   |      .        |\n', '   *   |    .          |\n', '   *   +===+===========+---------+----------> time\n', '   *      Start       Clift    Vesting\n', '   */\n', '  function calculateVestedTokens(\n', '    uint256 tokens,\n', '    uint256 time,\n', '    uint256 start,\n', '    uint256 cliff,\n', '    uint256 vesting) constant returns (uint256)\n', '    {\n', '      // Shortcuts for before cliff and after vesting cases.\n', '      if (time < cliff) return 0;\n', '      if (time >= vesting) return tokens;\n', '\n', '      // Interpolate all vested tokens.\n', '      // As before cliff the shortcut returns 0, we can use just calculate a value\n', '      // in the vesting rect (as shown in above&#39;s figure)\n', '\n', '      // vestedTokens = tokens * (time - start) / (vesting - start)\n', '      uint256 vestedTokens = SafeMath.div(\n', '                                    SafeMath.mul(\n', '                                      tokens,\n', '                                      SafeMath.sub(time, start)\n', '                                      ),\n', '                                    SafeMath.sub(vesting, start)\n', '                                    );\n', '\n', '      return vestedTokens;\n', '  }\n', '\n', '  /**\n', '   * @dev Get all information about a specifc grant.\n', '   * @param _holder The address which will have its tokens revoked.\n', '   * @param _grantId The id of the token grant.\n', '   * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,\n', '   * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.\n', '   */\n', '  function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {\n', '    TokenGrant storage grant = grants[_holder][_grantId];\n', '\n', '    granter = grant.granter;\n', '    value = grant.value;\n', '    start = grant.start;\n', '    cliff = grant.cliff;\n', '    vesting = grant.vesting;\n', '    revokable = grant.revokable;\n', '    burnsOnRevoke = grant.burnsOnRevoke;\n', '\n', '    vested = vestedTokens(grant, uint64(now));\n', '  }\n', '\n', '  /**\n', '   * @dev Get the amount of vested tokens at a specific time.\n', '   * @param grant TokenGrant The grant to be checked.\n', '   * @param time The time to be checked\n', '   * @return An uint representing the amount of vested tokens of a specific grant at a specific time.\n', '   */\n', '  function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {\n', '    return calculateVestedTokens(\n', '      grant.value,\n', '      uint256(time),\n', '      uint256(grant.start),\n', '      uint256(grant.cliff),\n', '      uint256(grant.vesting)\n', '    );\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate the amount of non vested tokens at a specific time.\n', '   * @param grant TokenGrant The grant to be checked.\n', '   * @param time uint64 The time to be checked\n', '   * @return An uint representing the amount of non vested tokens of a specifc grant on the \n', '   * passed time frame.\n', '   */\n', '  function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {\n', '    return grant.value.sub(vestedTokens(grant, time));\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate the date when the holder can trasfer all its tokens\n', '   * @param holder address The address of the holder\n', '   * @return An uint representing the date of the last transferable tokens.\n', '   */\n', '  function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {\n', '    date = uint64(now);\n', '    uint256 grantIndex = grants[holder].length;\n', '    for (uint256 i = 0; i < grantIndex; i++) {\n', '      date = SafeMath.max64(grants[holder][i].vesting, date);\n', '    }\n', '  }\n', '}\n', '\n', '// QUESTIONS FOR AUDITORS:\n', '// - Considering we inherit from VestedToken, how much does that hit at our gas price?\n', '// - Ensure max supply is 100,000,000\n', '// - Ensure that even if not totalSupply is sold, tokens would still be transferrable after (we will up to totalSupply by creating DAN-Service tokens)\n', '\n', '// vesting: 365 days, 365 days / 4 vesting\n', '\n', '\n', 'contract DANSToken is VestedToken {\n', '  //FIELDS\n', '  string public name = "DAN-Service coin";\n', '  string public symbol = "DANS";\n', '  uint public decimals = 4;\n', '  \n', '  //CONSTANTS\n', '  //Time limits\n', '  uint public constant CROWDSALE_DURATION = 60 days;\n', '  uint public constant STAGE_ONE_TIME_END = 24 hours; // first day bonus\n', '  uint public constant STAGE_TWO_TIME_END = 1 weeks; // first week bonus\n', '  uint public constant STAGE_THREE_TIME_END = CROWDSALE_DURATION;\n', '  \n', '  // Multiplier for the decimals\n', '  uint private constant DECIMALS = 10000;\n', '\n', '  //Prices of DANS\n', '  uint public constant PRICE_STANDARD    = 900*DECIMALS; // DANS received per one ETH; MAX_SUPPLY / (valuation / ethPrice)\n', '  uint public constant PRICE_STAGE_ONE   = PRICE_STANDARD * 130/100; // 1ETH = 30% more DANS\n', '  uint public constant PRICE_STAGE_TWO   = PRICE_STANDARD * 115/100; // 1ETH = 15% more DANS\n', '  uint public constant PRICE_STAGE_THREE = PRICE_STANDARD;\n', '\n', '  //DANS Token Limits\n', '  uint public constant ALLOC_TEAM =         16000000*DECIMALS; // team + advisors\n', '  uint public constant ALLOC_BOUNTIES =      4000000*DECIMALS;\n', '  uint public constant ALLOC_CROWDSALE =    80000000*DECIMALS;\n', '  uint public constant PREBUY_PORTION_MAX = 20000000*DECIMALS; // this is redundantly more than what will be pre-sold\n', ' \n', '  // More erc20\n', '  uint public totalSupply = 100000000*DECIMALS; \n', '  \n', '  //ASSIGNED IN INITIALIZATION\n', '  //Start and end times\n', '  uint public publicStartTime; // Time in seconds public crowd fund starts.\n', '  uint public privateStartTime; // Time in seconds when pre-buy can purchase up to 31250 ETH worth of DANS;\n', '  uint public publicEndTime; // Time in seconds crowdsale ends\n', '  uint public hardcapInEth;\n', '\n', '  //Special Addresses\n', '  address public multisigAddress; // Address to which all ether flows.\n', '  address public danserviceTeamAddress; // Address to which ALLOC_TEAM, ALLOC_BOUNTIES, ALLOC_WINGS is (ultimately) sent to.\n', '  address public ownerAddress; // Address of the contract owner. Can halt the crowdsale.\n', '  address public preBuy1; // Address used by pre-buy\n', '  address public preBuy2; // Address used by pre-buy\n', '  address public preBuy3; // Address used by pre-buy\n', '  uint public preBuyPrice1; // price for pre-buy\n', '  uint public preBuyPrice2; // price for pre-buy\n', '  uint public preBuyPrice3; // price for pre-buy\n', '\n', '  //Running totals\n', '  uint public etherRaised; // Total Ether raised.\n', '  uint public DANSSold; // Total DANS created\n', '  uint public prebuyPortionTotal; // Total of Tokens purchased by pre-buy. Not to exceed PREBUY_PORTION_MAX.\n', '  \n', '  //booleans\n', '  bool public halted; // halts the crowd sale if true.\n', '\n', '  // MODIFIERS\n', '  //Is currently in the period after the private start time and before the public start time.\n', '  modifier is_pre_crowdfund_period() {\n', '    if (now >= publicStartTime || now < privateStartTime) revert();\n', '    _;\n', '  }\n', '\n', '  //Is currently the crowdfund period\n', '  modifier is_crowdfund_period() {\n', '    if (now < publicStartTime) revert();\n', '    if (isCrowdfundCompleted()) revert();\n', '    _;\n', '  }\n', '\n', '  // Is completed\n', '  modifier is_crowdfund_completed() {\n', '    if (!isCrowdfundCompleted()) revert();\n', '    _;\n', '  }\n', '  function isCrowdfundCompleted() internal returns (bool) {\n', '    if (now > publicEndTime || DANSSold >= ALLOC_CROWDSALE || etherRaised >= hardcapInEth) return true;\n', '    return false;\n', '  }\n', '\n', '  //May only be called by the owner address\n', '  modifier only_owner() {\n', '    if (msg.sender != ownerAddress) revert();\n', '    _;\n', '  }\n', '\n', '  //May only be called if the crowdfund has not been halted\n', '  modifier is_not_halted() {\n', '    if (halted) revert();\n', '    _;\n', '  }\n', '\n', '  // EVENTS\n', '  event PreBuy(uint _amount);\n', '  event Buy(address indexed _recipient, uint _amount);\n', '\n', '  // Initialization contract assigns address of crowdfund contract and end time.\n', '  function DANSToken (\n', '    address _multisig,\n', '    address _danserviceTeam,\n', '    uint _publicStartTime,\n', '    uint _privateStartTime,\n', '    uint _hardcapInEth,\n', '    address _prebuy1, uint _preBuyPrice1,\n', '    address _prebuy2, uint _preBuyPrice2,\n', '    address _prebuy3, uint _preBuyPrice3\n', '  )\n', '    public\n', '  {\n', '    ownerAddress = msg.sender;\n', '    publicStartTime = _publicStartTime;\n', '    privateStartTime = _privateStartTime;\n', '\tpublicEndTime = _publicStartTime + CROWDSALE_DURATION;\n', '    multisigAddress = _multisig;\n', '    danserviceTeamAddress = _danserviceTeam;\n', '\n', '    hardcapInEth = _hardcapInEth;\n', '\n', '    preBuy1 = _prebuy1;\n', '    preBuyPrice1 = _preBuyPrice1;\n', '    preBuy2 = _prebuy2;\n', '    preBuyPrice2 = _preBuyPrice2;\n', '    preBuy3 = _prebuy3;\n', '    preBuyPrice3 = _preBuyPrice3;\n', '\n', '    balances[danserviceTeamAddress] += ALLOC_BOUNTIES;\n', '\n', '    balances[ownerAddress] += ALLOC_TEAM;\n', '\n', '    balances[ownerAddress] += ALLOC_CROWDSALE;\n', '  }\n', '\n', '  // Transfer amount of tokens from sender account to recipient.\n', '  // Only callable after the crowd fund is completed\n', '  function transfer(address _to, uint _value)\n', '  {\n', '    if (_to == msg.sender) return; // no-op, allow even during crowdsale, in order to work around using grantVestedTokens() while in crowdsale\n', '    if (!isCrowdfundCompleted()) revert();\n', '    super.transfer(_to, _value);\n', '  }\n', '\n', '  // Transfer amount of tokens from a specified address to a recipient.\n', '  // Transfer amount of tokens from sender account to recipient.\n', '  function transferFrom(address _from, address _to, uint _value)\n', '    is_crowdfund_completed\n', '  {\n', '    super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  //constant function returns the current DANS price.\n', '  function getPriceRate()\n', '      constant\n', '      returns (uint o_rate)\n', '  {\n', '      uint delta = SafeMath.sub(now, publicStartTime);\n', '\n', '      if (delta > STAGE_TWO_TIME_END) return PRICE_STAGE_THREE;\n', '      if (delta > STAGE_ONE_TIME_END) return PRICE_STAGE_TWO;\n', '\n', '      return (PRICE_STAGE_ONE);\n', '  }\n', '\n', '  // calculates wmount of DANS we get, given the wei and the rates we&#39;ve defined per 1 eth\n', '  function calcAmount(uint _wei, uint _rate) \n', '    constant\n', '    returns (uint) \n', '  {\n', '    return SafeMath.div(SafeMath.mul(_wei, _rate), 1 ether);\n', '  } \n', '  \n', '  // Given the rate of a purchase and the remaining tokens in this tranche, it\n', '  // will throw if the sale would take it past the limit of the tranche.\n', '  // Returns `amount` in scope as the number of DANS tokens that it will purchase.\n', '  function processPurchase(uint _rate, uint _remaining)\n', '    internal\n', '    returns (uint o_amount)\n', '  {\n', '    o_amount = calcAmount(msg.value, _rate);\n', '\n', '    if (o_amount > _remaining) revert();\n', '    if (!multisigAddress.send(msg.value)) revert();\n', '\n', '    balances[ownerAddress] = balances[ownerAddress].sub(o_amount);\n', '    balances[msg.sender] = balances[msg.sender].add(o_amount);\n', '\n', '    DANSSold += o_amount;\n', '    etherRaised += msg.value;\n', '  }\n', '\n', '  //Special Function can only be called by pre-buy and only during the pre-crowdsale period.\n', '  function preBuy()\n', '    payable\n', '    is_pre_crowdfund_period\n', '    is_not_halted\n', '  {\n', '    // Pre-buy participants would get the first-day price, as well as a bonus of vested tokens\n', '    uint priceVested = 0;\n', '\n', '    if (msg.sender == preBuy1) priceVested = preBuyPrice1;\n', '    if (msg.sender == preBuy2) priceVested = preBuyPrice2;\n', '    if (msg.sender == preBuy3) priceVested = preBuyPrice3;\n', '\n', '    if (priceVested == 0) revert();\n', '\n', '    uint amount = processPurchase(PRICE_STAGE_ONE + priceVested, SafeMath.sub(PREBUY_PORTION_MAX, prebuyPortionTotal));\n', '    grantVestedTokens(msg.sender, calcAmount(msg.value, priceVested), \n', '      uint64(now), uint64(now) + 91 days, uint64(now) + 365 days, \n', '      false, false\n', '    );\n', '    prebuyPortionTotal += amount;\n', '    PreBuy(amount);\n', '  }\n', '\n', '  //Default function called by sending Ether to this address with no arguments.\n', '  //Results in creation of new DANS Tokens if transaction would not exceed hard limit of DANS Token.\n', '  function()\n', '    payable\n', '    is_crowdfund_period\n', '    is_not_halted\n', '  {\n', '    uint amount = processPurchase(getPriceRate(), SafeMath.sub(ALLOC_CROWDSALE, DANSSold));\n', '    Buy(msg.sender, amount);\n', '  }\n', '\n', '  // To be called at the end of crowdfund period\n', '  // WARNING: transfer(), which is called by grantVestedTokens(), wants a minimum message length\n', '  function grantVested(address _danserviceTeamAddress, address _danserviceFundAddress)\n', '    is_crowdfund_completed\n', '    only_owner\n', '    is_not_halted\n', '  {\n', '    // Grant tokens pre-allocated for the team\n', '    grantVestedTokens(\n', '      _danserviceTeamAddress, ALLOC_TEAM,\n', '      uint64(now), uint64(now) + 91 days , uint64(now) + 365 days, \n', '      false, false\n', '    );\n', '\n', '    // Grant tokens that remain after crowdsale to the DAN-Service coin fund, vested for 2 years\n', '    grantVestedTokens(\n', '      _danserviceFundAddress, balances[ownerAddress],\n', '      uint64(now), uint64(now) + 182 days , uint64(now) + 730 days, \n', '      false, false\n', '    );\n', '  }\n', '\n', '  //May be used by owner of contract to halt crowdsale and no longer except ether.\n', '  function toggleHalt(bool _halted)\n', '    only_owner\n', '  {\n', '    halted = _halted;\n', '  }\n', '\n', '  //failsafe drain\n', '  function drain()\n', '    only_owner\n', '  {\n', '    if (!ownerAddress.send(address(this).balance)) revert();\n', '  }\n', '}']
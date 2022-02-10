['pragma solidity ^0.4.8;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * @title LimitedTransferToken\n', ' * @dev LimitedTransferToken defines the generic interface and the implementation to limit token \n', ' * transferability for different events. It is intended to be used as a base class for other token \n', ' * contracts. \n', ' * LimitedTransferToken has been designed to allow for different limiting factors,\n', ' * this can be achieved by recursively calling super.transferableTokens() until the base class is \n', ' * hit. For example:\n', ' *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {\n', ' *       return min256(unlockedTokens, super.transferableTokens(holder, time));\n', ' *     }\n', ' * A working example is VestedToken.sol:\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol\n', ' */\n', '\n', 'contract LimitedTransferToken is ERC20 {\n', '\n', '  /**\n', '   * @dev Checks whether it can transfer or otherwise throws.\n', '   */\n', '  modifier canTransfer(address _sender, uint _value) {\n', '   if (_value > transferableTokens(_sender, uint64(now))) throw;\n', '   _;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks modifier and allows transfer if tokens are not locked.\n', '   * @param _to The address that will recieve the tokens.\n', '   * @param _value The amount of tokens to be transferred.\n', '   */\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {\n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Checks modifier and allows transfer if tokens are not locked.\n', '  * @param _from The address that will send the tokens.\n', '  * @param _to The address that will recieve the tokens.\n', '  * @param _value The amount of tokens to be transferred.\n', '  */\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {\n', '   return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Default transferable tokens function returns all tokens for a holder (no limit).\n', '   * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the \n', '   * specific logic for limiting token transferability for a holder over time.\n', '   */\n', '  function transferableTokens(address holder, uint64 time) constant public returns (uint256) {\n', '    return balanceOf(holder);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  /**\n', '   * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implemantation of the basic standart token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint _value) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Vested token\n', ' * @dev Tokens that can be vested for a group of addresses.\n', ' */\n', 'contract VestedToken is StandardToken, LimitedTransferToken {\n', '\n', '  uint256 MAX_GRANTS_PER_ADDRESS = 20;\n', '\n', '  struct TokenGrant {\n', '    address granter;     // 20 bytes\n', '    uint256 value;       // 32 bytes\n', '    uint64 cliff;\n', '    uint64 vesting;\n', '    uint64 start;        // 3 * 8 = 24 bytes\n', '    bool revokable;\n', '    bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?\n', '  } // total 78 bytes = 3 sstore per operation (32 per sstore)\n', '\n', '  mapping (address => TokenGrant[]) public grants;\n', '\n', '  event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);\n', '\n', '  /**\n', '   * @dev Grant tokens to a specified address\n', '   * @param _to address The address which the tokens will be granted to.\n', '   * @param _value uint256 The amount of tokens to be granted.\n', '   * @param _start uint64 Time of the beginning of the grant.\n', '   * @param _cliff uint64 Time of the cliff period.\n', '   * @param _vesting uint64 The vesting period.\n', '   */\n', '  function grantVestedTokens(\n', '    address _to,\n', '    uint256 _value,\n', '    uint64 _start,\n', '    uint64 _cliff,\n', '    uint64 _vesting,\n', '    bool _revokable,\n', '    bool _burnsOnRevoke\n', '  ) public {\n', '\n', '    // Check for date inconsistencies that may cause unexpected behavior\n', '    if (_cliff < _start || _vesting < _cliff) {\n', '      throw;\n', '    }\n', '\n', '    if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) throw;   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).\n', '\n', '    uint count = grants[_to].push(\n', '                TokenGrant(\n', '                  _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable\n', '                  _value,\n', '                  _cliff,\n', '                  _vesting,\n', '                  _start,\n', '                  _revokable,\n', '                  _burnsOnRevoke\n', '                )\n', '              );\n', '\n', '    transfer(_to, _value);\n', '\n', '    NewTokenGrant(msg.sender, _to, _value, count - 1);\n', '  }\n', '\n', '  /**\n', '   * @dev Revoke the grant of tokens of a specifed address.\n', '   * @param _holder The address which will have its tokens revoked.\n', '   * @param _grantId The id of the token grant.\n', '   */\n', '  function revokeTokenGrant(address _holder, uint _grantId) public {\n', '    TokenGrant grant = grants[_holder][_grantId];\n', '\n', '    if (!grant.revokable) { // Check if grant was revokable\n', '      throw;\n', '    }\n', '\n', '    if (grant.granter != msg.sender) { // Only granter can revoke it\n', '      throw;\n', '    }\n', '\n', '    address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;\n', '\n', '    uint256 nonVested = nonVestedTokens(grant, uint64(now));\n', '\n', '    // remove grant from array\n', '    delete grants[_holder][_grantId];\n', '    grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];\n', '    grants[_holder].length -= 1;\n', '\n', '    balances[receiver] = balances[receiver].add(nonVested);\n', '    balances[_holder] = balances[_holder].sub(nonVested);\n', '\n', '    Transfer(_holder, receiver, nonVested);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Calculate the total amount of transferable tokens of a holder at a given time\n', '   * @param holder address The address of the holder\n', '   * @param time uint64 The specific time.\n', '   * @return An uint representing a holder&#39;s total amount of transferable tokens.\n', '   */\n', '  function transferableTokens(address holder, uint64 time) constant public returns (uint256) {\n', '    uint256 grantIndex = tokenGrantsCount(holder);\n', '\n', '    if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants\n', '\n', '    // Iterate through all the grants the holder has, and add all non-vested tokens\n', '    uint256 nonVested = 0;\n', '    for (uint256 i = 0; i < grantIndex; i++) {\n', '      nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));\n', '    }\n', '\n', '    // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time\n', '    uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);\n', '\n', '    // Return the minimum of how many vested can transfer and other value\n', '    // in case there are other limiting transferability factors (default is balanceOf)\n', '    return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));\n', '  }\n', '\n', '  /**\n', '   * @dev Check the amount of grants that an address has.\n', '   * @param _holder The holder of the grants.\n', '   * @return A uint representing the total amount of grants.\n', '   */\n', '  function tokenGrantsCount(address _holder) constant returns (uint index) {\n', '    return grants[_holder].length;\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate amount of vested tokens at a specifc time.\n', '   * @param tokens uint256 The amount of tokens grantted.\n', '   * @param time uint64 The time to be checked\n', '   * @param start uint64 A time representing the begining of the grant\n', '   * @param cliff uint64 The cliff period.\n', '   * @param vesting uint64 The vesting period.\n', '   * @return An uint representing the amount of vested tokensof a specif grant.\n', '   *  transferableTokens\n', '   *   |                         _/--------   vestedTokens rect\n', '   *   |                       _/\n', '   *   |                     _/\n', '   *   |                   _/\n', '   *   |                 _/\n', '   *   |                /\n', '   *   |              .|\n', '   *   |            .  |\n', '   *   |          .    |\n', '   *   |        .      |\n', '   *   |      .        |\n', '   *   |    .          |\n', '   *   +===+===========+---------+----------> time\n', '   *      Start       Clift    Vesting\n', '   */\n', '  function calculateVestedTokens(\n', '    uint256 tokens,\n', '    uint256 time,\n', '    uint256 start,\n', '    uint256 cliff,\n', '    uint256 vesting) constant returns (uint256)\n', '    {\n', '      // Shortcuts for before cliff and after vesting cases.\n', '      if (time < cliff) return 0;\n', '      if (time >= vesting) return tokens;\n', '\n', '      // Interpolate all vested tokens.\n', '      // As before cliff the shortcut returns 0, we can use just calculate a value\n', '      // in the vesting rect (as shown in above&#39;s figure)\n', '\n', '      // vestedTokens = tokens * (time - start) / (vesting - start)\n', '      uint256 vestedTokens = SafeMath.div(\n', '                                    SafeMath.mul(\n', '                                      tokens,\n', '                                      SafeMath.sub(time, start)\n', '                                      ),\n', '                                    SafeMath.sub(vesting, start)\n', '                                    );\n', '\n', '      return vestedTokens;\n', '  }\n', '\n', '  /**\n', '   * @dev Get all information about a specifc grant.\n', '   * @param _holder The address which will have its tokens revoked.\n', '   * @param _grantId The id of the token grant.\n', '   * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,\n', '   * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.\n', '   */\n', '  function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {\n', '    TokenGrant grant = grants[_holder][_grantId];\n', '\n', '    granter = grant.granter;\n', '    value = grant.value;\n', '    start = grant.start;\n', '    cliff = grant.cliff;\n', '    vesting = grant.vesting;\n', '    revokable = grant.revokable;\n', '    burnsOnRevoke = grant.burnsOnRevoke;\n', '\n', '    vested = vestedTokens(grant, uint64(now));\n', '  }\n', '\n', '  /**\n', '   * @dev Get the amount of vested tokens at a specific time.\n', '   * @param grant TokenGrant The grant to be checked.\n', '   * @param time The time to be checked\n', '   * @return An uint representing the amount of vested tokens of a specific grant at a specific time.\n', '   */\n', '  function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {\n', '    return calculateVestedTokens(\n', '      grant.value,\n', '      uint256(time),\n', '      uint256(grant.start),\n', '      uint256(grant.cliff),\n', '      uint256(grant.vesting)\n', '    );\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate the amount of non vested tokens at a specific time.\n', '   * @param grant TokenGrant The grant to be checked.\n', '   * @param time uint64 The time to be checked\n', '   * @return An uint representing the amount of non vested tokens of a specifc grant on the \n', '   * passed time frame.\n', '   */\n', '  function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {\n', '    return grant.value.sub(vestedTokens(grant, time));\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate the date when the holder can trasfer all its tokens\n', '   * @param holder address The address of the holder\n', '   * @return An uint representing the date of the last transferable tokens.\n', '   */\n', '  function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {\n', '    date = uint64(now);\n', '    uint256 grantIndex = grants[holder].length;\n', '    for (uint256 i = 0; i < grantIndex; i++) {\n', '      date = SafeMath.max64(grants[holder][i].vesting, date);\n', '    }\n', '  }\n', '}\n', '\n', 'contract CDTToken is VestedToken {\n', '\tusing SafeMath for uint;\n', '\n', '\t//FIELDS\n', '\t//CONSTANTS\n', '\tuint public constant decimals = 18;  // 18 decimal places, the same as ETH.\n', '\tstring public constant name = "CoinDash Token";\n', '  \tstring public constant symbol = "CDT";\n', '\n', '\t//ASSIGNED IN INITIALIZATION\n', '\taddress public creator; //address of the account which may mint new tokens\n', '\n', '\t//May only be called by the owner address\n', '\tmodifier only_owner() {\n', '\t\tif (msg.sender != creator) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\n', '\t// Initialization contract assigns address of crowdfund contract and end time.\n', '\tfunction CDTToken(uint supply) {\n', '\t\ttotalSupply = supply;\n', '\t\tcreator = msg.sender;\n', '\t\t\n', '\t\tbalances[msg.sender] = supply;\n', '\n', '\t\tMAX_GRANTS_PER_ADDRESS = 2;\n', '\t}\n', '\n', '\t// Fallback function throws when called.\n', '\tfunction() {\n', '\t\tthrow;\n', '\t}\n', '\n', '\tfunction vestedBalanceOf(address _owner) constant returns (uint balance) {\n', '\t    return transferableTokens(_owner, uint64(now));\n', '    }\n', '\n', '        //failsafe drain\n', '\tfunction drain()\n', '\t\tonly_owner\n', '\t{\n', '\t\tif (!creator.send(this.balance)) throw;\n', '\t}\n', '}']
['pragma solidity ^0.4.8;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * @title LimitedTransferToken\n', ' * @dev LimitedTransferToken defines the generic interface and the implementation to limit token \n', ' * transferability for different events. It is intended to be used as a base class for other token \n', ' * contracts. \n', ' * LimitedTransferToken has been designed to allow for different limiting factors,\n', ' * this can be achieved by recursively calling super.transferableTokens() until the base class is \n', ' * hit. For example:\n', ' *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {\n', ' *       return min256(unlockedTokens, super.transferableTokens(holder, time));\n', ' *     }\n', ' * A working example is VestedToken.sol:\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol\n', ' */\n', '\n', 'contract LimitedTransferToken is ERC20 {\n', '\n', '  /**\n', '   * @dev Checks whether it can transfer or otherwise throws.\n', '   */\n', '  modifier canTransfer(address _sender, uint _value) {\n', '   if (_value > transferableTokens(_sender, uint64(now))) throw;\n', '   _;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks modifier and allows transfer if tokens are not locked.\n', '   * @param _to The address that will recieve the tokens.\n', '   * @param _value The amount of tokens to be transferred.\n', '   */\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {\n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Checks modifier and allows transfer if tokens are not locked.\n', '  * @param _from The address that will send the tokens.\n', '  * @param _to The address that will recieve the tokens.\n', '  * @param _value The amount of tokens to be transferred.\n', '  */\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {\n', '   return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Default transferable tokens function returns all tokens for a holder (no limit).\n', '   * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the \n', '   * specific logic for limiting token transferability for a holder over time.\n', '   */\n', '  function transferableTokens(address holder, uint64 time) constant public returns (uint256) {\n', '    return balanceOf(holder);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  /**\n', '   * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implemantation of the basic standart token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint _value) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Vested token\n', ' * @dev Tokens that can be vested for a group of addresses.\n', ' */\n', 'contract VestedToken is StandardToken, LimitedTransferToken {\n', '\n', '  uint256 MAX_GRANTS_PER_ADDRESS = 20;\n', '\n', '  struct TokenGrant {\n', '    address granter;     // 20 bytes\n', '    uint256 value;       // 32 bytes\n', '    uint64 cliff;\n', '    uint64 vesting;\n', '    uint64 start;        // 3 * 8 = 24 bytes\n', '    bool revokable;\n', '    bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?\n', '  } // total 78 bytes = 3 sstore per operation (32 per sstore)\n', '\n', '  mapping (address => TokenGrant[]) public grants;\n', '\n', '  event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);\n', '\n', '  /**\n', '   * @dev Grant tokens to a specified address\n', '   * @param _to address The address which the tokens will be granted to.\n', '   * @param _value uint256 The amount of tokens to be granted.\n', '   * @param _start uint64 Time of the beginning of the grant.\n', '   * @param _cliff uint64 Time of the cliff period.\n', '   * @param _vesting uint64 The vesting period.\n', '   */\n', '  function grantVestedTokens(\n', '    address _to,\n', '    uint256 _value,\n', '    uint64 _start,\n', '    uint64 _cliff,\n', '    uint64 _vesting,\n', '    bool _revokable,\n', '    bool _burnsOnRevoke\n', '  ) public {\n', '\n', '    // Check for date inconsistencies that may cause unexpected behavior\n', '    if (_cliff < _start || _vesting < _cliff) {\n', '      throw;\n', '    }\n', '\n', '    if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) throw;   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).\n', '\n', '    uint count = grants[_to].push(\n', '                TokenGrant(\n', '                  _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable\n', '                  _value,\n', '                  _cliff,\n', '                  _vesting,\n', '                  _start,\n', '                  _revokable,\n', '                  _burnsOnRevoke\n', '                )\n', '              );\n', '\n', '    transfer(_to, _value);\n', '\n', '    NewTokenGrant(msg.sender, _to, _value, count - 1);\n', '  }\n', '\n', '  /**\n', '   * @dev Revoke the grant of tokens of a specifed address.\n', '   * @param _holder The address which will have its tokens revoked.\n', '   * @param _grantId The id of the token grant.\n', '   */\n', '  function revokeTokenGrant(address _holder, uint _grantId) public {\n', '    TokenGrant grant = grants[_holder][_grantId];\n', '\n', '    if (!grant.revokable) { // Check if grant was revokable\n', '      throw;\n', '    }\n', '\n', '    if (grant.granter != msg.sender) { // Only granter can revoke it\n', '      throw;\n', '    }\n', '\n', '    address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;\n', '\n', '    uint256 nonVested = nonVestedTokens(grant, uint64(now));\n', '\n', '    // remove grant from array\n', '    delete grants[_holder][_grantId];\n', '    grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];\n', '    grants[_holder].length -= 1;\n', '\n', '    balances[receiver] = balances[receiver].add(nonVested);\n', '    balances[_holder] = balances[_holder].sub(nonVested);\n', '\n', '    Transfer(_holder, receiver, nonVested);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Calculate the total amount of transferable tokens of a holder at a given time\n', '   * @param holder address The address of the holder\n', '   * @param time uint64 The specific time.\n', "   * @return An uint representing a holder's total amount of transferable tokens.\n", '   */\n', '  function transferableTokens(address holder, uint64 time) constant public returns (uint256) {\n', '    uint256 grantIndex = tokenGrantsCount(holder);\n', '\n', '    if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants\n', '\n', '    // Iterate through all the grants the holder has, and add all non-vested tokens\n', '    uint256 nonVested = 0;\n', '    for (uint256 i = 0; i < grantIndex; i++) {\n', '      nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));\n', '    }\n', '\n', '    // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time\n', '    uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);\n', '\n', '    // Return the minimum of how many vested can transfer and other value\n', '    // in case there are other limiting transferability factors (default is balanceOf)\n', '    return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));\n', '  }\n', '\n', '  /**\n', '   * @dev Check the amount of grants that an address has.\n', '   * @param _holder The holder of the grants.\n', '   * @return A uint representing the total amount of grants.\n', '   */\n', '  function tokenGrantsCount(address _holder) constant returns (uint index) {\n', '    return grants[_holder].length;\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate amount of vested tokens at a specifc time.\n', '   * @param tokens uint256 The amount of tokens grantted.\n', '   * @param time uint64 The time to be checked\n', '   * @param start uint64 A time representing the begining of the grant\n', '   * @param cliff uint64 The cliff period.\n', '   * @param vesting uint64 The vesting period.\n', '   * @return An uint representing the amount of vested tokensof a specif grant.\n', '   *  transferableTokens\n', '   *   |                         _/--------   vestedTokens rect\n', '   *   |                       _/\n', '   *   |                     _/\n', '   *   |                   _/\n', '   *   |                 _/\n', '   *   |                /\n', '   *   |              .|\n', '   *   |            .  |\n', '   *   |          .    |\n', '   *   |        .      |\n', '   *   |      .        |\n', '   *   |    .          |\n', '   *   +===+===========+---------+----------> time\n', '   *      Start       Clift    Vesting\n', '   */\n', '  function calculateVestedTokens(\n', '    uint256 tokens,\n', '    uint256 time,\n', '    uint256 start,\n', '    uint256 cliff,\n', '    uint256 vesting) constant returns (uint256)\n', '    {\n', '      // Shortcuts for before cliff and after vesting cases.\n', '      if (time < cliff) return 0;\n', '      if (time >= vesting) return tokens;\n', '\n', '      // Interpolate all vested tokens.\n', '      // As before cliff the shortcut returns 0, we can use just calculate a value\n', "      // in the vesting rect (as shown in above's figure)\n", '\n', '      // vestedTokens = tokens * (time - start) / (vesting - start)\n', '      uint256 vestedTokens = SafeMath.div(\n', '                                    SafeMath.mul(\n', '                                      tokens,\n', '                                      SafeMath.sub(time, start)\n', '                                      ),\n', '                                    SafeMath.sub(vesting, start)\n', '                                    );\n', '\n', '      return vestedTokens;\n', '  }\n', '\n', '  /**\n', '   * @dev Get all information about a specifc grant.\n', '   * @param _holder The address which will have its tokens revoked.\n', '   * @param _grantId The id of the token grant.\n', '   * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,\n', '   * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.\n', '   */\n', '  function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {\n', '    TokenGrant grant = grants[_holder][_grantId];\n', '\n', '    granter = grant.granter;\n', '    value = grant.value;\n', '    start = grant.start;\n', '    cliff = grant.cliff;\n', '    vesting = grant.vesting;\n', '    revokable = grant.revokable;\n', '    burnsOnRevoke = grant.burnsOnRevoke;\n', '\n', '    vested = vestedTokens(grant, uint64(now));\n', '  }\n', '\n', '  /**\n', '   * @dev Get the amount of vested tokens at a specific time.\n', '   * @param grant TokenGrant The grant to be checked.\n', '   * @param time The time to be checked\n', '   * @return An uint representing the amount of vested tokens of a specific grant at a specific time.\n', '   */\n', '  function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {\n', '    return calculateVestedTokens(\n', '      grant.value,\n', '      uint256(time),\n', '      uint256(grant.start),\n', '      uint256(grant.cliff),\n', '      uint256(grant.vesting)\n', '    );\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate the amount of non vested tokens at a specific time.\n', '   * @param grant TokenGrant The grant to be checked.\n', '   * @param time uint64 The time to be checked\n', '   * @return An uint representing the amount of non vested tokens of a specifc grant on the \n', '   * passed time frame.\n', '   */\n', '  function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {\n', '    return grant.value.sub(vestedTokens(grant, time));\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate the date when the holder can trasfer all its tokens\n', '   * @param holder address The address of the holder\n', '   * @return An uint representing the date of the last transferable tokens.\n', '   */\n', '  function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {\n', '    date = uint64(now);\n', '    uint256 grantIndex = grants[holder].length;\n', '    for (uint256 i = 0; i < grantIndex; i++) {\n', '      date = SafeMath.max64(grants[holder][i].vesting, date);\n', '    }\n', '  }\n', '}\n', '\n', 'contract CDTToken is VestedToken {\n', '\tusing SafeMath for uint;\n', '\n', '\t//FIELDS\n', '\t//CONSTANTS\n', '\tuint public constant decimals = 18;  // 18 decimal places, the same as ETH.\n', '\tstring public constant name = "CoinDash Token";\n', '  \tstring public constant symbol = "CDT";\n', '\n', '\t//ASSIGNED IN INITIALIZATION\n', '\taddress public creator; //address of the account which may mint new tokens\n', '\n', '\t//May only be called by the owner address\n', '\tmodifier only_owner() {\n', '\t\tif (msg.sender != creator) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\n', '\t// Initialization contract assigns address of crowdfund contract and end time.\n', '\tfunction CDTToken(uint supply) {\n', '\t\ttotalSupply = supply;\n', '\t\tcreator = msg.sender;\n', '\t\t\n', '\t\tbalances[msg.sender] = supply;\n', '\n', '\t\tMAX_GRANTS_PER_ADDRESS = 2;\n', '\t}\n', '\n', '\t// Fallback function throws when called.\n', '\tfunction() {\n', '\t\tthrow;\n', '\t}\n', '\n', '\tfunction vestedBalanceOf(address _owner) constant returns (uint balance) {\n', '\t    return transferableTokens(_owner, uint64(now));\n', '    }\n', '\n', '        //failsafe drain\n', '\tfunction drain()\n', '\t\tonly_owner\n', '\t{\n', '\t\tif (!creator.send(this.balance)) throw;\n', '\t}\n', '}']

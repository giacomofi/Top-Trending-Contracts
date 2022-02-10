['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '/*****\n', '    * Orginally from https://github.com/OpenZeppelin/zeppelin-solidity\n', '    * Modified by https://github.com/agarwalakarsh\n', '    */\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '/*****\n', '    * @title Basic Token\n', '    * @dev Basic Version of a Generic Token\n', '    */\n', 'contract ERC20BasicToken is Pausable{\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    //Fix for the ERC20 short address attack.\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4) ;\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) whenNotPaused internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balances[_from] >= _value);\n', '        // Check for overflows\n', '        require(balances[_to] + _value > balances[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balances[_from] + balances[_to];\n', '        // Subtract from the sender\n', '        balances[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) whenNotPaused onlyPayloadSize(2 * 32) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) whenNotPaused onlyPayloadSize(2 * 32) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @notice Create `mintedAmount` tokens and send it to `target`\n', '     * @param target Address to receive the tokens\n', '     * @param mintedAmount the amount of tokens it will receive\n', '     */\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balances[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '  \t * Return balance of an account\n', '     * @param _owner the address to get balance\n', '  \t */\n', '  \tfunction balanceOf(address _owner) public constant returns (uint balance) {\n', '  \t\treturn balances[_owner];\n', '  \t}\n', '\n', '    /**\n', '  \t * Return allowance for other address\n', '     * @param _owner The address spend to the other\n', '     * @param _spender The address authorized to spend\n', '  \t */\n', '  \tfunction allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '  \t\treturn allowance[_owner][_spender];\n', '  \t}\n', '}\n', '\n', 'contract JWCToken is ERC20BasicToken {\n', '\tusing SafeMath for uint256;\n', '\n', '\tstring public constant name      = "JWC Blockchain Ventures";   //tokens name\n', '\tstring public constant symbol    = "JWC";                       //token symbol\n', '\tuint256 public constant decimals = 18;                          //token decimal\n', '\tstring public constant version   = "1.0";                       //tokens version\n', '\n', '\tuint256 public constant tokenPreSale         = 100000000 * 10**decimals;//tokens for pre-sale\n', '\tuint256 public constant tokenPublicSale      = 400000000 * 10**decimals;//tokens for public-sale\n', '\tuint256 public constant tokenReserve         = 300000000 * 10**decimals;//tokens for reserve\n', '\tuint256 public constant tokenTeamSupporter   = 120000000 * 10**decimals;//tokens for Team & Supporter\n', '\tuint256 public constant tokenAdvisorPartners = 80000000  * 10**decimals;//tokens for Advisor\n', '\n', '\taddress public icoContract;\n', '\n', '\t// constructor\n', '\tfunction JWCToken() public {\n', '\t\ttotalSupply = tokenPreSale + tokenPublicSale + tokenReserve + tokenTeamSupporter + tokenAdvisorPartners;\n', '\t}\n', '\n', '\t/**\n', '\t * Set ICO Contract for this token to make sure called by our ICO contract\n', '\t * @param _icoContract - ICO Contract address\n', '\t */\n', '\tfunction setIcoContract(address _icoContract) public onlyOwner {\n', '\t\tif (_icoContract != address(0)) {\n', '\t\t\ticoContract = _icoContract;\n', '\t\t}\n', '\t}\n', '\n', '\t/**\n', '\t * Sell tokens when ICO. Only called by ICO Contract\n', '\t * @param _recipient - address send ETH to buy tokens\n', '\t * @param _value - amount of ETHs\n', '\t */\n', '\tfunction sell(address _recipient, uint256 _value) public whenNotPaused returns (bool success) {\n', '\t\tassert(_value > 0);\n', '\t\trequire(msg.sender == icoContract);\n', '\n', '\t\tbalances[_recipient] = balances[_recipient].add(_value);\n', '\n', '\t\tTransfer(0x0, _recipient, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Pay bonus & affiliate to address\n', '\t * @param _recipient - address to receive bonus & affiliate\n', '\t * @param _value - value bonus & affiliate to give\n', '\t */\n', '\tfunction payBonusAffiliate(address _recipient, uint256 _value) public returns (bool success) {\n', '\t\tassert(_value > 0);\n', '\t\trequire(msg.sender == icoContract);\n', '\n', '\t\tbalances[_recipient] = balances[_recipient].add(_value);\n', '\t\ttotalSupply = totalSupply.add(_value);\n', '\n', '\t\tTransfer(0x0, _recipient, _value);\n', '\t\treturn true;\n', '\t}\n', '}\n', '\n', '/**\n', ' * Store config of phase ICO\n', ' */\n', 'contract IcoPhase {\n', '  uint256 public constant phasePresale_From = 1516456800;//14h 20/01/2018 GMT\n', '  uint256 public constant phasePresale_To = 1517839200;//14h 05/02/2018 GMT\n', '\n', '  uint256 public constant phasePublicSale1_From = 1519912800;//14h 01/03/2018 GMT\n', '  uint256 public constant phasePublicSale1_To = 1520344800;//14h 06/03/2018 GMT\n', '\n', '  uint256 public constant phasePublicSale2_From = 1520344800;//14h 06/03/2018 GMT\n', '  uint256 public constant phasePublicSale2_To = 1520776800;//14h 11/03/2018 GMT\n', '\n', '  uint256 public constant phasePublicSale3_From = 1520776800;//14h 11/03/2018 GMT\n', '  uint256 public constant phasePublicSale3_To = 1521208800;//14h 16/03/2018 GMT\n', '}\n', '\n', '/**\n', ' * This contract will give bonus for user when buy tokens. The bonus will be paid after finishing ICO\n', ' */\n', 'contract Bonus is IcoPhase, Ownable {\n', '\tusing SafeMath for uint256;\n', '\n', '\t//decimals of tokens\n', '\tuint256 constant decimals = 18;\n', '\n', '\t//enable/disable\n', '\tbool public isBonus;\n', '\n', '\t//max tokens for time bonus\n', '\tuint256 public maxTimeBonus = 225000000*10**decimals;\n', '\n', '\t//max tokens for amount bonus\n', '\tuint256 public maxAmountBonus = 125000000*10**decimals;\n', '\n', '\t//storage\n', '\tmapping(address => uint256) public bonusAccountBalances;\n', '\tmapping(uint256 => address) public bonusAccountIndex;\n', '\tuint256 public bonusAccountCount;\n', '\n', '\tuint256 public indexPaidBonus;//amount of accounts have been paid bonus\n', '\n', '\tfunction Bonus() public {\n', '\t\tisBonus = true;\n', '\t}\n', '\n', '\t/**\n', '\t * Enable bonus\n', '\t */\n', '\tfunction enableBonus() public onlyOwner returns (bool)\n', '\t{\n', '\t\trequire(!isBonus);\n', '\t\tisBonus=true;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Disable bonus\n', '\t */\n', '\tfunction disableBonus() public onlyOwner returns (bool)\n', '\t{\n', '\t\trequire(isBonus);\n', '\t\tisBonus=false;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Get bonus percent by time\n', '\t */\n', '\tfunction getTimeBonus() public constant returns(uint256) {\n', '\t\tuint256 bonus = 0;\n', '\n', '\t\tif(now>=phasePresale_From && now<phasePresale_To){\n', '\t\t\tbonus = 40;\n', '\t\t} else if (now>=phasePublicSale1_From && now<phasePublicSale1_To) {\n', '\t\t\tbonus = 20;\n', '\t\t} else if (now>=phasePublicSale2_From && now<phasePublicSale2_To) {\n', '\t\t\tbonus = 10;\n', '\t\t} else if (now>=phasePublicSale3_From && now<phasePublicSale3_To) {\n', '\t\t\tbonus = 5;\n', '\t\t}\n', '\n', '\t\treturn bonus;\n', '\t}\n', '\n', '\t/**\n', '\t * Get bonus by eth\n', '\t * @param _value - eth to convert to bonus\n', '\t */\n', '\tfunction getBonusByETH(uint256 _value) public pure returns(uint256) {\n', '\t\tuint256 bonus = 0;\n', '\n', '\t\tif(_value>=1500*10**decimals){\n', '\t\t\tbonus=_value.mul(25)/100;\n', '\t\t} else if(_value>=300*10**decimals){\n', '\t\t\tbonus=_value.mul(20)/100;\n', '\t\t} else if(_value>=150*10**decimals){\n', '\t\t\tbonus=_value.mul(15)/100;\n', '\t\t} else if(_value>=30*10**decimals){\n', '\t\t\tbonus=_value.mul(10)/100;\n', '\t\t} else if(_value>=15*10**decimals){\n', '\t\t\tbonus=_value.mul(5)/100;\n', '\t\t}\n', '\n', '\t\treturn bonus;\n', '\t}\n', '\n', '\t/**\n', '\t * Get bonus balance of an account\n', '\t * @param _owner - the address to get bonus of\n', '\t */\n', '\tfunction balanceBonusOf(address _owner) public constant returns (uint256 balance)\n', '\t{\n', '\t\treturn bonusAccountBalances[_owner];\n', '\t}\n', '\n', '\t/**\n', '\t * Get bonus balance of an account\n', '\t */\n', '\tfunction payBonus() public onlyOwner returns (bool success);\n', '}\n', '\n', '\n', '/**\n', ' * This contract will give affiliate for user when buy tokens. The affiliate will be paid after finishing ICO\n', ' */\n', 'contract Affiliate is Ownable {\n', '\n', '\t//Control Affiliate feature.\n', '\tbool public isAffiliate;\n', '\n', '\t//Affiliate level, init is 1\n', '\tuint256 public affiliateLevel = 1;\n', '\n', '\t//Each user will have different rate\n', '\tmapping(uint256 => uint256) public affiliateRate;\n', '\n', '\t//Keep balance of user\n', '\tmapping(address => uint256) public referralBalance;//referee=>value\n', '\n', '\tmapping(address => address) public referral;//referee=>referrer\n', '\tmapping(uint256 => address) public referralIndex;//index=>referee\n', '\n', '\tuint256 public referralCount;\n', '\n', '\t//amount of accounts have been paid affiliate\n', '\tuint256 public indexPaidAffiliate;\n', '\n', '\t// max tokens for affiliate\n', '\tuint256 public maxAffiliate = 100000000*(10**18);\n', '\n', '\t/**\n', '\t * Throw if affiliate is disable\n', '\t */\n', '\tmodifier whenAffiliate() {\n', '\t\trequire (isAffiliate);\n', '\t\t_;\n', '\t}\n', '\n', '\t/**\n', '\t * constructor affiliate with level 1 rate = 10%\n', '\t */\n', '\tfunction Affiliate() public {\n', '\t\tisAffiliate=true;\n', '\t\taffiliateLevel=1;\n', '\t\taffiliateRate[0]=10;\n', '\t}\n', '\n', '\t/**\n', '\t * Enable affiliate for the contract\n', '\t */\n', '\tfunction enableAffiliate() public onlyOwner returns (bool) {\n', '\t\trequire (!isAffiliate);\n', '\t\tisAffiliate=true;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Disable affiliate for the contract\n', '\t */\n', '\tfunction disableAffiliate() public onlyOwner returns (bool) {\n', '\t\trequire (isAffiliate);\n', '\t\tisAffiliate=false;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Return current affiliate level\n', '\t */\n', '\tfunction getAffiliateLevel() public constant returns(uint256)\n', '\t{\n', '\t\treturn affiliateLevel;\n', '\t}\n', '\n', '\t/**\n', '\t * Update affiliate level by owner\n', '\t * @param _level - new level\n', '\t */\n', '\tfunction setAffiliateLevel(uint256 _level) public onlyOwner whenAffiliate returns(bool)\n', '\t{\n', '\t\taffiliateLevel=_level;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Get referrer address\n', '\t * @param _referee - the referee address\n', '\t */\n', '\tfunction getReferrerAddress(address _referee) public constant returns (address)\n', '\t{\n', '\t\treturn referral[_referee];\n', '\t}\n', '\n', '\t/**\n', '\t * Get referee address\n', '\t * @param _referrer - the referrer address\n', '\t */\n', '\tfunction getRefereeAddress(address _referrer) public constant returns (address[] _referee)\n', '\t{\n', '\t\taddress[] memory refereeTemp = new address[](referralCount);\n', '\t\tuint count = 0;\n', '\t\tuint i;\n', '\t\tfor (i=0; i<referralCount; i++){\n', '\t\t\tif(referral[referralIndex[i]] == _referrer){\n', '\t\t\t\trefereeTemp[count] = referralIndex[i];\n', '\n', '\t\t\t\tcount += 1;\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\t_referee = new address[](count);\n', '\t\tfor (i=0; i<count; i++)\n', '\t\t\t_referee[i] = refereeTemp[i];\n', '\t}\n', '\n', '\t/**\n', '\t * Mapping referee address with referrer address\n', '\t * @param _parent - the referrer address\n', '\t * @param _child - the referee address\n', '\t */\n', '\tfunction setReferralAddress(address _parent, address _child) public onlyOwner whenAffiliate returns (bool)\n', '\t{\n', '\t\trequire(_parent != address(0x00));\n', '\t\trequire(_child != address(0x00));\n', '\n', '\t\treferralIndex[referralCount]=_child;\n', '\t\treferral[_child]=_parent;\n', '\t\treferralCount++;\n', '\n', '\t\treferralBalance[_child]=0;\n', '\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Get affiliate rate by level\n', '\t * @param _level - level to get affiliate rate\n', '\t */\n', '\tfunction getAffiliateRate(uint256 _level) public constant returns (uint256 rate)\n', '\t{\n', '\t\treturn affiliateRate[_level];\n', '\t}\n', '\n', '\t/**\n', '\t * Set affiliate rate for level\n', '\t * @param _level - the level to be set the new rate\n', '\t * @param _rate - new rate\n', '\t */\n', '\tfunction setAffiliateRate(uint256 _level, uint256 _rate) public onlyOwner whenAffiliate returns (bool)\n', '\t{\n', '\t\taffiliateRate[_level]=_rate;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Get affiliate balance of an account\n', '\t * @param _referee - the address to get affiliate of\n', '\t */\n', '\tfunction balanceAffiliateOf(address _referee) public constant returns (uint256)\n', '\t{\n', '\t\treturn referralBalance[_referee];\n', '\t}\n', '\n', '\t/**\n', '\t * Pay affiliate\n', '\t */\n', '\tfunction payAffiliate() public onlyOwner returns (bool success);\n', '}\n', '\n', '\n', '/**\n', ' * This contract will send tokens when an account send eth\n', ' * Note: before send eth to token, address has to be registered by registerRecipient function\n', ' */\n', 'contract IcoContract is IcoPhase, Ownable, Pausable, Affiliate, Bonus {\n', '\tusing SafeMath for uint256;\n', '\n', '\tJWCToken ccc;\n', '\n', '\tuint256 public totalTokenSale;\n', '\tuint256 public minContribution = 0.1 ether;//minimun eth used to buy tokens\n', '\tuint256 public tokenExchangeRate = 7000;//1ETH=7000 tokens\n', '\tuint256 public constant decimals = 18;\n', '\n', '\tuint256 public tokenRemainPreSale;//tokens remain for pre-sale\n', '\tuint256 public tokenRemainPublicSale;//tokens for public-sale\n', '\n', '\taddress public ethFundDeposit = 0x133f29F316Aac08ABC0b39b5CdbD0E7f134671dB;//multi-sig wallet\n', '\taddress public tokenAddress;\n', '\n', '\tbool public isFinalized;\n', '\n', '\tuint256 public maxGasRefund = 0.0046 ether;//maximum gas used to refund for each transaction\n', '\n', '\t//constructor\n', '\tfunction IcoContract(address _tokenAddress) public {\n', '\t\ttokenAddress = _tokenAddress;\n', '\n', '\t\tccc = JWCToken(tokenAddress);\n', '\t\ttotalTokenSale = ccc.tokenPreSale() + ccc.tokenPublicSale();\n', '\n', '\t\ttokenRemainPreSale = ccc.tokenPreSale();//tokens remain for pre-sale\n', '\t\ttokenRemainPublicSale = ccc.tokenPublicSale();//tokens for public-sale\n', '\n', '\t\tisFinalized=false;\n', '\t}\n', '\n', '\t//usage: web3 change token from eth\n', '\tfunction changeETH2Token(uint256 _value) public constant returns(uint256) {\n', '\t\tuint256 etherRecev = _value + maxGasRefund;\n', '\t\trequire (etherRecev >= minContribution);\n', '\n', '\t\tuint256 rate = getTokenExchangeRate();\n', '\n', '\t\tuint256 tokens = etherRecev.mul(rate);\n', '\n', '\t\t//get current phase of ICO\n', '\t\tuint256 phaseICO = getCurrentICOPhase();\n', '\t\tuint256 tokenRemain = 0;\n', '\t\tif(phaseICO == 1){//pre-sale\n', '\t\t\ttokenRemain = tokenRemainPreSale;\n', '\t\t} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {\n', '\t\t\ttokenRemain = tokenRemainPublicSale;\n', '\t\t}\n', '\n', '\t\tif (tokenRemain < tokens) {\n', '\t\t\ttokens=tokenRemain;\n', '\t\t}\n', '\n', '\t\treturn tokens;\n', '\t}\n', '\n', '\tfunction () public payable whenNotPaused {\n', '\t\trequire (!isFinalized);\n', '\t\trequire (msg.sender != address(0));\n', '\n', '\t\tuint256 etherRecev = msg.value + maxGasRefund;\n', '\t\trequire (etherRecev >= minContribution);\n', '\n', '\t\t//get current token exchange rate\n', '\t\ttokenExchangeRate = getTokenExchangeRate();\n', '\n', '\t\tuint256 tokens = etherRecev.mul(tokenExchangeRate);\n', '\n', '\t\t//get current phase of ICO\n', '\t\tuint256 phaseICO = getCurrentICOPhase();\n', '\n', '\t\trequire(phaseICO!=0);\n', '\n', '\t\tuint256 tokenRemain = 0;\n', '\t\tif(phaseICO == 1){//pre-sale\n', '\t\t\ttokenRemain = tokenRemainPreSale;\n', '\t\t} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {\n', '\t\t\ttokenRemain = tokenRemainPublicSale;\n', '\t\t}\n', '\n', '\t\t//throw if tokenRemain==0\n', '\t\trequire(tokenRemain>0);\n', '\n', '\t\tif (tokenRemain < tokens) {\n', '\t\t\t//if tokens is not enough to buy\n', '\n', '\t\t\tuint256 tokensToRefund = tokens.sub(tokenRemain);\n', '\t\t\tuint256 etherToRefund = tokensToRefund / tokenExchangeRate;\n', '\n', '\t\t\t//refund eth to buyer\n', '\t\t\tmsg.sender.transfer(etherToRefund);\n', '\n', '\t\t\ttokens=tokenRemain;\n', '\t\t\tetherRecev = etherRecev.sub(etherToRefund);\n', '\n', '\t\t\ttokenRemain = 0;\n', '\t\t} else {\n', '\t\t\ttokenRemain = tokenRemain.sub(tokens);\n', '\t\t}\n', '\n', '\t\t//store token remain by phase\n', '\t\tif(phaseICO == 1){//pre-sale\n', '\t\t\ttokenRemainPreSale = tokenRemain;\n', '\t\t} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {\n', '\t\t\ttokenRemainPublicSale = tokenRemain;\n', '\t\t}\n', '\n', '\t\t//send token\n', '\t\tccc.sell(msg.sender, tokens);\n', '\t\tethFundDeposit.transfer(this.balance);\n', '\n', '\t\t//bonus\n', '\t\tif(isBonus){\n', '\t\t\t//bonus amount\n', '\t\t\t//get bonus by eth\n', '\t\t\tuint256 bonusAmountETH = getBonusByETH(etherRecev);\n', '\t\t\t//get bonus by token\n', '\t\t\tuint256 bonusAmountTokens = bonusAmountETH.mul(tokenExchangeRate);\n', '\n', '\t\t\t//check if we have enough tokens for bonus\n', '\t\t\tif(maxAmountBonus>0){\n', '\t\t\t\tif(maxAmountBonus>=bonusAmountTokens){\n', '\t\t\t\t\tmaxAmountBonus-=bonusAmountTokens;\n', '\t\t\t\t} else {\n', '\t\t\t\t\tbonusAmountTokens = maxAmountBonus;\n', '\t\t\t\t\tmaxAmountBonus = 0;\n', '\t\t\t\t}\n', '\t\t\t} else {\n', '\t\t\t\tbonusAmountTokens = 0;\n', '\t\t\t}\n', '\n', '\t\t\t//bonus time\n', '\t\t\tuint256 bonusTimeToken = tokens.mul(getTimeBonus())/100;\n', '\t\t\t//check if we have enough tokens for bonus\n', '\t\t\tif(maxTimeBonus>0){\n', '\t\t\t\tif(maxTimeBonus>=bonusTimeToken){\n', '\t\t\t\t\tmaxTimeBonus-=bonusTimeToken;\n', '\t\t\t\t} else {\n', '\t\t\t\t\tbonusTimeToken = maxTimeBonus;\n', '\t\t\t\t\tmaxTimeBonus = 0;\n', '\t\t\t\t}\n', '\t\t\t} else {\n', '\t\t\t\tbonusTimeToken = 0;\n', '\t\t\t}\n', '\n', '\t\t\t//store bonus\n', '\t\t\tif(bonusAccountBalances[msg.sender]==0){//new\n', '\t\t\t\tbonusAccountIndex[bonusAccountCount]=msg.sender;\n', '\t\t\t\tbonusAccountCount++;\n', '\t\t\t}\n', '\n', '\t\t\tuint256 bonusTokens=bonusAmountTokens + bonusTimeToken;\n', '\t\t\tbonusAccountBalances[msg.sender]=bonusAccountBalances[msg.sender].add(bonusTokens);\n', '\t\t}\n', '\n', '\t\t//affiliate\n', '\t\tif(isAffiliate){\n', '\t\t\taddress child=msg.sender;\n', '\t\t\tfor(uint256 i=0; i<affiliateLevel; i++){\n', '\t\t\t\tuint256 giftToken=affiliateRate[i].mul(tokens)/100;\n', '\n', '\t\t\t\t//check if we have enough tokens for affiliate\n', '\t\t\t\tif(maxAffiliate<=0){\n', '\t\t\t\t\tbreak;\n', '\t\t\t\t} else {\n', '\t\t\t\t\tif(maxAffiliate>=giftToken){\n', '\t\t\t\t\t\tmaxAffiliate-=giftToken;\n', '\t\t\t\t\t} else {\n', '\t\t\t\t\t\tgiftToken = maxAffiliate;\n', '\t\t\t\t\t\tmaxAffiliate = 0;\n', '\t\t\t\t\t}\n', '\t\t\t\t}\n', '\n', '\t\t\t\taddress parent = referral[child];\n', '\t\t\t\tif(parent != address(0x00)){//has affiliate\n', '\t\t\t\t\treferralBalance[child]=referralBalance[child].add(giftToken);\n', '\t\t\t\t}\n', '\n', '\t\t\t\tchild=parent;\n', '\t\t\t}\n', '\t\t}\n', '\t}\n', '\n', '\t/**\n', '\t * Pay affiliate to address. Called when ICO finish\n', '\t */\n', '\tfunction payAffiliate() public onlyOwner returns (bool success) {\n', '\t\tuint256 toIndex = indexPaidAffiliate + 15;\n', '\t\tif(referralCount < toIndex)\n', '\t\t\ttoIndex = referralCount;\n', '\n', '\t\tfor(uint256 i=indexPaidAffiliate; i<toIndex; i++) {\n', '\t\t\taddress referee = referralIndex[i];\n', '\t\t\tpayAffiliate1Address(referee);\n', '\t\t}\n', '\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Pay affiliate to only a address\n', '\t */\n', '\tfunction payAffiliate1Address(address _referee) public onlyOwner returns (bool success) {\n', '\t\taddress referrer = referral[_referee];\n', '\t\tccc.payBonusAffiliate(referrer, referralBalance[_referee]);\n', '\n', '\t\treferralBalance[_referee]=0;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Pay bonus to address. Called when ICO finish\n', '\t */\n', '\tfunction payBonus() public onlyOwner returns (bool success) {\n', '\t\tuint256 toIndex = indexPaidBonus + 15;\n', '\t\tif(bonusAccountCount < toIndex)\n', '\t\t\ttoIndex = bonusAccountCount;\n', '\n', '\t\tfor(uint256 i=indexPaidBonus; i<toIndex; i++)\n', '\t\t{\n', '\t\t\tpayBonus1Address(bonusAccountIndex[i]);\n', '\t\t}\n', '\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Pay bonus to only a address\n', '\t */\n', '\tfunction payBonus1Address(address _address) public onlyOwner returns (bool success) {\n', '\t\tccc.payBonusAffiliate(_address, bonusAccountBalances[_address]);\n', '\t\tbonusAccountBalances[_address]=0;\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction finalize() external onlyOwner {\n', '\t\trequire (!isFinalized);\n', '\t\t// move to operational\n', '\t\tisFinalized = true;\n', '\t\tpayAffiliate();\n', '\t\tpayBonus();\n', '\t\tethFundDeposit.transfer(this.balance);\n', '\t}\n', '\n', '\t/**\n', '\t * Get token exchange rate\n', '\t * Note: just use when ICO\n', '\t */\n', '\tfunction getTokenExchangeRate() public constant returns(uint256 rate) {\n', '\t\trate = tokenExchangeRate;\n', '\t\tif(now<phasePresale_To){\n', '\t\t\tif(now>=phasePresale_From)\n', '\t\t\t\trate = 10000;\n', '\t\t} else if(now<phasePublicSale3_To){\n', '\t\t\trate = 7000;\n', '\t\t}\n', '\t}\n', '\n', '\t/**\n', '\t * Get the current ICO phase\n', '\t */\n', '\tfunction getCurrentICOPhase() public constant returns(uint256 phase) {\n', '\t\tphase = 0;\n', '\t\tif(now>=phasePresale_From && now<phasePresale_To){\n', '\t\t\tphase = 1;\n', '\t\t} else if (now>=phasePublicSale1_From && now<phasePublicSale1_To) {\n', '\t\t\tphase = 2;\n', '\t\t} else if (now>=phasePublicSale2_From && now<phasePublicSale2_To) {\n', '\t\t\tphase = 3;\n', '\t\t} else if (now>=phasePublicSale3_From && now<phasePublicSale3_To) {\n', '\t\t\tphase = 4;\n', '\t\t}\n', '\t}\n', '\n', '\t/**\n', '\t * Get amount of tokens that be sold\n', '\t */\n', '\tfunction getTokenSold() public constant returns(uint256 tokenSold) {\n', '\t\t//get current phase of ICO\n', '\t\tuint256 phaseICO = getCurrentICOPhase();\n', '\t\ttokenSold = 0;\n', '\t\tif(phaseICO == 1){//pre-sale\n', '\t\t\ttokenSold = ccc.tokenPreSale().sub(tokenRemainPreSale);\n', '\t\t} else if (phaseICO == 2 || phaseICO == 3 || phaseICO == 4) {\n', '\t\t\ttokenSold = ccc.tokenPreSale().sub(tokenRemainPreSale) + ccc.tokenPublicSale().sub(tokenRemainPublicSale);\n', '\t\t}\n', '\t}\n', '\n', '\t/**\n', '\t * Set token exchange rate\n', '\t */\n', '\tfunction setTokenExchangeRate(uint256 _tokenExchangeRate) public onlyOwner returns (bool) {\n', '\t\trequire(_tokenExchangeRate>0);\n', '\t\ttokenExchangeRate=_tokenExchangeRate;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * set min eth contribute\n', '\t * @param _minContribution - min eth to contribute\n', '\t */\n', '\tfunction setMinContribution(uint256 _minContribution) public onlyOwner returns (bool) {\n', '\t\trequire(_minContribution>0);\n', '\t\tminContribution=_minContribution;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Change multi-sig address, the address to receive ETH\n', '\t * @param _ethFundDeposit - new multi-sig address\n', '\t */\n', '\tfunction setEthFundDeposit(address _ethFundDeposit) public onlyOwner returns (bool) {\n', '\t\trequire(_ethFundDeposit != address(0));\n', '\t\tethFundDeposit=_ethFundDeposit;\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t * Set max gas to refund when an address send ETH to buy tokens\n', '\t * @param _maxGasRefund - max gas\n', '\t */\n', '\tfunction setMaxGasRefund(uint256 _maxGasRefund) public onlyOwner returns (bool) {\n', '\t\trequire(_maxGasRefund > 0);\n', '\t\tmaxGasRefund = _maxGasRefund;\n', '\t\treturn true;\n', '\t}\n', '}']
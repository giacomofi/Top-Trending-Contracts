['pragma solidity ^0.4.13;\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract LockedSecretChallenge is Ownable  {\n', '\tusing SafeMath for uint256;\n', '\n', '\t\n', '\t/*Variables about the token contract */\t\n', '\tPeculium public pecul; // The Peculium token\n', '\tuint256 decimals;\n', '\tbool public initPecul; // boolean to know if the Peculium token address has been init\n', '\tevent InitializedToken(address contractToken);\n', '\n', '\tuint256 startdate;\n', '\tuint256 degeldate;\n', '\n', '\n', '\taddress[10] challengeAddress;\n', '\tuint256[10] challengeAmount;\n', '\tbool public initChallenge;\n', '\tevent InitializedChallengeAddress(address[10] challengeA, uint256[10] challengeT);\n', '\t\n', '\t//Constructor\n', '\tconstructor() {\n', '\t\tstartdate = now;\n', '\t\tdegeldate = 1551890520; // timestamp for 6 March 2019 : 17h42:00\n', '\t\t}\n', '\t\n', '\t\n', '\t/***  Functions of the contract ***/\n', '\t\n', '\tfunction InitPeculiumAdress(address peculAdress) public onlyOwner \n', '\t{ // We init the address of the token\n', '\t\n', '\t\tpecul = Peculium(peculAdress);\n', '\t\tdecimals = pecul.decimals();\n', '\t\tinitPecul = true;\n', '\t\temit InitializedToken(peculAdress);\n', '\t\n', '\t}\n', '\t\n', '\tfunction InitChallengeAddress(address[10] addressC, uint256[10] amountC) public onlyOwner Initialize {\n', '\t\n', '\t\tfor(uint256 i=0; i<addressC.length;i++){\n', '\t\t\tchallengeAddress[i] = addressC[i];\n', '\t\t\tchallengeAmount[i] = amountC[i];\n', '\t\t}\n', '\t\temit InitializedChallengeAddress(challengeAddress,challengeAmount);\n', '\t}\n', '\t\t\n', '\tfunction transferFinal() public onlyOwner Initialize InitializeChallengeAddress\n', '\t{ // Transfer pecul for the Bounty manager\n', '\t\t\n', '\t\trequire(now >= degeldate);\n', '\t\trequire ( challengeAddress.length == challengeAmount.length );\n', '\t\t\n', '\t\tfor(uint256 i=0; i<challengeAddress.length;i++){\n', '\t\t\trequire(challengeAddress[i]!=0x0);\n', '\t\t}\n', '\t\tuint256 amountToSendTotal = 0;\n', '\t\t\n', '\t\tfor (uint256 indexTest=0; indexTest<challengeAmount.length; indexTest++) // We first test that we have enough token to send\n', '\t\t{\n', '\t\t\n', '\t\t\tamountToSendTotal = amountToSendTotal + challengeAmount[indexTest]; \n', '\t\t\n', '\t\t}\n', '\t\trequire(amountToSendTotal*10**decimals<=pecul.balanceOf(this)); // If no enough token, cancel the send \n', '\t\t\n', '\t\t\n', '\t\tfor (uint256 index=0; index<challengeAddress.length; index++) \n', '\t\t{\n', '\t\t\taddress toAddress = challengeAddress[index];\n', '\t\t\tuint256 amountTo_Send = challengeAmount[index]*10**decimals;\n', '\t\t\n', '\t                pecul.transfer(toAddress,amountTo_Send);\n', '\t\t}\n', '\n', '\t\t\t\t\n', '\t}\n', '\t\n', '\tfunction emergency() public onlyOwner \n', '\t{ // In case of bug or emergency, resend all tokens to initial sender\n', '\t\tpecul.transfer(owner,pecul.balanceOf(this));\n', '\t}\n', '\t\n', '\t\t/***  Modifiers of the contract ***/\n', '\tmodifier InitializeChallengeAddress { // We need to initialize first the token contract\n', '\t\trequire (initChallenge==true);\n', '\t\t_;\n', '    \t}\n', '\n', '\t\n', '\tmodifier Initialize { // We need to initialize first the token contract\n', '\t\trequire (initPecul==true);\n', '\t\t_;\n', '    \t}\n', '\n', '}\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool)  {\n', '    require(_to != address(0));\n', '\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', 'contract Peculium is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude\n', '\n', '\t/*Variables about the old token contract */\t\n', '\tPeculiumOld public peculOld; // The old Peculium token\n', '\taddress public peculOldAdress = 0x53148Bb4551707edF51a1e8d7A93698d18931225; // The address of the old Peculium contract\n', '\n', '\tusing SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)\n', '\tusing SafeERC20 for ERC20Basic; \n', '\n', '    \t/* Public variables of the token for ERC20 compliance */\n', '\tstring public name = "Peculium"; //token name \n', '    \tstring public symbol = "PCL"; // token symbol\n', '    \tuint256 public decimals = 8; // token number of decimal\n', '    \t\n', '    \t/* Public variables specific for Peculium */\n', '        uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium\n', '\n', '\tmapping(address => bool) public balancesCannotSell; // The boolean variable, to frost the tokens\n', '\n', '\n', '    \t/* Event for the freeze of account */\n', '\tevent ChangedTokens(address changedTarget,uint256 amountToChanged);\n', '\tevent FrozenFunds(address address_target, bool bool_canSell);\n', '\n', '   \n', '\t//Constructor\n', '\tfunction Peculium() public {\n', '\t\ttotalSupply = MAX_SUPPLY_NBTOKEN;\n', '\t\tbalances[address(this)] = totalSupply; // At the beginning, the contract has all the tokens. \n', '\t\tpeculOld = PeculiumOld(peculOldAdress);\t\n', '\t}\n', '\t\n', '\t/*** Public Functions of the contract ***/\t\n', '\t\t\t\t\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool) \n', '\t{ // We overright the transfer function to allow freeze possibility\n', '\t\n', '\t\trequire(balancesCannotSell[msg.sender]==false);\n', '\t\treturn BasicToken.transfer(_to,_value);\n', '\t\n', '\t}\n', '\t\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) public returns (bool) \n', '\t{ // We overright the transferFrom function to allow freeze possibility\n', '\t\n', '\t\trequire(balancesCannotSell[msg.sender]==false);\t\n', '\t\treturn StandardToken.transferFrom(_from,_to,_value);\n', '\t\n', '\t}\n', '\n', '\t/***  Owner Functions of the contract ***/\t\n', '\n', '   \tfunction ChangeLicense(address target, bool canSell) public onlyOwner\n', '   \t{\n', '        \n', '        \tbalancesCannotSell[target] = canSell;\n', '        \tFrozenFunds(target, canSell);\n', '    \t\n', '    \t}\n', '    \t\n', '    \t\tfunction UpgradeTokens() public\n', '\t{\n', '\t// Use this function to swap your old peculium against new ones (the new ones don&#39;t need defrost to be transfered)\n', '\t// Old peculium are burned\n', '\t\trequire(peculOld.totalSupply()>0);\n', '\t\tuint256 amountChanged = peculOld.allowance(msg.sender,address(this));\n', '\t\trequire(amountChanged>0);\n', '\t\tpeculOld.transferFrom(msg.sender,address(this),amountChanged);\n', '\t\tpeculOld.burn(amountChanged);\n', '\n', '\t\tbalances[address(this)] = balances[address(this)].sub(amountChanged);\n', '    \t\tbalances[msg.sender] = balances[msg.sender].add(amountChanged);\n', '\t\tTransfer(address(this), msg.sender, amountChanged);\n', '\t\tChangedTokens(msg.sender,amountChanged);\n', '\t\t\n', '\t}\n', '\n', '\t/*** Others Functions of the contract ***/\t\n', '\t\n', '\t/* Approves and then calls the receiving contract */\n', '\tfunction approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\tApproval(msg.sender, _spender, _value);\n', '\n', '\t\trequire(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));\n', '        \treturn true;\n', '    }\n', '\n', '  \tfunction getBlockTimestamp() public constant returns (uint256)\n', '  \t{\n', '        \treturn now;\n', '  \t}\n', '\n', '  \tfunction getOwnerInfos() public constant returns (address ownerAddr, uint256 ownerBalance)  \n', '  \t{ // Return info about the public address and balance of the account of the owner of the contract\n', '    \t\n', '    \t\townerAddr = owner;\n', '\t\townerBalance = balanceOf(ownerAddr);\n', '  \t\n', '  \t}\n', '\n', '}\n', '\n', 'contract PeculiumOld is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude\n', '\n', '\tusing SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)\n', '\tusing SafeERC20 for ERC20Basic; \n', '\n', '    \t/* Public variables of the token for ERC20 compliance */\n', '\tstring public name = "Peculium"; //token name \n', '    \tstring public symbol = "PCL"; // token symbol\n', '    \tuint256 public decimals = 8; // token number of decimal\n', '    \t\n', '    \t/* Public variables specific for Peculium */\n', '        uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium\n', '\n', '\tuint256 public dateStartContract; // The date of the deployment of the token\n', '\tmapping(address => bool) public balancesCanSell; // The boolean variable, to frost the tokens\n', '\tuint256 public dateDefrost; // The date when the owners of token can defrost their tokens\n', '\n', '\n', '    \t/* Event for the freeze of account */\n', ' \tevent FrozenFunds(address target, bool frozen);     \t \n', '     \tevent Defroze(address msgAdd, bool freeze);\n', '\t\n', '\n', '\n', '   \n', '\t//Constructor\n', '\tfunction PeculiumOld() {\n', '\t\ttotalSupply = MAX_SUPPLY_NBTOKEN;\n', '\t\tbalances[owner] = totalSupply; // At the beginning, the owner has all the tokens. \n', '\t\tbalancesCanSell[owner] = true; // The owner need to sell token for the private sale and for the preICO, ICO.\n', '\t\t\n', '\t\tdateStartContract=now;\n', '\t\tdateDefrost = dateStartContract + 85 days; // everybody can defrost his own token after the 25 january 2018 (85 days after 1 November)\n', '\n', '\t}\n', '\n', '\t/*** Public Functions of the contract ***/\t\n', '\t\n', '\tfunction defrostToken() public \n', '\t{ // Function to defrost your own token, after the date of the defrost\n', '\t\n', '\t\trequire(now>dateDefrost);\n', '\t\tbalancesCanSell[msg.sender]=true;\n', '\t\tDefroze(msg.sender,true);\n', '\t}\n', '\t\t\t\t\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool) \n', '\t{ // We overright the transfer function to allow freeze possibility\n', '\t\n', '\t\trequire(balancesCanSell[msg.sender]);\n', '\t\treturn BasicToken.transfer(_to,_value);\n', '\t\n', '\t}\n', '\t\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) public returns (bool) \n', '\t{ // We overright the transferFrom function to allow freeze possibility (need to allow before)\n', '\t\n', '\t\trequire(balancesCanSell[msg.sender]);\t\n', '\t\treturn StandardToken.transferFrom(_from,_to,_value);\n', '\t\n', '\t}\n', '\n', '\t/***  Owner Functions of the contract ***/\t\n', '\n', '   \tfunction freezeAccount(address target, bool canSell) onlyOwner \n', '   \t{\n', '        \n', '        \tbalancesCanSell[target] = canSell;\n', '        \tFrozenFunds(target, canSell);\n', '    \t\n', '    \t}\n', '\n', '\n', '\t/*** Others Functions of the contract ***/\t\n', '\t\n', '\t/* Approves and then calls the receiving contract */\n', '\tfunction approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\tApproval(msg.sender, _spender, _value);\n', '\n', '\t\trequire(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));\n', '        \treturn true;\n', '    }\n', '\n', '  \tfunction getBlockTimestamp() constant returns (uint256)\n', '  \t{\n', '        \n', '        \treturn now;\n', '  \t\n', '  \t}\n', '\n', '  \tfunction getOwnerInfos() constant returns (address ownerAddr, uint256 ownerBalance)  \n', '  \t{ // Return info about the public address and balance of the account of the owner of the contract\n', '    \t\n', '    \t\townerAddr = owner;\n', '\t\townerBalance = balanceOf(ownerAddr);\n', '  \t\n', '  \t}\n', '\n', '}']
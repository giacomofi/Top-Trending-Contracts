['pragma solidity ^0.4.13;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(burner, _value);\n', '    emit Transfer(burner, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract CryptohomaToken is StandardToken, MintableToken, BurnableToken {\n', '    \n', '    string public name = "CryptohomaToken";\n', '    string public symbol = "HOMA";\n', '    uint public decimals = 18;\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Amount of wei raised\n', '    uint256 public weiRaised;\n', '\n', '    uint start = 1525132801;\n', '\n', '    uint period = 31;\n', '\n', '    uint256 public totalSupply = 50000000 * 1 ether;\n', '\n', '    uint256 public totalMinted;\n', '\n', '    uint256 public presale_tokens = 1562500 * 1 ether;\n', '    uint public bounty_percent = 5;\n', '    uint public airdrop_percent = 2;\n', '    uint public organizers_percent = 15;\n', '\n', '    address public multisig = 0xcBF6E568F588Fc198312F9587e660CbdF64DB262;\n', '    address public presale = 0x42d8388E55A527Fa84f29A4D8768B923Dd8628E3;\n', '    address public bounty = 0x27986d9CB66Dc4b60911D1E10f2DB6Ca3459A075;\n', '    address public airdrop = 0xE0D7bd9a4ce64049A187b0097f86F6ae49bD19b5;\n', '    address public organizer1 = 0x4FE7F4AA0d221827112090Ad7B90c7D8B9c08cc5;\n', '    address public organizer2 = 0x6A7fd6308791B198739679F571bD981F7aA3a239;\n', '    address public organizer3 = 0xCb04445D08830db4BFEB8F94fb71422C2FBAB17F;\n', '    address public organizer4 = 0x4A44960b49816b8cB77de28FCB512AD903d62FEb;\n', '    address public organizer5 = 0xEB27178C637336c3A6243aA312C3f197B54155f1;\n', '    address public organizer6 = 0x84ae1B4E8c008dCbEfF91A923EA216a5fA718e25;\n', '    address public organizer7 = 0x6de044c56D91b880C73C8e667C37A2B2A977FC3a;\n', '    address public organizer8 = 0x5b3a08DaAcC4167e9432dCF56D3fcd147006192c;\n', '\n', '    uint256 public rate = 0.000011 * 1 ether;\n', '    uint256 public rate2 = 0.000015 * 1 ether;\n', '\n', '    function CryptohomaToken() public {\n', '\n', '        totalMinted = totalMinted.add(presale_tokens);\n', '        super.mint(presale, presale_tokens);\n', '\n', '        uint256 tokens = totalSupply.mul(bounty_percent).div(100);\n', '        totalMinted = totalMinted.add(tokens);\n', '        super.mint(bounty, tokens);\n', '\n', '        tokens = totalSupply.mul(airdrop_percent).div(100);\n', '        totalMinted = totalMinted.add(tokens);\n', '        super.mint(airdrop, tokens);\n', '\n', '        tokens = totalSupply.mul(organizers_percent).div(100);\n', '        totalMinted = totalMinted.add(tokens);\n', '        tokens = tokens.div(8);\n', '        super.mint(organizer1, tokens);\n', '        super.mint(organizer2, tokens);\n', '        super.mint(organizer3, tokens);\n', '        super.mint(organizer4, tokens);\n', '        super.mint(organizer5, tokens);\n', '        super.mint(organizer6, tokens);\n', '        super.mint(organizer7, tokens);\n', '        super.mint(organizer8, tokens);\n', '\n', '    }\n', '\n', '\n', '    /**\n', '    * Event for token purchase logging\n', '    * @param purchaser who paid for the tokens\n', '    * @param beneficiary who got the tokens\n', '    * @param value weis paid for purchase\n', '    * @param amount amount of tokens purchased\n', '    */\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    /**\n', '    * @dev fallback function ***DO NOT OVERRIDE***\n', '    */\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '    * @dev low level token purchase ***DO NOT OVERRIDE***\n', '    * @param _beneficiary Address performing the token purchase\n', '    */\n', '    function buyTokens(address _beneficiary) public payable {\n', '\n', '        uint256 weiAmount = msg.value;\n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        _processPurchase(_beneficiary, tokens);\n', '        emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '\n', '        _forwardFunds();\n', '    }\n', '\n', '    /**\n', '    * @dev Override to extend the way in which ether is converted to tokens.\n', '    * @param _weiAmount Value in wei to be converted into tokens\n', '    * @return Number of tokens that can be purchased with the specified _weiAmount\n', '    */\n', '    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '        return _weiAmount / rate * 1 ether;\n', '    }\n', '\n', '    /**\n', '    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations. ***ПЕРЕОПРЕДЕЛЕНО***\n', '    * @param _beneficiary Address performing the token purchase\n', '    * @param _weiAmount Value in wei involved in the purchase\n', '    */\n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '        require(_beneficiary != address(0));\n', '        require(_weiAmount != 0);\n', '\n', '        require(now > start && now < start + period * 1 days);\n', '\n', '        if (now > start.add(15 * 1 days)) {\n', '            rate = rate2;\n', '        }\n', '\n', '        uint256 tokens = _getTokenAmount(_weiAmount);\n', '        totalMinted = totalMinted.add(tokens);\n', '\n', '        require(totalSupply >= totalMinted);\n', '\n', '    }\n', '\n', '    /**\n', '    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '    * @param _beneficiary Address performing the token purchase\n', '    * @param _tokenAmount Number of tokens to be emitted\n', '    */\n', '    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        super.transfer(_beneficiary, _tokenAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '    * @param _beneficiary Address receiving the tokens\n', '    * @param _tokenAmount Number of tokens to be purchased\n', '    */\n', '    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '        _deliverTokens(_beneficiary, _tokenAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Determines how ETH is stored/forwarded on purchases.\n', '    */\n', '    function _forwardFunds() internal {\n', '        multisig.transfer(msg.value);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(burner, _value);\n', '    emit Transfer(burner, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract CryptohomaToken is StandardToken, MintableToken, BurnableToken {\n', '    \n', '    string public name = "CryptohomaToken";\n', '    string public symbol = "HOMA";\n', '    uint public decimals = 18;\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Amount of wei raised\n', '    uint256 public weiRaised;\n', '\n', '    uint start = 1525132801;\n', '\n', '    uint period = 31;\n', '\n', '    uint256 public totalSupply = 50000000 * 1 ether;\n', '\n', '    uint256 public totalMinted;\n', '\n', '    uint256 public presale_tokens = 1562500 * 1 ether;\n', '    uint public bounty_percent = 5;\n', '    uint public airdrop_percent = 2;\n', '    uint public organizers_percent = 15;\n', '\n', '    address public multisig = 0xcBF6E568F588Fc198312F9587e660CbdF64DB262;\n', '    address public presale = 0x42d8388E55A527Fa84f29A4D8768B923Dd8628E3;\n', '    address public bounty = 0x27986d9CB66Dc4b60911D1E10f2DB6Ca3459A075;\n', '    address public airdrop = 0xE0D7bd9a4ce64049A187b0097f86F6ae49bD19b5;\n', '    address public organizer1 = 0x4FE7F4AA0d221827112090Ad7B90c7D8B9c08cc5;\n', '    address public organizer2 = 0x6A7fd6308791B198739679F571bD981F7aA3a239;\n', '    address public organizer3 = 0xCb04445D08830db4BFEB8F94fb71422C2FBAB17F;\n', '    address public organizer4 = 0x4A44960b49816b8cB77de28FCB512AD903d62FEb;\n', '    address public organizer5 = 0xEB27178C637336c3A6243aA312C3f197B54155f1;\n', '    address public organizer6 = 0x84ae1B4E8c008dCbEfF91A923EA216a5fA718e25;\n', '    address public organizer7 = 0x6de044c56D91b880C73C8e667C37A2B2A977FC3a;\n', '    address public organizer8 = 0x5b3a08DaAcC4167e9432dCF56D3fcd147006192c;\n', '\n', '    uint256 public rate = 0.000011 * 1 ether;\n', '    uint256 public rate2 = 0.000015 * 1 ether;\n', '\n', '    function CryptohomaToken() public {\n', '\n', '        totalMinted = totalMinted.add(presale_tokens);\n', '        super.mint(presale, presale_tokens);\n', '\n', '        uint256 tokens = totalSupply.mul(bounty_percent).div(100);\n', '        totalMinted = totalMinted.add(tokens);\n', '        super.mint(bounty, tokens);\n', '\n', '        tokens = totalSupply.mul(airdrop_percent).div(100);\n', '        totalMinted = totalMinted.add(tokens);\n', '        super.mint(airdrop, tokens);\n', '\n', '        tokens = totalSupply.mul(organizers_percent).div(100);\n', '        totalMinted = totalMinted.add(tokens);\n', '        tokens = tokens.div(8);\n', '        super.mint(organizer1, tokens);\n', '        super.mint(organizer2, tokens);\n', '        super.mint(organizer3, tokens);\n', '        super.mint(organizer4, tokens);\n', '        super.mint(organizer5, tokens);\n', '        super.mint(organizer6, tokens);\n', '        super.mint(organizer7, tokens);\n', '        super.mint(organizer8, tokens);\n', '\n', '    }\n', '\n', '\n', '    /**\n', '    * Event for token purchase logging\n', '    * @param purchaser who paid for the tokens\n', '    * @param beneficiary who got the tokens\n', '    * @param value weis paid for purchase\n', '    * @param amount amount of tokens purchased\n', '    */\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    /**\n', '    * @dev fallback function ***DO NOT OVERRIDE***\n', '    */\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '    * @dev low level token purchase ***DO NOT OVERRIDE***\n', '    * @param _beneficiary Address performing the token purchase\n', '    */\n', '    function buyTokens(address _beneficiary) public payable {\n', '\n', '        uint256 weiAmount = msg.value;\n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        _processPurchase(_beneficiary, tokens);\n', '        emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '\n', '        _forwardFunds();\n', '    }\n', '\n', '    /**\n', '    * @dev Override to extend the way in which ether is converted to tokens.\n', '    * @param _weiAmount Value in wei to be converted into tokens\n', '    * @return Number of tokens that can be purchased with the specified _weiAmount\n', '    */\n', '    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '        return _weiAmount / rate * 1 ether;\n', '    }\n', '\n', '    /**\n', '    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations. ***ПЕРЕОПРЕДЕЛЕНО***\n', '    * @param _beneficiary Address performing the token purchase\n', '    * @param _weiAmount Value in wei involved in the purchase\n', '    */\n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '        require(_beneficiary != address(0));\n', '        require(_weiAmount != 0);\n', '\n', '        require(now > start && now < start + period * 1 days);\n', '\n', '        if (now > start.add(15 * 1 days)) {\n', '            rate = rate2;\n', '        }\n', '\n', '        uint256 tokens = _getTokenAmount(_weiAmount);\n', '        totalMinted = totalMinted.add(tokens);\n', '\n', '        require(totalSupply >= totalMinted);\n', '\n', '    }\n', '\n', '    /**\n', '    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '    * @param _beneficiary Address performing the token purchase\n', '    * @param _tokenAmount Number of tokens to be emitted\n', '    */\n', '    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        super.transfer(_beneficiary, _tokenAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '    * @param _beneficiary Address receiving the tokens\n', '    * @param _tokenAmount Number of tokens to be purchased\n', '    */\n', '    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '        _deliverTokens(_beneficiary, _tokenAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Determines how ETH is stored/forwarded on purchases.\n', '    */\n', '    function _forwardFunds() internal {\n', '        multisig.transfer(msg.value);\n', '    }\n', '\n', '}']
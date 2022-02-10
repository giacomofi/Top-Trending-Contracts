['pragma solidity ^0.4.15;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '\n', '    //Variables\n', '    address public owner;\n', '\n', '    address public newOwner;\n', '\n', '    //    Modifiers\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0));\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        if (msg.sender == newOwner) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(0x0, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract LamdenTau is MintableToken {\n', '    string public constant name = "Lamden Tau";\n', '    string public constant symbol = "TAU";\n', '    uint8 public constant decimals = 18;\n', '}\n', '\n', 'contract Bounty is Ownable {\n', '\n', '   LamdenTau public lamdenTau;\n', '\n', '   function Bounty(address _tokenContractAddress) public {\n', '      require(_tokenContractAddress != address(0));\n', '      lamdenTau = LamdenTau(_tokenContractAddress);\n', '      \n', '      \n', '   }\n', '\n', '   function returnTokens() onlyOwner {\n', '      uint256 balance = lamdenTau.balanceOf(this);\n', '      lamdenTau.transfer(msg.sender, balance);\n', '   }\n', '\n', '   function issueTokens() onlyOwner  {\n', '      \n', '        lamdenTau.transfer(0xE4321372c368cd74539c923Bc381328547e8aA09, 120000000000000000000);\n', '        lamdenTau.transfer(0x68Fc5e25C190A2aAe021dD91cbA8090A2845f759, 120000000000000000000);\n', '        lamdenTau.transfer(0x37187CA8a37B49643057ed8E3Df9b2AE80E0252b, 20000000000000000000);\n', '        lamdenTau.transfer(0x13aD46285E9164C297044f3F27Cc1AeF5bB8500e, 120000000000000000000);\n', '        lamdenTau.transfer(0xA95A746424f781c4413bf34480C9Ef3630bD53A9, 120000000000000000000);\n', '        lamdenTau.transfer(0xE4Baa1588397D9F8b409955497c647b2edE9dEfb, 120000000000000000000);\n', '        lamdenTau.transfer(0xA91CeEF3A5eF473484eB3EcC804A4b5744F08008, 80000000000000000000);\n', '        lamdenTau.transfer(0x260e4a5d0a4a7f48D7a8367c3C1fbAE180a2B812, 180000000000000000000);\n', '        lamdenTau.transfer(0x2Cbc78b7DB97576674cC4e442d3F4d792b43A3a9, 120000000000000000000);\n', '        lamdenTau.transfer(0x36e096F0F7fF02706B651d047755e3321D964909, 40000000000000000000);\n', '        lamdenTau.transfer(0xc0146149a466Fd66e51f389d3464ca55703abc38, 40000000000000000000);\n', '        lamdenTau.transfer(0x0C4162f4259b3912af4965273A3a85693FC48d67, 10000000000000000000);\n', '        lamdenTau.transfer(0x0c49d7f01E51FCC23FBFd175beDD6A571b29B27A, 40000000000000000000);\n', '        lamdenTau.transfer(0x6294594549fbCceb9aC01D68ecD60D3316Be8758, 40000000000000000000);\n', '        lamdenTau.transfer(0x82C9cD34f520E773e5DbF606b0CC1c4EAC1308bf, 420000000000000000000);\n', '        lamdenTau.transfer(0xf279836951116d7bb4382867EA63F3604C79c562, 250000000000000000000);\n', '        lamdenTau.transfer(0xe47BBeAc8F268d7126082D5574B6f027f95AF5FB, 500000000000000000000);\n', '        lamdenTau.transfer(0x0271c67C3B250bBA8625083C87714e54BA75796D, 500000000000000000000);\n', '        lamdenTau.transfer(0xe47BBeAc8F268d7126082D5574B6f027f95AF5FB, 250000000000000000000);\n', '        lamdenTau.transfer(0x59E8537879c54751a9019595dF45731F8fCF1dC2, 250000000000000000000);\n', '        lamdenTau.transfer(0xD399E4f178D269DbdaD44948FdEE157Ca574E286, 250000000000000000000);\n', '        lamdenTau.transfer(0x9D7C69Ba1C7C72326186127f48AF6D61Ff95496D, 250000000000000000000);\n', '        lamdenTau.transfer(0xdf64F64C3A359CFc5151af729De3D2793C504455, 250000000000000000000);\n', '        lamdenTau.transfer(0x343553E9296E825E6931EDc5b163bDA39515c731, 250000000000000000000);\n', '\n', '      uint256 balance = lamdenTau.balanceOf(this);\n', '      lamdenTau.transfer(msg.sender, balance);\n', '   }\n', '\n', '}']
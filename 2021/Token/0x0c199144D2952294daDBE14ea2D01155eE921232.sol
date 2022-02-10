['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-26\n', '*/\n', '\n', 'pragma solidity >=0.4.25 <0.6.0;\n', '\n', '//@title Instaminter\n', '//@R^3\n', '//@notice creates ERC-20 token contracts\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '    address public creator;\n', '\n', '    modifier onlyTokenOwner() {\n', '        require(msg.sender == creator || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyTokenOwner public {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '  function transferCreator(address newCreator) onlyTokenOwner public {\n', '    if (newCreator != address(0)) {\n', '      creator = newCreator;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyTokenOwner whenNotPaused public returns (bool) {\n', '    paused = true;\n', '    emit Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyTokenOwner whenPaused public returns (bool) {\n', '    paused = false;\n', '    emit Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    uint value = _value;\n', '    balances[msg.sender] = balances[msg.sender].sub(value);\n', '    balances[_to] = balances[_to].add(value);\n', '    emit Transfer(msg.sender, _to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '    uint value = _value;\n', '    balances[_to] = balances[_to].add(value);\n', '    balances[_from] = balances[_from].sub(value);\n', '    allowed[_from][msg.sender] = _allowance.sub(value);\n', '    emit Transfer(_from, _to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    uint value = _value;\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = value;\n', '    emit Approval(msg.sender, _spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyTokenOwner canMint public returns (bool) {\n', '    uint amount = _amount;\n', '    totalSupply = totalSupply.add(amount);\n', '    balances[_to] = balances[_to].add(amount);\n', '    emit Mint(_to, amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyTokenOwner public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint _value) whenNotPaused public returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specified amount of tokens.\n', '     * @param _value The amount of tokens to burn.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        uint value = _value;\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(value);\n', '        totalSupply = totalSupply.sub(value);\n', '        emit Burn(msg.sender, value);\n', '    }\n', '\n', '}\n', '\n', 'contract ERCDetailed is BurnableToken, PausableToken, MintableToken {\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint256 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint256 decimals, address _creator) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '        creator = _creator;\n', '    }\n', '\n', '    /**\n', '     * @return the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @return the symbol of the token.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @return the number of decimals of the token.\n', '     */\n', '    function decimals() public view returns (uint256) {\n', '        return _decimals;\n', '    }\n', '\n', '    function burn(uint256 _value) whenNotPaused public {\n', '        super.burn(_value);\n', '    }\n', '}\n', '\n', '//@dev contract creates new ERC-20 tokens\n', 'contract TokenFactory is Ownable {\n', '    address[] public deployedTokens;\n', '    ERCDetailed public newToken;\n', '    //@dev allows for check on which tokens are associated with a specific address\n', '    mapping (address => address) public myTokens;\n', '\n', '      //@dev fee for generating token contract\n', '    uint public tokenFee = 0.01 ether;\n', '    //@dev set token fee (owner only)\n', '    function setTokenFee(uint _fee) external onlyOwner {\n', '      tokenFee = _fee;\n', '}\n', '\n', '//@dev creates ERC-20 token\n', '    function createToken(string _name, string _symbol, uint256 _decimals) external payable returns (ERCDetailed) {\n', '        require(msg.value == tokenFee);\n', '        newToken = new ERCDetailed(_name, _symbol, _decimals, msg.sender);\n', '        deployedTokens.push(address(newToken));\n', '        myTokens[address(newToken)] = msg.sender;\n', '        return(newToken);\n', '    }\n', '\n', '//@dev gets list of all deployed tokens\n', '    function getDeployedTokens() public view returns (address[] memory) {\n', '        return deployedTokens;\n', '    }\n', '\n', '//@dev allows owner to withdraw fees\n', '      function withdraw() external onlyOwner {\n', '      address _owner = address(uint160(owner));\n', '      _owner.transfer(address(this).balance);\n', '      }\n', '}']
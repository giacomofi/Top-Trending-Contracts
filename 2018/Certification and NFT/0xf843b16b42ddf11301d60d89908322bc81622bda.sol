['pragma solidity ^0.4.18;\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/BurnableToken.sol\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '// File: contracts/Distribution.sol\n', '\n', '/**\n', ' * @title Distribution contract\n', ' * @dev see https://send.sd/distribution\n', ' */\n', 'contract Distribution is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  uint16 public stages;\n', '  uint256 public stageDuration;\n', '  uint256 public startTime;\n', '\n', '  uint256 public soldTokens;\n', '  uint256 public bonusClaimedTokens;\n', '  uint256 public raisedETH;\n', '  uint256 public raisedUSD;\n', '\n', '  uint256 public weiUsdRate;\n', '\n', '  BurnableToken public token;\n', '\n', '  bool public isActive;\n', '  uint256 public cap;\n', '  uint256 public stageCap;\n', '\n', '  mapping (address => mapping (uint16 => uint256)) public contributions;\n', '  mapping (uint16 => uint256) public sold;\n', '  mapping (uint16 => bool) public burned;\n', '  mapping (address => mapping (uint16 => bool)) public claimed;\n', '\n', '  event NewPurchase(\n', '    address indexed purchaser,\n', '    uint256 sdtAmount,\n', '    uint256 usdAmount,\n', '    uint256 ethAmount\n', '  );\n', '\n', '  event NewBonusClaim(\n', '    address indexed purchaser,\n', '    uint256 sdtAmount\n', '  );\n', '\n', '  function Distribution(\n', '      uint16 _stages,\n', '      uint256 _stageDuration,\n', '      address _token\n', '  ) public {\n', '    stages = _stages;\n', '    stageDuration = _stageDuration;\n', '    isActive = false;\n', '    token = BurnableToken(_token);\n', '  }\n', '\n', '  /**\n', '   * @dev contribution function\n', '   */\n', '  function () external payable {\n', '    require(isActive);\n', '    require(weiUsdRate > 0);\n', '    require(getStage() < stages);\n', '\n', '    uint256 usd = msg.value / weiUsdRate;\n', '    uint256 tokens = computeTokens(usd);\n', '    uint16 stage = getStage();\n', '\n', '    sold[stage] = sold[stage].add(tokens);\n', '    require(sold[stage] < stageCap);\n', '\n', '    contributions[msg.sender][stage] = contributions[msg.sender][stage].add(tokens);\n', '    soldTokens = soldTokens.add(tokens);\n', '    raisedETH = raisedETH.add(msg.value);\n', '    raisedUSD = raisedUSD.add(usd);\n', '\n', '    NewPurchase(msg.sender, tokens, usd, msg.value);\n', '    token.transfer(msg.sender, tokens);\n', '  }\n', '\n', '  /**\n', '   * @dev Initialize distribution\n', '   * @param _cap uint256 The amount of tokens for distribution\n', '   */\n', '  function init(uint256 _cap, uint256 _startTime) public onlyOwner {\n', '    require(!isActive);\n', '    require(token.balanceOf(this) == _cap);\n', '    require(_startTime > block.timestamp);\n', '\n', '    startTime = _startTime;\n', '    cap = _cap;\n', '    stageCap = cap / stages;\n', '    isActive = true;\n', '  }\n', '\n', '  /**\n', '   * @dev retrieve bonus from specified stage\n', '   * @param _stage uint16 The stage\n', '   */\n', '  function claimBonus(uint16 _stage) public {\n', '    require(!claimed[msg.sender][_stage]);\n', '    require(getStage() > _stage);\n', '\n', '    if (!burned[_stage]) {\n', '      token.burn(stageCap.sub(sold[_stage]).sub(sold[_stage].mul(computeBonus(_stage)).div(1 ether)));\n', '      burned[_stage] = true;\n', '    }\n', '\n', '    uint256 tokens = computeAddressBonus(_stage);\n', '    token.transfer(msg.sender, tokens);\n', '    bonusClaimedTokens = bonusClaimedTokens.add(tokens);\n', '    claimed[msg.sender][_stage] = true;\n', '\n', '    NewBonusClaim(msg.sender, tokens);\n', '  }\n', '\n', '  /**\n', '   * @dev set an exchange rate in wei\n', '   * @param _rate uint256 The new exchange rate\n', '   */\n', '  function setWeiUsdRate(uint256 _rate) public onlyOwner {\n', '    require(_rate > 0);\n', '    weiUsdRate = _rate;\n', '  }\n', '\n', '  /**\n', '   * @dev retrieve ETH\n', '   * @param _amount uint256 The new exchange rate\n', '   * @param _address address The address to receive ETH\n', '   */\n', '  function forwardFunds(uint256 _amount, address _address) public onlyOwner {\n', '    _address.transfer(_amount);\n', '  }\n', '\n', '  /**\n', '   * @dev compute tokens given a USD value\n', '   * @param _usd uint256 Value in USD\n', '   */\n', '  function computeTokens(uint256 _usd) public view returns(uint256) {\n', '    return _usd.mul(1000000000000000000 ether).div(\n', '      soldTokens.mul(19800000000000000000).div(cap).add(200000000000000000)\n', '    );\n', '  }\n', '\n', '  /**\n', '   * @dev current stage\n', '   */\n', '  function getStage() public view returns(uint16) {\n', '    require(block.timestamp >= startTime);\n', '    return uint16(uint256(block.timestamp).sub(startTime).div(stageDuration));\n', '  }\n', '\n', '  /**\n', '   * @dev compute bonus (%) for a specified stage\n', '   * @param _stage uint16 The stage\n', '   */\n', '  function computeBonus(uint16 _stage) public view returns(uint256) {\n', '    return uint256(100000000000000000).sub(sold[_stage].mul(100000).div(441095890411));\n', '  }\n', '\n', '  /**\n', '   * @dev compute for a specified stage\n', '   * @param _stage uint16 The stage\n', '   */\n', '  function computeAddressBonus(uint16 _stage) public view returns(uint256) {\n', '    return contributions[msg.sender][_stage].mul(computeBonus(_stage)).div(1 ether);\n', '  }\n', '\n', '  //////////\n', '  // Safety Methods\n', '  //////////\n', '  /// @notice This method can be used by the controller to extract mistakenly\n', '  ///  sent tokens to this contract.\n', '  /// @param _token The address of the token contract that you want to recover\n', '  ///  set to 0 in case you want to extract ether.\n', '  function claimTokens(address _token) public onlyOwner {\n', '    // owner can claim any token but SDT\n', '    require(_token != address(token));\n', '    if (_token == 0x0) {\n', '      owner.transfer(this.balance);\n', '      return;\n', '    }\n', '\n', '    ERC20Basic erc20token = ERC20Basic(_token);\n', '    uint256 balance = erc20token.balanceOf(this);\n', '    erc20token.transfer(owner, balance);\n', '    ClaimedTokens(_token, owner, balance);\n', '  }\n', '\n', '  event ClaimedTokens(\n', '    address indexed _token,\n', '    address indexed _controller,\n', '    uint256 _amount\n', '  );\n', '}']
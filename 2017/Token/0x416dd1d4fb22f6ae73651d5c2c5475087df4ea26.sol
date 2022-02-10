['pragma solidity ^0.4.15;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '  function Ownable() public { owner = msg.sender; }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {owner = newOwner;}\n', '}\n', '\n', 'contract ERC20Interface {\n', '\n', '  function totalSupply() public constant returns (uint256);\n', '\n', '  function balanceOf(address _owner) public constant returns (uint256);\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint256);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', ' }\n', '\n', 'contract GMPToken is Ownable, ERC20Interface {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  /* Public variables of the token */\n', '  string public constant name = "GMP Coin";\n', '  string public constant symbol = "GMP";\n', '  uint public constant decimals = 18;\n', '  uint256 public constant initialSupply = 220000000 * 1 ether;\n', '  uint256 public totalSupply;\n', '\n', '  /* This creates an array with all balances */\n', '  mapping (address => uint256) public balances;\n', '  mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '  /* Events */\n', '  event Burn(address indexed burner, uint256 value);\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  /* Constuctor: Initializes contract with initial supply tokens to the creator of the contract */\n', '  function GMPToken() public {\n', '      balances[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '      totalSupply = initialSupply;                        // Update total supply\n', '  }\n', '\n', '\n', '  /* Implementation of ERC20Interface */\n', '\n', '  function totalSupply() public constant returns (uint256) { return totalSupply; }\n', '\n', '  function balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }\n', '\n', '  /* Internal transfer, only can be called by this contract */\n', '  function _transfer(address _from, address _to, uint _amount) internal {\n', '      require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '      require (balances[_from] >= _amount);                // Check if the sender has enough\n', '      balances[_from] = balances[_from].sub(_amount);\n', '      balances[_to] = balances[_to].add(_amount);\n', '      Transfer(_from, _to, _amount);\n', '\n', '  }\n', '\n', '  function transfer(address _to, uint256 _amount) public returns (bool) {\n', '    _transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require (_value <= allowed[_from][msg.sender]);     // Check allowance\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    _transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _amount) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function mintToken(uint256 _mintedAmount) public onlyOwner {\n', '    balances[Ownable.owner] = balances[Ownable.owner].add(_mintedAmount);\n', '    totalSupply = totalSupply.add(_mintedAmount);\n', '    Mint(Ownable.owner, _mintedAmount);\n', '  }\n', '\n', '  //For refund only\n', '  function burnToken(address _burner, uint256 _value) public onlyOwner {\n', '    require(_value > 0);\n', '    require(_value <= balances[_burner]);\n', '\n', '    balances[_burner] = balances[_burner].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    Burn(_burner, _value);\n', '  }\n', '\n', '\n', '}\n', '\n', '\n', 'contract Crowdsale is Ownable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  GMPToken public token;\n', '\n', '  // Flag setting that investments are allowed (both inclusive)\n', '  bool public saleIsActive;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // Number of tokents for 1 ETH, i.e. 683 tokens for 1 ETH\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  /* -----------   A D M I N        F U N C T I O N S    ----------- */\n', '\n', '  function Crowdsale(uint256 _initialRate, address _targetWallet) public {\n', '\n', '    //Checks\n', '    require(_initialRate > 0);\n', '    require(_targetWallet != 0x0);\n', '\n', '    //Init\n', '    token = new GMPToken();\n', '    rate = _initialRate;\n', '    wallet = _targetWallet;\n', '    saleIsActive = true;\n', '\n', '  }\n', '\n', '  function close() public onlyOwner {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  //Transfer token to\n', '  function transferToAddress(address _targetWallet, uint256 _tokenAmount) public onlyOwner {\n', '    token.transfer(_targetWallet, _tokenAmount * 1 ether);\n', '  }\n', '\n', '\n', '  //Setters\n', '  function enableSale() public onlyOwner {\n', '    saleIsActive = true;\n', '  }\n', '\n', '  function disableSale() public onlyOwner {\n', '    saleIsActive = false;\n', '  }\n', '\n', '  function setRate(uint256 _newRate) public onlyOwner {\n', '    rate = _newRate;\n', '  }\n', '\n', '  //Mint new tokens\n', '  function mintToken(uint256 _mintedAmount) public onlyOwner {\n', '    token.mintToken(_mintedAmount);\n', '  }\n', '\n', '\n', '\n', '  /* -----------   P U B L I C      C A L L B A C K       F U N C T I O N     ----------- */\n', '\n', '  function () public payable {\n', '\n', '    require(msg.sender != 0x0);\n', '    require(saleIsActive);\n', '    require(msg.value >= 0.01 * 1 ether);\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    //Update total wei counter\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    //Calc number of tokents\n', '    uint256 tokenAmount = weiAmount.mul(rate);\n', '\n', '    //Forward wei to wallet account\n', '    wallet.transfer(weiAmount);\n', '\n', '    //Transfer token to sender\n', '    token.transfer(msg.sender, tokenAmount);\n', '    TokenPurchase(msg.sender, wallet, weiAmount, tokenAmount);\n', '\n', '  }\n', '\n', '\n', '\n', '}']
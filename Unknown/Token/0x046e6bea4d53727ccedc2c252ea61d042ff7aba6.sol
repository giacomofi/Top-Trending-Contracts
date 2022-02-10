['pragma solidity 0.4.15;\n', '\n', '// This code was taken from https://etherscan.io/address/0x3931E02C9AcB4f68D7617F19617A20acD3642607#code\n', '// This was a presale from ProofSuite.com\n', '// This was based on https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/Crowdsale.sol from what I saw\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', 'function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', ' }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '\n', '  uint256 public totalSupply;\n', '\n', '  function balanceOf(address _owner) constant returns (uint256);\n', '  function transfer(address _to, uint256 _value) returns (bool);\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool);\n', '  function approve(address _spender, uint256 _value) returns (bool);\n', '  function allowance(address _owner, address _spender) constant returns (uint256);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', '/**\n', ' * @title ZilleriumPresaleToken (ZILL)\n', ' * Standard Mintable ERC20 Token\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', '\n', 'contract ZilleriumPresaleToken is ERC20, Ownable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint) balances;\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  string public constant name = "Zillerium Presale Token";\n', '  string public constant symbol = "ZILL";\n', '  uint8 public constant decimals = 18;\n', '  bool public mintingFinished = false;\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  function ZilleriumPresaleToken() {}\n', '\n', '\n', '  function() payable {\n', '    revert();\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function transfer(address _to, uint _value) returns (bool) {\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '   // canMint removed from this line - the function kept failing on canMint\n', '  function mint(address _to, uint256 _amount) onlyOwner  returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '\n', '  function allowMinting() onlyOwner returns (bool) {\n', '    mintingFinished = false;\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ZilleriumPresale\n', ' * ZilleriumPresale allows investors to make\n', ' * token purchases and assigns them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', '\n', 'contract ZilleriumPresale is Pausable {\n', '  using SafeMath for uint256;\n', '\n', '  ZilleriumPresaleToken public token;\n', '\n', '\n', '  address public wallet; //wallet towards which the funds are forwarded\n', '  uint256 public weiRaised; //total amount of ether raised\n', '  uint256 public cap; // cap above which the presale ends\n', '  uint256 public minInvestment; // minimum investment\n', '  uint256 public rate; // number of tokens for one ether\n', '  bool public isFinalized;\n', '  string public contactInformation;\n', '\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  /**\n', '   * event for signaling finished crowdsale\n', '   */\n', '  event Finalized();\n', '\n', '\n', '  function ZilleriumPresale() {\n', '\n', '    token = createTokenContract();\n', '    wallet = 0x898091cB76927EE5B41a731EE15dDFdd0560a67b; // live\n', '    //  wallet = 0x48884f1f259a4fdbb22b77b56bfd486fe7784304; // testing\n', '    rate = 100;\n', '    minInvestment = 1 * (10**16);  //minimum investment in wei  (=.01 ether, this is based on wei being 10 to 18)\n', '    cap = 16600 * (10**18);  //cap in token base units (=295257 tokens)\n', '\n', '  }\n', '\n', '  // creates presale token\n', '  function createTokenContract() internal returns (ZilleriumPresaleToken) {\n', '    return new ZilleriumPresaleToken();\n', '  }\n', '\n', '  // fallback function to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * Low level token purchse function\n', '   * @param beneficiary will recieve the tokens.\n', '   */\n', '  function buyTokens(address beneficiary) payable whenNotPaused {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '\n', '    uint256 weiAmount = msg.value;\n', '    // update weiRaised\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    // compute amount of tokens created\n', '    uint256 tokens = weiAmount.mul(rate);\n', '\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '\n', '    uint256 weiAmount = weiRaised.add(msg.value);\n', '    bool notSmallAmount = msg.value >= minInvestment;\n', '    bool withinCap = weiAmount.mul(rate) <= cap;\n', '\n', '    return (notSmallAmount && withinCap);\n', '  }\n', '\n', '  //allow owner to finalize the presale once the presale is ended\n', '  function finalize() onlyOwner {\n', '    require(!isFinalized);\n', '    require(hasEnded());\n', '\n', '    token.finishMinting();\n', '    Finalized();\n', '\n', '    isFinalized = true;\n', '  }\n', '\n', '\n', '  function setContactInformation(string info) onlyOwner {\n', '      contactInformation = info;\n', '  }\n', '\n', '\n', '  //return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    bool capReached = (weiRaised.mul(rate) >= cap);\n', '    return capReached;\n', '  }\n', '\n', '}']
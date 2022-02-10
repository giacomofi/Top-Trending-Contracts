['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    \n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint _value) public {\n', '    require(_value > 0);\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    Burn(burner, _value);\n', '  }\n', '\n', '  event Burn(address indexed burner, uint indexed value);\n', '\n', '}\n', '\n', 'contract NVISIONCASH is BurnableToken {\n', '    \n', '  string public constant name = "NVISION CASH TOKEN";\n', '   \n', '  string public constant symbol = "NVCT";\n', '    \n', '  uint32 public constant decimals = 18;\n', '\n', '  uint256 public INITIAL_SUPPLY = 27500000 * 1 ether;\n', '\n', '  function NVISIONCASH() public {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '  }\n', '    \n', '}\n', '\n', 'contract Crowdsale is Ownable {\n', '    \n', '  using SafeMath for uint;\n', '    \n', '\n', '  NVISIONCASH public token = new NVISIONCASH();\n', '\n', '\n', '  uint per_p_sale;\n', '  \n', '  uint per_sale;\n', '  \n', '  uint start_ico;\n', ' \n', ' uint rate;\n', 'uint256 public ini_supply;\n', '  function Crowdsale() public {\n', '    rate = 50000 * 1 ether;\n', '    \n', '    ini_supply = 27500000 * 1 ether;\n', '    \n', '    uint256 ownerTokens = 2750000 * 1 ether;\n', '\n', '    token.transfer(owner, ownerTokens);\n', '  }\n', '\n', '  uint public refferBonus = 7;\n', '  function createTokens(address refferAddress)  payable public {\n', '\n', '    uint tokens = rate.mul(msg.value).div(1 ether);\n', '    uint refferGetToken = tokens.div(100).mul(refferBonus);\n', '    token.transfer(msg.sender, tokens);\n', '    token.transfer(refferAddress, refferGetToken);\n', '    \n', '  }\n', '  function createTokensWithoutReffer()  payable public {\n', '\n', '    uint tokens = rate.mul(msg.value).div(1 ether);\n', '    token.transfer(msg.sender, tokens);\n', '    \n', '  }\n', '  function refferBonusFunction(uint bonuseInpercentage) public onlyOwner{\n', '      refferBonus=bonuseInpercentage;\n', '  }\n', '  function airdropTokens(address[] _recipient,uint TokenAmount) public onlyOwner {\n', '    for(uint i = 0; i< _recipient.length; i++)\n', '    {\n', '          require(token.transfer(_recipient[i],TokenAmount));\n', '    }\n', '  }\n', '  //Just in case, owner wants to transfer Tokens from contract to owner address\n', '    function manualWithdrawToken(uint256 _amount) onlyOwner public {\n', '        uint tokenAmount = _amount * (1 ether);\n', '        token.transfer(msg.sender, tokenAmount);\n', '      }\n', '  function() external payable {\n', '    uint160 refferAddress = 0;\n', '    uint160 b = 0;\n', '\n', '    if(msg.data.length == 0)\n', '    {\n', '        createTokensWithoutReffer();\n', '    }\n', '    else\n', '    {\n', '        for (uint8 i = 0; i < 20; i++) {\n', '            refferAddress *= 256;\n', '            b = uint160(msg.data[i]);\n', '            refferAddress += (b);\n', '        }\n', '        createTokens(address(refferAddress));\n', '    }\n', '    forwardEherToOwner();\n', '  }\n', '  //Automatocally forwards ether from smart contract to owner address\n', '    function forwardEherToOwner() internal {\n', '        if (!owner.send(msg.value)) {\n', '          revert();\n', '        }\n', '      }\n', '    \n', '}']
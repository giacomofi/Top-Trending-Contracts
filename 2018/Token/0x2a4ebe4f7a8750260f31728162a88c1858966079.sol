['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', ' \n', ' \n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', ' function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant public returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) tokenBalances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(tokenBalances[msg.sender]>=_value);\n', '    tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);\n', '    tokenBalances[_to] = tokenBalances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '    return tokenBalances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract DRIVRNetworkToken is BasicToken,Ownable {\n', '\n', '   using SafeMath for uint256;\n', '   \n', '   string public constant name = "DRIVR Network";\n', '   string public constant symbol = "DVR";\n', '   uint256 public constant decimals = 18;\n', '\n', '   uint256 public constant INITIAL_SUPPLY = 750000000;\n', '  /**\n', '   * @dev Contructor that gives msg.sender all of existing tokens.\n', '   */\n', '    function DRIVRNetworkToken(address wallet) public {\n', '        owner = msg.sender;\n', '        totalSupply = INITIAL_SUPPLY * 10 ** 18;\n', '        tokenBalances[wallet] = totalSupply;   //Since we divided the token into 10^18 parts\n', '    }\n', '\n', '    function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {\n', '      require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell\n', "      tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance\n", "      tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance\n", '      Transfer(wallet, buyer, tokenAmount); \n', '      totalSupply = totalSupply.sub(tokenAmount);\n', '    }\n', '    function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {\n', '        tokenBalance = tokenBalances[addr];\n', '    }\n', '}']
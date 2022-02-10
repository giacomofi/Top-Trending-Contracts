['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  uint8 public decimals;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  \n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Exchange is Ownable {\n', '  mapping (address => bool) public supportedTokens;\n', '  event ExchangeEvent(address tokenToSell, address tokenToBuy, uint256 value);\n', '  \n', '  function setSupportedTokens(address tokenAddress, bool op) onlyOwner public {\n', '    supportedTokens[tokenAddress] = op;\n', '  }\n', '  \n', '    /**\n', '   *  exchange ERC20 tokens with 1:1.\n', '   */\n', '  function exchangeERC20(address _tokenToSell, address _tokenToBuy, uint256 _value) {\n', '    require(supportedTokens[_tokenToSell]);\n', '    require(supportedTokens[_tokenToBuy]);\n', '    require(_tokenToSell != _tokenToBuy);\n', '    \n', '    ERC20Basic tokenToSell = ERC20Basic(_tokenToSell);\n', '    ERC20Basic tokenToBuy = ERC20Basic(_tokenToBuy);\n', '\n', '    require(_value > 0 && tokenToBuy.balanceOf(this) >= _value);\n', '\n', '    if (!tokenToSell.transferFrom(msg.sender, address(this), _value)) throw;\n', '    tokenToBuy.transfer(msg.sender, _value);\n', '  \n', '    ExchangeEvent(_tokenToSell,_tokenToBuy,_value);\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  uint8 public decimals;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  \n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Exchange is Ownable {\n', '  mapping (address => bool) public supportedTokens;\n', '  event ExchangeEvent(address tokenToSell, address tokenToBuy, uint256 value);\n', '  \n', '  function setSupportedTokens(address tokenAddress, bool op) onlyOwner public {\n', '    supportedTokens[tokenAddress] = op;\n', '  }\n', '  \n', '    /**\n', '   *  exchange ERC20 tokens with 1:1.\n', '   */\n', '  function exchangeERC20(address _tokenToSell, address _tokenToBuy, uint256 _value) {\n', '    require(supportedTokens[_tokenToSell]);\n', '    require(supportedTokens[_tokenToBuy]);\n', '    require(_tokenToSell != _tokenToBuy);\n', '    \n', '    ERC20Basic tokenToSell = ERC20Basic(_tokenToSell);\n', '    ERC20Basic tokenToBuy = ERC20Basic(_tokenToBuy);\n', '\n', '    require(_value > 0 && tokenToBuy.balanceOf(this) >= _value);\n', '\n', '    if (!tokenToSell.transferFrom(msg.sender, address(this), _value)) throw;\n', '    tokenToBuy.transfer(msg.sender, _value);\n', '  \n', '    ExchangeEvent(_tokenToSell,_tokenToBuy,_value);\n', '  }\n', '}']
